:: В первом параметре %1 принимаемом пароль для неконтролируемого доступа
@echo off
chcp 850>nul
:: Если второй параметр = force не делаем никаких проверок - сразу на переустановку.
if %2=="force" set message=Receive command to force reinstall!& goto newinst

:: Процедура определения нужна ли переустановка, несколько проверок.
:: 0. Проверяем наличие службы AnyDesk, если нет - устанавливаем
sc query anydesk>nul
if %errorlevel% NEQ 0 set message=There is no AnyDesk service, reinstalling!& goto newinst

:: 1. Процедура определения если в реестре нет хеша - устанавливаем
Reg Query HKLM\Software\2030515 /V anydesk-hash>nul
if %errorlevel% NEQ 0  set message=There is no reghash key, reinstalling!& goto newinst

:: 2. Процедура сравнения хеша в файле и в реесте. Если не совпадают - пароль был изменен не нами и нужно переустановить приложение с паролем.
:: Вытащить значение ключа реестра
For /F "Tokens=2*" %%I In ('Reg Query HKLM\Software\2030515 /V anydesk-hash') Do Set reghash=%%J
:: Вытащить значение из файла
for /f "tokens=2 delims==" %%i in ('findstr "ad.anynet.pwd_hash" c:\ProgramData\AnyDesk\service.conf') do set filehash=%%i
:: Сравниваем значения
if %reghash% NEQ %filehash% set message=Filehash and reghash missmatch, reinstalling!& goto newinst



:: Если все проверки прошли успешно - идем на выход
set message=No problem!
goto exit

:: *** Процедура установки/переустановки энидеска ***
:newinst
net stop anydesk>nul
rd %programdata%\anydesk /q /s
c:\2030515\dist\anydesk.exe --install "c:\2030515\anydesk" --remove-first --create-desktop-icon --start-with-win --slilent
ping -n 5 localhost>nul

:: Процедура установки пароля при установке/переустановке
echo %1 | "c:\2030515\anydesk\anydesk.exe" --set-password
net stop anydesk>nul
echo ad.security.allow_logon_token=false>>%programdata%\AnyDesk\system.conf
sc start anydesk>nul

:: Процедура дублирования хеша пароля в реестр для последующего сравнения
for /f "tokens=2 delims==" %%i in ('findstr "ad.anynet.pwd_hash" c:\ProgramData\AnyDesk\service.conf') do set filehash=%%i
reg add HKLM\Software\2030515 /v anydesk-hash /t REG_SZ /f /d %filehash%>nul
set message=%message% ReInstalled! 
goto exit


:: Выход + доклад о действиях
:exit
:: Процедура получения ID
for /f "delims=" %%i in ('"C:\2030515\AnyDesk\AnyDesk.exe" --get-id') do set ID=%%i
for /f "delims=" %%i in ('"C:\2030515\AnyDesk\AnyDesk.exe" --get-status') do set status=%%i
echo ID = %ID%; Status = %status%; %message%
exit