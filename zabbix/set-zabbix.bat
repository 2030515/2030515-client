:: Проверка есть ли у нас установленный агент, если есть - выпиливаем
sc qc "Zabbix Agent"
If %errorlevel% NEQ 0 (
  GOTO instzab
) Else (
	sc stop "Zabbix Agent"
	ping -n 7 localhost > NUL
	sc delete "Zabbix Agent"
)

:instzab
:: Определяем 32 или 64, устанавливаем соответствующий сервис для агента zabbix
If "%PROCESSOR_ARCHITECTURE%"=="x86" (
  c:\2030515\zabbix\bin\win32\zabbix_agentd.exe --config c:\2030515\zabbix\conf\zabbix_agentd.conf --install
) Else (
  c:\2030515\zabbix\bin\win64\zabbix_agentd.exe --config c:\2030515\zabbix\conf\zabbix_agentd.conf --install
)

:: Проверка есть ли у нас установленный OHM, если есть - выпиливаем
sc qc "OpenHardwareMonitor"
If %errorlevel% NEQ 0 (
  GOTO instohm
) Else (
	sc stop "OpenHardwareMonitor"
	ping -n 7 localhost > NUL
	sc delete "OpenHardwareMonitor"
)

:: Определяем 32 или 64, устанавливаем соответствующий сервис для OpenHardwareMonitor
:instohm
If "%PROCESSOR_ARCHITECTURE%"=="x86" (
  c:\2030515\zabbix\soft\portable\nssm-2.24\win32\nssm.exe install OpenHardwareMonitor c:\2030515\zabbix\soft\portable\ohm-0.8.0\OpenHardwareMonitor.exe
) Else (
  c:\2030515\zabbix\soft\portable\nssm-2.24\win64\nssm.exe install OpenHardwareMonitor c:\2030515\zabbix\soft\portable\ohm-0.8.0\OpenHardwareMonitor.exe
)

:: Установка smartmontools из дистрибутива и добавляем его в PATH
@Echo off
cls
echo Installing SmartMonTools
echo Check, that you select proper architecture.
echo You must select type "Full" or "Full (x64)", NOT anything else.
echo Check, that destination folder is set to C:\Program Files\smartmontools
echo And click NEXT - INSTALL - CLOSE
call c:\2030515\zabbix\soft\dist\smartmontools-7.1-1.win32-setup.exe

@Echo on

echo %path% | findstr "smartmontools"
If %errorlevel% EQU 0 (
  GOTO skppth
) Else (
	setx /M path "%PATH%;c:\Program Files\smartmontools\bin"
)
:skppth

:: Изменение политики powershell для разрешения запуска скриптов
powershell.exe Set-ExecutionPolicy Unrestricted -Force

sc start "OpenHardwareMonitor"
sc start "Zabbix Agent"


