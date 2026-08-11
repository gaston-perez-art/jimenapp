$ErrorActionPreference = "Stop"
$path = "C:\Users\JIBAÑEZ\jimenapp\herramientas\ficha-ingreso.xlsx"

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
$wb = $excel.Workbooks.Add()
$ws = $wb.Worksheets.Item(1)
$ws.Name = "Ficha de ingreso"

function Set-Section($row, $title) {
    $ws.Cells.Item($row, 1).Value2 = $title
    $r = $ws.Range($ws.Cells.Item($row,1), $ws.Cells.Item($row,4))
    $r.Merge() | Out-Null
    $r.Font.Bold = $true
    $r.Font.Size = 12
    $r.Font.Color = 0x321F5C  # BGR wine
    $r.Interior.Color = 0xE9E4F3  # light wine bg (BGR)
    $r.Borders.Weight = 2
}

function Set-Label($row, $col, $text) {
    $c = $ws.Cells.Item($row, $col)
    $c.Value2 = $text
    $c.Font.Bold = $true
    $c.Font.Size = 10
}

function Set-InputCell($row, $col, $mergeTo) {
    if ($mergeTo) {
        $r = $ws.Range($ws.Cells.Item($row,$col), $ws.Cells.Item($row,$mergeTo))
        $r.Merge() | Out-Null
        $r.Interior.Color = 0xFAF6F2  # paper bg
        $r.Borders.LineStyle = 1
        return $r
    } else {
        $c = $ws.Cells.Item($row, $col)
        $c.Interior.Color = 0xFAF6F2
        $c.Borders.LineStyle = 1
        return $c
    }
}

# Title
$ws.Range("A1:D1").Merge() | Out-Null
$ws.Cells.Item(1,1).Value2 = "FICHA DE INGRESO — Jimena Ibañez"
$ws.Cells.Item(1,1).Font.Bold = $true
$ws.Cells.Item(1,1).Font.Size = 16
$ws.Cells.Item(1,1).Font.Color = 0x321F5C
$ws.Range("A1:D1").RowHeight = 28

$row = 3

Set-Section $row "Datos personales"; $row++
Set-Label $row 1 "Nombre completo"; Set-InputCell $row 2 4 | Out-Null; $row++
Set-Label $row 1 "Fecha de nacimiento"; Set-InputCell $row 2 $null | Out-Null
Set-Label $row 3 "Edad"; Set-InputCell $row 4 $null | Out-Null; $row++
Set-Label $row 1 "Teléfono / WhatsApp"; Set-InputCell $row 2 $null | Out-Null
Set-Label $row 3 "Email"; Set-InputCell $row 4 $null | Out-Null; $row++
Set-Label $row 1 "Ocupación"; Set-InputCell $row 2 4 | Out-Null; $row++
Set-Label $row 1 "Fecha de la ficha"; $c = Set-InputCell $row 2 $null; $c.Value2 = "=TODAY()"; $c.NumberFormat = "dd/mm/yyyy"; $row++
$row++

Set-Section $row "Objetivo"; $row++
Set-Label $row 1 "Motivo de consulta"; Set-InputCell $row 2 4 | Out-Null; $ws.Rows.Item($row).RowHeight = 30; $row++
Set-Label $row 1 "Objetivo principal"; Set-InputCell $row 2 4 | Out-Null; $row++
Set-Label $row 1 "Objetivo secundario"; Set-InputCell $row 2 4 | Out-Null; $row++
$row++

Set-Section $row "Historial de salud"; $row++
Set-Label $row 1 "¿Condición médica diagnosticada?"; $c1 = Set-InputCell $row 2 $null
Set-Label $row 3 "Detalle"; Set-InputCell $row 4 $null | Out-Null; $row++
$condRow = $row
Set-Label $row 1 "Condiciones hormonales (marcar con X)"; $row++
Set-Label $row 1 "Perimenopausia"; Set-InputCell $row 2 $null | Out-Null
Set-Label $row 3 "Menopausia"; Set-InputCell $row 4 $null | Out-Null; $row++
Set-Label $row 1 "Resistencia a la insulina"; Set-InputCell $row 2 $null | Out-Null
Set-Label $row 3 "SOP"; Set-InputCell $row 4 $null | Out-Null; $row++
Set-Label $row 1 "Hipotiroidismo"; Set-InputCell $row 2 $null | Out-Null
Set-Label $row 3 "Ninguna"; Set-InputCell $row 4 $null | Out-Null; $row++
Set-Label $row 1 "¿Toma medicación actualmente?"; $c2 = Set-InputCell $row 2 $null
Set-Label $row 3 "Detalle"; Set-InputCell $row 4 $null | Out-Null; $row++
Set-Label $row 1 "¿Lesiones o cirugías previas?"; $c3 = Set-InputCell $row 2 $null
Set-Label $row 3 "Detalle"; Set-InputCell $row 4 $null | Out-Null; $row++
Set-Label $row 1 "¿Indicación médica que limite el ejercicio?"; $c4 = Set-InputCell $row 2 $null
Set-Label $row 3 "Detalle"; Set-InputCell $row 4 $null | Out-Null; $row++
$row++

