$ErrorActionPreference = "Stop"
$path = "C:\Users\JIBAÑEZ\jimenapp\herramientas\planificador-mesociclos.xlsx"

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
$wb = $excel.Workbooks.Add()

$setProp = [System.Reflection.BindingFlags]::SetProperty

function Set-Val($cellObj, $value) {
    [void]$cellObj.GetType().InvokeMember("Value2", $setProp, $null, $cellObj, @($value))
}

function Cell($ws, $row, $col) {
    return $ws.Cells.Item($row, $col)
}

function Style-Header($range) {
    $range.Font.Bold = $true
    $range.Font.Color = 0x321F5C
    $range.Interior.Color = 0xE9E4F3
    $range.Borders.LineStyle = 1
    $range.HorizontalAlignment = -4108
}

# ---------- Hoja 1: Datos ----------
$wsDatos = $wb.Worksheets.Item(1)
$wsDatos.Name = "Datos"
$wsDatos.Range("A1:C1").Merge() | Out-Null
Set-Val (Cell $wsDatos 1 1) "DATOS DE LA ALUMNA Y 1RM DE REFERENCIA"
$wsDatos.Cells.Item(1,1).Font.Bold = $true
$wsDatos.Cells.Item(1,1).Font.Size = 14
$wsDatos.Cells.Item(1,1).Font.Color = 0x321F5C

Set-Val (Cell $wsDatos 3 1) "Nombre"
$wsDatos.Cells.Item(3,1).Font.Bold = $true
$wsDatos.Cells.Item(3,2).Interior.Color = 0xFAF6F2
$wsDatos.Cells.Item(3,2).Borders.LineStyle = 1

Set-Val (Cell $wsDatos 4 1) "Fecha inicio del mesociclo"
$wsDatos.Cells.Item(4,1).Font.Bold = $true
$wsDatos.Cells.Item(4,2).Interior.Color = 0xFAF6F2
$wsDatos.Cells.Item(4,2).Borders.LineStyle = 1
$wsDatos.Cells.Item(4,2).NumberFormat = "dd/mm/yyyy"

Set-Val (Cell $wsDatos 4 3) "Modelo: acumulación -> intensificación -> descarga, autorregulado por RPE"
$wsDatos.Cells.Item(4,3).Font.Italic = $true
$wsDatos.Cells.Item(4,3).Font.Size = 9

$headerRow = 6
$headers = @("Ejercicio", "1RM estimado (kg)", "Notas")
for ($i=0; $i -lt $headers.Length; $i++) {
    Set-Val (Cell $wsDatos $headerRow ($i+1)) $headers[$i]
}
Style-Header $wsDatos.Range($wsDatos.Cells.Item($headerRow,1), $wsDatos.Cells.Item($headerRow,3))

$ejercicios = @("Sentadilla", "Peso muerto", "Press banca", "Press militar", "Remo")
for ($i=0; $i -lt $ejercicios.Length; $i++) {
    $r = $headerRow + 1 + $i
    Set-Val (Cell $wsDatos $r 1) $ejercicios[$i]
    $wsDatos.Cells.Item($r,2).Interior.Color = 0xFAF6F2
    $wsDatos.Cells.Item($r,2).Borders.LineStyle = 1
    $wsDatos.Cells.Item($r,3).Interior.Color = 0xFAF6F2
    $wsDatos.Cells.Item($r,3).Borders.LineStyle = 1
}
$wsDatos.Columns.Item(1).ColumnWidth = 22
$wsDatos.Columns.Item(2).ColumnWidth = 18
$wsDatos.Columns.Item(3).ColumnWidth = 45

# ---------- Hoja 2: Tabla RPE ----------
$wsRpe = $wb.Worksheets.Add()
$wsRpe.Name = "Tabla RPE"
$wsRpe.Range("A1:K1").Merge() | Out-Null
Set-Val (Cell $wsRpe 1 1) "TABLA RPE -> %1RM (referencia para autorregulación)"
$wsRpe.Cells.Item(1,1).Font.Bold = $true
$wsRpe.Cells.Item(1,1).Font.Size = 14
$wsRpe.Cells.Item(1,1).Font.Color = 0x321F5C

