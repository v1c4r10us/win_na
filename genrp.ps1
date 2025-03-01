Import-Module ImportExcel
$DataFrame = Import-Excel -Path 'report.xlsx' -WorksheetName 'Sheet1'
$DataFrame = $DataFrame[0..($DataFrame.Count - 4)]
$DataFrame = $DataFrame | Select-Object Inicio, 'Min.', 'Nivel 1', 'Nivel 3', Detalle
$DataFrame = $DataFrame | Where-Object { $_.'Nivel 3' -eq 'REGULACION DEL EQUIPO POR MANTENIMIENTO' }
$DataFrame.'Min.' = [Math]::Round($DataFrame.'Min.', 2)
$DataFrame | Export-Csv -Path 'rep.csv' -NoTypeInformation
