$ErrorActionPreference = "Stop"
$path = "C:\Users\JIBAÑEZ\jimenapp\herramientas\calculadora-nutricional.xlsx"

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
$wb = $excel.Workbooks.Add()

$setProp = [System.Reflection.BindingFlags]::SetProperty
function Set-Val($cellObj, $value) {
    [void]$cellObj.GetType().InvokeMember("Value2", $setProp, $null, $cellObj, @($value))
}
function Cell($ws, $row, $col) { return $ws.Cells.Item($row, $col) }

function Style-Header($range) {
    $range.Font.Bold = $true
    $range.Font.Color = 0x321F5C
    $range.Interior.Color = 0xE9E4F3
    $range.Borders.LineStyle = 1
}
function Style-Label($cellObj) {
    $cellObj.Font.Bold = $true
    $cellObj.Font.Size = 10
}
function Style-Input($cellObj) {
    $cellObj.Interior.Color = 0xFAF6F2
    $cellObj.Borders.LineStyle = 1
}
function Style-Output($cellObj) {
    $cellObj.Interior.Color = 0xE4EFE4
    $cellObj.Borders.LineStyle = 1
    $cellObj.Font.Bold = $true
}

$ws = $wb.Worksheets.Item(1)
$ws.Name = "Calculadora nutricional"

$ws.Range("A1:D1").Merge() | Out-Null
Set-Val (Cell $ws 1 1) "CALCULADORA NUTRICIONAL — Jimena Ibañez"
$ws.Cells.Item(1,1).Font.Bold = $true
$ws.Cells.Item(1,1).Font.Size = 16
$ws.Cells.Item(1,1).Font.Color = 0x321F5C

Set-Val (Cell $ws 2 1) "Fórmula Mifflin-St Jeor + déficit/superávit ajustable. Reparto de macros por objetivo de recomposición corporal."
$ws.Cells.Item(2,1).Font.Italic = $true
$ws.Cells.Item(2,1).Font.Size = 9
$ws.Range("A2:D2").Merge() | Out-Null

# ---------- Datos ----------
$row = 4
Set-Val (Cell $ws $row 1) "DATOS"
Style-Header $ws.Range($ws.Cells.Item($row,1), $ws.Cells.Item($row,4))
$row++

Set-Val (Cell $ws $row 1) "Nombre"
Style-Label (Cell $ws $row 1)
$nombreCell = Cell $ws $row 2
Style-Input $nombreCell
$ws.Range($ws.Cells.Item($row,2), $ws.Cells.Item($row,4)).Merge() | Out-Null
$row++

Set-Val (Cell $ws $row 1) "Sexo"
Style-Label (Cell $ws $row 1)
$sexoCell = Cell $ws $row 2
Style-Input $sexoCell
$sexoCell.Validation.Delete()
$sexoCell.Validation.Add(3, 1, 1, "Mujer,Hombre") | Out-Null
Set-Val (Cell $ws $row 3) "Edad (años)"
Style-Label (Cell $ws $row 3)
$edadCell = Cell $ws $row 4
Style-Input $edadCell
$row++

Set-Val (Cell $ws $row 1) "Peso (kg)"
Style-Label (Cell $ws $row 1)
$pesoCell = Cell $ws $row 2
Style-Input $pesoCell
Set-Val (Cell $ws $row 3) "Altura (cm)"
Style-Label (Cell $ws $row 3)
$alturaCell = Cell $ws $row 4
Style-Input $alturaCell
$row++

Set-Val (Cell $ws $row 1) "Nivel de actividad"
Style-Label (Cell $ws $row 1)
$actividadCell = Cell $ws $row 2
Style-Input $actividadCell
$opcionesActividad = "Sedentario,Ligero (1-3 días/sem),Moderado (3-5 días/sem),Activo (6-7 días/sem),Muy activo (2x/día)"
$actividadCell.Validation.Delete()
$actividadCell.Validation.Add(3, 1, 1, $opcionesActividad) | Out-Null
$ws.Range($ws.Cells.Item($row,2), $ws.Cells.Item($row,2)).ColumnWidth = 28
$row++

Set-Val (Cell $ws $row 1) "Objetivo calórico"
Style-Label (Cell $ws $row 1)
$objetivoCell = Cell $ws $row 2
Style-Input $objetivoCell
$objetivoCell.Validation.Delete()
$objetivoCell.Validation.Add(3, 1, 1, "Déficit moderado (recomposición),Mantenimiento,Superávit leve") | Out-Null
$row++
$row++