Set-Val (Cell $wsRpe 3 1) "Reps \ RPE"
$rpeCols = @(6.0,6.5,7.0,7.5,8.0,8.5,9.0,9.5,10.0)
for ($j=0; $j -lt $rpeCols.Length; $j++) {
    Set-Val (Cell $wsRpe 3 ($j+2)) $rpeCols[$j]
}
Style-Header $wsRpe.Range($wsRpe.Cells.Item(3,1), $wsRpe.Cells.Item(3,10))

# Standard %1RM chart by reps (rows 1-10) x RPE 6..10 step .5 (columns)
$chart = @{
    1  = @(0.86,0.87,0.89,0.90,0.92,0.94,0.96,0.98,1.00)
    2  = @(0.84,0.85,0.87,0.88,0.90,0.92,0.94,0.96,0.98)
    3  = @(0.81,0.83,0.84,0.86,0.88,0.90,0.92,0.94,0.96)
    4  = @(0.79,0.81,0.82,0.84,0.86,0.88,0.90,0.92,0.94)
    5  = @(0.77,0.78,0.80,0.82,0.84,0.86,0.88,0.90,0.92)
    6  = @(0.74,0.76,0.78,0.80,0.82,0.84,0.86,0.88,0.90)
    7  = @(0.72,0.74,0.76,0.78,0.80,0.82,0.84,0.86,0.88)
    8  = @(0.70,0.72,0.74,0.76,0.78,0.80,0.82,0.84,0.86)
    9  = @(0.68,0.70,0.72,0.74,0.76,0.78,0.80,0.82,0.84)
    10 = @(0.66,0.68,0.70,0.72,0.74,0.76,0.78,0.80,0.82)
}
for ($reps=1; $reps -le 10; $reps++) {
    $r = 3 + $reps
    Set-Val (Cell $wsRpe $r 1) ([double]$reps)
    $wsRpe.Cells.Item($r,1).Font.Bold = $true
    $rowVals = $chart[$reps]
    for ($j=0; $j -lt $rowVals.Length; $j++) {
        $c = Cell $wsRpe $r ($j+2)
        Set-Val $c $rowVals[$j]
        $c.NumberFormat = "0%"
        $c.Borders.LineStyle = 1
    }
}
$wsRpe.Columns.Item(1).ColumnWidth = 14
for ($j=2; $j -le 10; $j++) { $wsRpe.Columns.Item($j).ColumnWidth = 8 }

$note = Cell $wsRpe 16 1
Set-Val $note "Tabla de referencia estándar (Tuchscherer / RTS). Usar como guía; ajustar siempre con sensación real de la alumna en la sesión."
$note.Font.Italic = $true
$note.Font.Size = 9
$wsRpe.Range($wsRpe.Cells.Item(16,1), $wsRpe.Cells.Item(16,9)).Merge() | Out-Null
$note.WrapText = $true

# ---------- Hoja 3: Planificador ----------
$wsPlan = $wb.Worksheets.Add()
$wsPlan.Name = "Planificador"
$wsPlan.Range("A1:L1").Merge() | Out-Null
Set-Val (Cell $wsPlan 1 1) "PLANIFICADOR DE MESOCICLO (6 semanas: 3 acumulación / 2 intensificación / 1 descarga)"
$wsPlan.Cells.Item(1,1).Font.Bold = $true
$wsPlan.Cells.Item(1,1).Font.Size = 14
$wsPlan.Cells.Item(1,1).Font.Color = 0x321F5C

$cols = @("Bloque","Semana","Día","Tipo de ejercicio","Ejercicio","Series","Reps objetivo","RPE objetivo","%1RM (tabla)","Carga sugerida (kg)","Carga real (kg)","RPE real / Notas")
$headerRow = 3
for ($i=0; $i -lt $cols.Length; $i++) {
    Set-Val (Cell $wsPlan $headerRow ($i+1)) $cols[$i]
}
Style-Header $wsPlan.Range($wsPlan.Cells.Item($headerRow,1), $wsPlan.Cells.Item($headerRow,12))
$wsPlan.Rows.Item($headerRow).WrapText = $true