Set-Section $row "Historial de entrenamiento"; $row++
Set-Label $row 1 "¿Entrenó anteriormente?"; $c5 = Set-InputCell $row 2 $null
Set-Label $row 3 "¿Qué / cuánto tiempo?"; Set-InputCell $row 4 $null | Out-Null; $row++
Set-Label $row 1 "Actividad física actual (aparte)"; Set-InputCell $row 2 4 | Out-Null; $row++
Set-Label $row 1 "Disponibilidad semanal (días)"; Set-InputCell $row 2 $null | Out-Null
Set-Label $row 3 "Horarios preferidos"; Set-InputCell $row 4 $null | Out-Null; $row++
Set-Label $row 1 "Lugar de entrenamiento"; Set-InputCell $row 2 $null | Out-Null
Set-Label $row 3 "Equipamiento disponible"; Set-InputCell $row 4 $null | Out-Null; $row++
$row++

Set-Section $row "Datos antropométricos iniciales"; $row++
Set-Label $row 1 "Peso (kg)"; $pesoCell = Set-InputCell $row 2 $null
Set-Label $row 3 "Altura (cm)"; $alturaCell = Set-InputCell $row 4 $null; $row++
Set-Label $row 1 "IMC (calculado)"
$imcCell = Set-InputCell $row 2 $null
$pesoAddr = $pesoCell.Address($false,$false)
$alturaAddr = $alturaCell.Address($false,$false)
$imcCell.Formula = "=IF(AND($pesoAddr<>`"`",$alturaAddr<>`"`"),$pesoAddr/(($alturaAddr/100)^2),`"`")"
$imcCell.NumberFormat = "0.0"
$row++
Set-Label $row 1 "Cintura (cm)"; Set-InputCell $row 2 $null | Out-Null
Set-Label $row 3 "Cadera (cm)"; Set-InputCell $row 4 $null | Out-Null; $row++
Set-Label $row 1 "Brazo (cm)"; Set-InputCell $row 2 $null | Out-Null
Set-Label $row 3 "Pierna (cm)"; Set-InputCell $row 4 $null | Out-Null; $row++
Set-Label $row 1 "% Grasa corporal (si se conoce)"; Set-InputCell $row 2 $null | Out-Null; $row++
$row++

Set-Section $row "Hábitos"; $row++
Set-Label $row 1 "Horas de sueño promedio"; Set-InputCell $row 2 $null | Out-Null
Set-Label $row 3 "Nivel de estrés (1-10)"; Set-InputCell $row 4 $null | Out-Null; $row++
Set-Label $row 1 "Alimentación actual (breve)"; Set-InputCell $row 2 4 | Out-Null; $ws.Rows.Item($row).RowHeight = 30; $row++
Set-Label $row 1 "Consumo de agua diario"; Set-InputCell $row 2 4 | Out-Null; $row++
$row++

Set-Section $row "Consentimiento"; $row++
Set-Label $row 1 "Declaro que la información brindada es correcta"; $c6 = Set-InputCell $row 2 $null; $row++
Set-Label $row 1 "Autorizo el uso de mis datos para el seguimiento de mi entrenamiento (uso interno, no publicación pública sin autorización expresa)"
$ws.Range($ws.Cells.Item($row,1),$ws.Cells.Item($row,1)).WrapText = $true
$c7 = Set-InputCell $row 2 $null; $row++
Set-Label $row 1 "Firma"; Set-InputCell $row 2 $null | Out-Null
Set-Label $row 3 "Fecha"; Set-InputCell $row 4 $null | Out-Null; $row++
$row++

$ws.Range($ws.Cells.Item($row,1),$ws.Cells.Item($row,4)).Merge() | Out-Null
$ws.Cells.Item($row,1).Value2 = "Este formulario no reemplaza una consulta médica. Ante cualquier condición de salud relevante, se recomienda evaluación profesional antes de iniciar el programa."
$ws.Cells.Item($row,1).Font.Italic = $true
$ws.Cells.Item($row,1).Font.Size = 9
$ws.Cells.Item($row,1).WrapText = $true
$ws.Rows.Item($row).RowHeight = 28

# Data validation dropdowns (Sí/No) for the Sí/No cells
foreach ($cell in @($c1,$c2,$c3,$c4,$c5,$c6,$c7)) {
    $cell.Validation.Delete()
    $cell.Validation.Add(3, 1, 1, "Sí,No") | Out-Null
}

$ws.Columns.Item(1).ColumnWidth = 34
$ws.Columns.Item(2).ColumnWidth = 22
$ws.Columns.Item(3).ColumnWidth = 22
$ws.Columns.Item(4).ColumnWidth = 22
$ws.Cells.Item(1,1).EntireColumn.AutoFit() | Out-Null

$wb.SaveAs($path, 51)
$wb.Close($false)
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
Write-Output "OK: $path"