# ---------- Referencia de factores (oculta a la vista pero visible, columna F en adelante) ----------
Set-Val (Cell $ws 6 6) "Actividad"
Set-Val (Cell $ws 6 7) "Factor"
Style-Header $ws.Range($ws.Cells.Item(6,6), $ws.Cells.Item(6,7))
$factores = @(
    @("Sedentario", 1.2),
    @("Ligero (1-3 días/sem)", 1.375),
    @("Moderado (3-5 días/sem)", 1.55),
    @("Activo (6-7 días/sem)", 1.725),
    @("Muy activo (2x/día)", 1.9)
)
for ($i=0; $i -lt $factores.Length; $i++) {
    $rr = 7 + $i
    Set-Val (Cell $ws $rr 6) $factores[$i][0]
    Set-Val (Cell $ws $rr 7) ([double]$factores[$i][1])
}

Set-Val (Cell $ws 13 6) "Objetivo"
Set-Val (Cell $ws 13 7) "Ajuste kcal/día"
Style-Header $ws.Range($ws.Cells.Item(13,6), $ws.Cells.Item(13,7))
$ajustes = @(
    @("Déficit moderado (recomposición)", -300.0),
    @("Mantenimiento", 0.0),
    @("Superávit leve", 250.0)
)
for ($i=0; $i -lt $ajustes.Length; $i++) {
    $rr = 14 + $i
    Set-Val (Cell $ws $rr 6) $ajustes[$i][0]
    Set-Val (Cell $ws $rr 7) ([double]$ajustes[$i][1])
}

$ws.Range($ws.Cells.Item(6,6), $ws.Cells.Item(16,7)).Font.Size = 9
$ws.Range($ws.Cells.Item(6,6), $ws.Cells.Item(16,7)).Font.Color = 0x999999

# ---------- Resultados ----------
$row = 11
Set-Val (Cell $ws $row 1) "RESULTADOS"
Style-Header $ws.Range($ws.Cells.Item($row,1), $ws.Cells.Item($row,4))
$row++

$pesoAddr = $pesoCell.Address($false,$false)
$alturaAddr = $alturaCell.Address($false,$false)
$edadAddr = $edadCell.Address($false,$false)
$sexoAddr = $sexoCell.Address($false,$false)
$actividadAddr = $actividadCell.Address($false,$false)
$objetivoAddr = $objetivoCell.Address($false,$false)

Set-Val (Cell $ws $row 1) "TMB (Mifflin-St Jeor) — kcal/día"
Style-Label (Cell $ws $row 1)
$tmbCell = Cell $ws $row 3
$ws.Range($ws.Cells.Item($row,3), $ws.Cells.Item($row,4)).Merge() | Out-Null
Style-Output $tmbCell
$tmbCell.Formula = "=IF(OR($pesoAddr=`"`",$alturaAddr=`"`",$edadAddr=`"`",$sexoAddr=`"`"),`"`",IF($sexoAddr=`"Hombre`",10*$pesoAddr+6.25*$alturaAddr-5*$edadAddr+5,10*$pesoAddr+6.25*$alturaAddr-5*$edadAddr-161))"
$tmbCell.NumberFormat = "0"
$tmbRow = $row
$row++

Set-Val (Cell $ws $row 1) "TDEE (gasto total) — kcal/día"
Style-Label (Cell $ws $row 1)
$tdeeCell = Cell $ws $row 3
$ws.Range($ws.Cells.Item($row,3), $ws.Cells.Item($row,4)).Merge() | Out-Null
Style-Output $tdeeCell
$tmbAddr = $tmbCell.Address($false,$false)
$tdeeCell.Formula = "=IF(OR($tmbAddr=`"`",$actividadAddr=`"`"),`"`",$tmbAddr*IFERROR(VLOOKUP($actividadAddr,`$F`$7:`$G`$11,2,FALSE),1))"
$tdeeCell.NumberFormat = "0"
$tdeeRow = $row
$row++

Set-Val (Cell $ws $row 1) "Calorías objetivo — kcal/día"
Style-Label (Cell $ws $row 1)
$calObjCell = Cell $ws $row 3
$ws.Range($ws.Cells.Item($row,3), $ws.Cells.Item($row,4)).Merge() | Out-Null
Style-Output $calObjCell
$tdeeAddr = $tdeeCell.Address($false,$false)
$calObjCell.Formula = "=IF(OR($tdeeAddr=`"`",$objetivoAddr=`"`"),`"`",$tdeeAddr+IFERROR(VLOOKUP($objetivoAddr,`$F`$14:`$G`$16,2,FALSE),0))"
$calObjCell.NumberFormat = "0"
$calObjRow = $row
$row++
$row++

Set-Val (Cell $ws $row 1) "MACRONUTRIENTES"
Style-Header $ws.Range($ws.Cells.Item($row,1), $ws.Cells.Item($row,4))
$row++

Set-Val (Cell $ws $row 1) ""
Set-Val (Cell $ws $row 2) "g / día"
Set-Val (Cell $ws $row 3) "kcal / día"
Set-Val (Cell $ws $row 4) "% de calorías objetivo"
Style-Header $ws.Range($ws.Cells.Item($row,1), $ws.Cells.Item($row,4))
$row++

