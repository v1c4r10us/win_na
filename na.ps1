$ipList = Read-Host "IPs: "
$npacket = Read-Host "Packets: "

$ipArray = $ipList -split ',' | ForEach-Object { $_.Trim() }

$outputFile = "results.csv"

$results = @()

foreach ($ipAddress in $ipArray) {
    $pingResult = Test-Connection -ComputerName $ipAddress -Count 1 -ErrorAction SilentlyContinue

    if ($pingResult) {
        $packetsTransmitted = $pingResult.Count
        $packetsReceived = ($pingResult | Where-Object { $_.StatusCode -eq 0 }).Count
        $packetLoss = 100 - (($packetsReceived / $packetsTransmitted) * 100)
        $maxTime = ($pingResult | Measure-Object ResponseTime -Maximum).Maximum
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        
        $result = [PSCustomObject]@{
            IPAddress        = $ipAddress
            PacketsTransmitted = $packetsTransmitted
            PacketsReceived    = $packetsReceived
            PacketLoss         = [math]::Round($packetLoss, 2)
            MaxRoundTripTime   = $maxTime
            Timestamp          = $timestamp
        }
        
        $results += $result
    }
    else {
        $result = [PSCustomObject]@{
            IPAddress        = $ipAddress
            PacketsTransmitted = 0
            PacketsReceived    = 0
            PacketLoss         = 100
            MaxRoundTripTime   = "N/A"
            Timestamp          = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        }
        
        $results += $result
    }
}

$results | Export-Csv -Path $outputFile -NoTypeInformation

Write-Output "Finished at $outputFile"
