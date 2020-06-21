# 2017/04/12 AcidVenom v3
# Скрипт для обнаружения дисков и получения их данных для Zabbix

param($1,$2)

# Автообнарежение дисков
# Ключ: discovery
if ($1 -eq "discovery") {
try {
$items = smartctl-nc --scan-open | where {$_ -match "/dev/sd"}

write-host -NoNewline "{"
write-host -NoNewline "`"data`":["

$n = 0
foreach ($obj in $items) {
 if ((smartctl-nc -i $obj.substring(0,8) | where {$_ -match "SMART support is: Enabled"}) -ne $null) {
	$n = $n + 1
	If ($n -gt 1) {write-host -NoNewline ","}    
	$line =  "{`"{#DISKID}`":`"" + ($obj.substring(5,3)) + "`"}"
    write-host -NoNewline $line
    }
 }
write-host -NoNewline "]"
write-host -NoNewline "}"

}
catch {exit}
}

# Получение информации от дисков
# Ключи: 
else {
try {
if ($2 -eq "status") {
$obj = smartctl-nc -H /dev/$1 | where {$_ -match "result:"}
$obj = $obj.substring(50)
}
elseif ($2 -eq "model") {
$obj = smartctl-nc -i /dev/$1 | where {$_ -match "Device Model:"}
$obj = $obj.substring(18)
}
elseif ($2 -eq "family") {
$obj = smartctl-nc -i /dev/$1 | where {$_ -match "Model Family:"}
$obj = $obj.substring(18)
}
elseif ($2 -eq "fw") {
$obj = smartctl-nc -i /dev/$1 | where {$_ -match "Firmware Version:"}
$obj = $obj.substring(18)
}
elseif ($2 -eq "serial") {
$obj = smartctl-nc -i /dev/$1 | where {$_ -match "Serial Number:"}
$obj = $obj.substring(18)
}
elseif ($2 -eq "capacity") {
$obj = smartctl-nc -i /dev/$1 | where {$_ -match "User Capacity:"}
    if ($obj -match "User Capacity:") {
    $obj = $obj.Substring($obj.IndexOf("[")+1,$obj.IndexOf("]")-$obj.IndexOf("[")-1)
    }
    else {
    $obj = "N/A"
    }}


# Получение показателей SMART
# Значения без скобок и их содержимого
else {

$obj = smartctl-nc -A /dev/$1 | where {$_ -match "^ *$2"}
    try {$obj = $obj.Substring(87,$obj.IndexOf("(")-87)}
    catch {$obj = $obj.Substring(87)}
}}
catch {$obj = ""}

Write-Output $obj
}