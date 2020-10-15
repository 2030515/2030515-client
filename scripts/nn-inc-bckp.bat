rem Кирилицы в любых путях быть не должно!

rem откуда копировать
set source=e:\Common
rem папка, куда зеркалируется источник
set destination=f:\backup\common\mirror
rem папка, в которой хранятся устаревшие версии файлов из зеркальной папки
set backupdir=f:\backup\common\olds
rem Куда складывать лог
set logfile=f:\backup\common
rem путь к экзешнику nnbackup. Брать тут http://nncron.ru/ Нужна активация, читать тут http://www.nncron.ru/register_ru.shtml
rem читать документацию тут http://nncron.ru/nnbackup/help/RU/working/modes/sync.htm и тут http://nncron.ru/nnbackup/help/help_ru.htm
set exec=c:\Program Files (x86)\nnBackup\nnbackup.exe
rem Сколько дней хранить устаревшие файлы
set days=30

rem ВАЖНО!!!
rem Иногда могут скопироваться не все файлы. Это происходит в случаях, если в именах файлов встречаются кракозябры или,
rem если длинна символов в пути к файлу (источнику или назначению) превышает 255 знаков.
rem сейчас настроено так, что nnbackup пропускает такие файлы. Читай ЛОГ и периодически сверяй размер папки источника и папки назначения.

rem не трогать!
del %logfile%\nnbackup.log /q /s
set dt=%date%
set tm=%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%
set bckp=%backupdir%\%dt%_%tm%
"%exec%" sync -i "%source%" -o "%destination%" -log %logfile%\nnbackup.log -s -v -ad -da -backup "%bckp%" -c
@cd /d "%backupdir%" && @forfiles /d -%days% /C "cmd /c if @isdir==TRUE rd /s /q @file"