$calObjAddr = $calObjCell.Address($false,$false)

# Proteína: 2 g/kg
Set-Val (Cell $ws $row 1) "Proteína (2 g/kg)"
Style-Label (Cell $ws $row 1)
$protGCell = Cell $ws $row 2
Style-Output $protGCell
$protGCell.Formula = "=IF($pesoAddr=`"`",`"`",$pesoAddr*2)"
$protGCell.NumberFormat = "0"
$protKcalCell = Cell $ws $row 3
Style-Output $protKcalCell
$protGAddr = $protGCell.Address($false,$false)
$protKcalCell.Formula = "=IF($protGAddr=`"`",`"`",$protGAddr*4)"
$protKcalCell.NumberFormat = "0"
$protPctCell = Cell $ws $row 4
Style-Output $protPctCell
$protKcalAddr = $protKcalCell.Address($false,$false)
$protPctCell.Formula = "=IF(OR($protKcalAddr=`"`",$calObjAddr=`"`"),`"`",$protKcalAddr/$calObjAddr)"
$protPctCell.NumberFormat = "0%"
$row++

# Grasas: 27.5% de calorías objetivo (punto medio de 25-30%)
Set-Val (Cell $ws $row 1) "Grasas (27.5% de kcal objetivo)"
Style-Label (Cell $ws $row 1)
$grasaKcalCell = Cell $ws $row 3
Style-Output $grasaKcalCell
$grasaKcalCell.Formula = "=IF($calObjAddr=`"`",`"`",$calObjAddr*0.275)"
$grasaKcalCell.NumberFormat = "0"
$grasaGCell = Cell $ws $row 2
Style-Output $grasaGCell
$grasaKcalAddr = $grasaKcalCell.Address($false,$false)
$grasaGCell.Formula = "=IF($grasaKcalAddr=`"`",`"`",$grasaKcalAddr/9)"
$grasaGCell.NumberFormat = "0"
$grasaPctCell = Cell $ws $row 4
Style-Output $grasaPctCell
$grasaPctCell.Formula = "=IF(OR($grasaKcalAddr=`"`",$calObjAddr=`"`"),`"`",$grasaKcalAddr/$calObjAddr)"
$grasaPctCell.NumberFormat = "0%"
$row++

# Carbohidratos: resto
Set-Val (Cell $ws $row 1) "Carbohidratos (resto)"
Style-Label (Cell $ws $row 1)
$carboKcalCell = Cell $ws $row 3
Style-Output $carboKcalCell
$carboKcalCell.Formula = "=IF(OR($calObjAddr=`"`",$protKcalAddr=`"`",$grasaKcalAddr=`"`"),`"`",$calObjAddr-$protKcalAddr-$grasaKcalAddr)"
$carboKcalCell.NumberFormat = "0"
$carboGCell = Cell $ws $row 2
Style-Output $carboGCell
$carboKcalAddr = $carboKcalCell.Address($false,$false)
$carboGCell.Formula = "=IF($carboKcalAddr=`"`",`"`",$carboKcalAddr/4)"
$carboGCell.NumberFormat = "0"
$carboPctCell = Cell $ws $row 4
Style-Output $carboPctCell
$carboPctCell.Formula = "=IF(OR($carboKcalAddr=`"`",$calObjAddr=`"`"),`"`",$carboKcalAddr/$calObjAddr)"
$carboPctCell.NumberFormat = "0%"
$row++
$row++

$ws.Range($ws.Cells.Item($row,1), $ws.Cells.Item($row,4)).Merge() | Out-Null
Set-Val (Cell $ws $row 1) "Esta calculadora es una estimación orientativa (fórmula Mifflin-St Jeor) para uso interno en la planificación con alumnas. No reemplaza una evaluación nutricional profesional en casos de patologías metabólicas u hormonales relevantes (SOP, hipotiroidismo, resistencia a la insulina, etc.) — en esos casos, derivar a nutricionista."
$ws.Cells.Item($row,1).Font.Italic = $true
$ws.Cells.Item($row,1).Font.Size = 9
$ws.Cells.Item($row,1).WrapText = $true
$ws.Rows.Item($row).RowHeight = 42

$ws.Columns.Item(1).ColumnWidth = 32
$ws.Columns.Item(2).ColumnWidth = 16
$ws.Columns.Item(3).ColumnWidth = 16
$ws.Columns.Item(4).ColumnWidth = 20
$ws.Columns.Item(6).ColumnWidth = 30
$ws.Columns.Item(7).ColumnWidth = 12

$wb.SaveAs($path, 51)
$wb.Close($false)
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
Write-Output "OK: $path"

