
findstr "ad.security.acl_list=" c:\ProgramData\AnyDesk\system.conf
if %errorlevel%==0 ( 
	set aaa=
	for /f %%i in ('findstr "ad.security.acl_list=" c:\ProgramData\AnyDesk\system.conf') do set aaa=%%i
	set aaa=%aaa::=::%
)
	echo %1 >> c:\ProgramData\AnyDesk\system.conf

	
	
::net stop anydesk>nul
::c:\2030515\zabbix\soft\portable\gsar-1.21\bin\gsar.exe -io -s"%aaa%" -r%1 c:\ProgramData\AnyDesk\system.conf
::net start anydesk>nul

::set aaa=
::for /f %%i in ('findstr "ad.security.acl_list=" c:\ProgramData\AnyDesk\system.conf') do set aaa=%%i
::set aaa=%aaa::=::%
::net stop anydesk>nul
::c:\2030515\zabbix\soft\portable\gsar-1.21\bin\gsar.exe -io -s"%aaa%" -r%1 c:\ProgramData\AnyDesk\system.conf
::net start anydesk>nul



::%programdata%\AnyDesk 



::Automatically Setting a Password after Installation
::For security reasons, a password can not be set from the command line directly as this would enable malicious users to spy the password from the command line in Task Manager. Instead, a pipe is used to set the password. For example, to set a password for an already installed AnyDesk, use this syntax in a batch file:
::echo my_password123 | anydesk.exe --set-password 

:: INSTALLING
:: Принимаем решение о необходимости переустановки, вдруг уже все настроено как надо. Ищем что нибудь в конфиге, если там все норм - ничего не делаем.

:: Процедура удаления старого энидеск и установка нового
net stop anydesk
rd %programdata%\anydesk /q /s
anydesk.exe --install "%ProgramFiles(x86)%\AnyDesk" --remove-first --create-desktop-icon --start-with-win --slilent

:: Процедура установки пароля
echo %password% | anydesk.exe --set-password