$bloques = @(
    @{nombre="Acumulación"; semanas=@(1,2,3); reps=10.0; rpe=7.0},
    @{nombre="Intensificación"; semanas=@(4,5); reps=6.0; rpe=8.5},
    @{nombre="Descarga"; semanas=@(6); reps=8.0; rpe=6.0}
)
$dias = @("Día 1","Día 2")
$tipos = @("Principal (fuerza)", "Accesorio (hipertrofia)", "Finalizador metabólico")

$r = $headerRow + 1
foreach ($bloque in $bloques) {
    foreach ($semana in $bloque.semanas) {
        foreach ($dia in $dias) {
            foreach ($tipo in $tipos) {
                Set-Val (Cell $wsPlan $r 1) $bloque.nombre
                Set-Val (Cell $wsPlan $r 2) ([double]$semana)
                Set-Val (Cell $wsPlan $r 3) $dia
                Set-Val (Cell $wsPlan $r 4) $tipo

                $ejCell = Cell $wsPlan $r 5
                $ejCell.Interior.Color = 0xFAF6F2
                $ejCell.Borders.LineStyle = 1

                $seriesCell = Cell $wsPlan $r 6
                $seriesCell.Interior.Color = 0xFAF6F2
                $seriesCell.Borders.LineStyle = 1

                $repsCell = Cell $wsPlan $r 7
                $rpeCell = Cell $wsPlan $r 8

                if ($tipo -eq "Finalizador metabólico") {
                    foreach ($col in 9..10) {
                        $wsPlan.Cells.Item($r,$col).Interior.Color = 0xE9E9E9
                    }
                    $wsPlan.Cells.Item($r,11).Interior.Color = 0xFAF6F2
                    $wsPlan.Cells.Item($r,11).Borders.LineStyle = 1
                } else {
                    Set-Val $seriesCell ([double]3)
                    Set-Val $repsCell ([double]$bloque.reps)
                    $repsCell.Interior.Color = 0xFAF6F2
                    $repsCell.Borders.LineStyle = 1
                    Set-Val $rpeCell ([double]$bloque.rpe)
                    $rpeCell.Interior.Color = 0xFAF6F2
                    $rpeCell.Borders.LineStyle = 1

                    $pctCell = Cell $wsPlan $r 9
                    $repsAddr = $repsCell.Address($false,$false)
                    $rpeAddr = $rpeCell.Address($false,$false)
                    $pctCell.Formula = "=IFERROR(INDEX('Tabla RPE'!`$B`$4:`$J`$13,MATCH($repsAddr,'Tabla RPE'!`$A`$4:`$A`$13,0),MATCH($rpeAddr,'Tabla RPE'!`$B`$3:`$J`$3,0)),`"`")"
                    $pctCell.NumberFormat = "0%"
                    $pctCell.Borders.LineStyle = 1

                    $cargaCell = Cell $wsPlan $r 10
                    $ejAddr = $ejCell.Address($false,$false)
                    $pctAddr = $pctCell.Address($false,$false)
                    $cargaCell.Formula = "=IFERROR(VLOOKUP($ejAddr,Datos!`$A`$7:`$B`$11,2,FALSE)*$pctAddr,`"`")"
                    $cargaCell.NumberFormat = "0.0"
                    $cargaCell.Borders.LineStyle = 1
                }

                $cargaRealCell = Cell $wsPlan $r 11
                $cargaRealCell.Interior.Color = 0xFAF6F2
                $cargaRealCell.Borders.LineStyle = 1

                $notasCell = Cell $wsPlan $r 12
                $notasCell.Interior.Color = 0xFAF6F2
                $notasCell.Borders.LineStyle = 1

                $r++
            }
        }
    }
}

for ($c=1; $c -le 12; $c++) { $wsPlan.Columns.Item($c).ColumnWidth = 15 }
$wsPlan.Columns.Item(5).ColumnWidth = 20
$wsPlan.Columns.Item(12).ColumnWidth = 24
$wsPlan.Range("A4").Select() | Out-Null
$excel.ActiveWindow.FreezePanes = $true

$wsDatos.Activate()

$wb.SaveAs($path, 51)
$wb.Close($false)
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
Write-Output "OK: $path"

