# 2017/02/13 AcidVenom v2
# Скрипт для обнаружения разных датчиков для Zabbix

param($1,$2)

# Автообнарежение датчиков температуры, напряжения, оборотов кулеров
# Ключи: discovery temperature/voltage/fan
if ($1 -eq "discovery") {
$items = Get-WmiObject -Namespace Root\OpenHardwareMonitor -Class sensor | Where-Object {$_.SensorType -eq "$2" -and $_.Name -notmatch "#|VBAT" -and $_.Parent -notmatch "hdd"}

write-host -NoNewline "{"
write-host -NoNewline "`"data`":["

$n = 0
foreach ($obj in $items) {
 $n = $n + 1
 $line =  "{`"{#ID}`":`"" + $obj.InstanceId + "`", `"{#NAME}`":`"" + $obj.Name + "`"}"
 If ($n -lt $items.Count) { $line = "$line,"}
 write-host -NoNewline $line
}

write-host -NoNewline "]"
write-host -NoNewline "}"

} 

# Зарезервированные переменные
# Ключи: VBAT
elseif ($1 -eq "VBAT") {
    $obj = (Get-WmiObject -Namespace Root\OpenHardwareMonitor -Class sensor | Where-Object {$_.Name -eq "$1"}).Value -replace(",",".")
    Write-Host -NoNewline $obj
}


# Запрос значения по InstaceId от discovery
# 
else {
    if ((Get-WmiObject -Namespace Root\OpenHardwareMonitor -Class sensor | Where-Object {$_.InstanceId -eq "$1"}).SensorType -eq "Voltage") {
        $obj = (Get-WmiObject -Namespace Root\OpenHardwareMonitor -Class sensor | Where-Object {$_.InstanceId -eq "$1"}).Value -replace(",",".")}
    else {$obj = (Get-WmiObject -Namespace Root\OpenHardwareMonitor -Class sensor | Where-Object {$_.InstanceId -eq "$1"}).Value -replace(",.*","")}
    Write-Host -NoNewline $obj
}