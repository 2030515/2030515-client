:newins
net stop anydesk
rd %programdata%\anydesk /q /s
anydesk.exe --install "%ProgramFiles(x86)%\AnyDesk" --remove-first --create-desktop-icon --start-with-win --slilent

:: Процедура установки пароля
:newpas
echo %password% | "%ProgramFiles(x86)%\AnyDesk\anydesk.exe" --set-password