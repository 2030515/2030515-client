rem @echo off
rem Работает так - автоматически создается заархивированное точное зеркало источника(ов).
rem При следующем запуске скрипта сначала ведется поиск отличающихся файлов в
rem оригинале и основном архиве. Все что отличается - переупаковывается в доп. архив Olds.
rem Следующим шагом основной архив приводиться в четкое соответствие с 
rem источником копирования - лишние из основного архива удаляется, недостающее упаковывается.
rem Ну и на последок удаляются лишние Olds, их можно хранить определенное кол-во штук или дней,
rem которое задается в настройках скрипта



rem *** Блок настроек А. Нужно править под каждый отдельный ПК ***
rem Указать путь до архиватора 7Z
set arc=c:\Program Files\7-Zip\7z.exe
rem Указать источник копирования (должен быть обрамлен кавычками). Или несколько источиков через пробел.
set source="D:\8" "E:\1c_backup"
rem Место хранения архивов. БЕЗ КАВЫЧЕК!!!
set dest=D:\9
rem Хранить последних Olds (в днях). Удалятся старше этого кол-ва дней.
set keepoldsdays=30
rem *** Блок настроек А ***



rem *** Блок настроек Б. Нужны для индивидуальных случаев. Для стандартного варианта тут уже все настроено***
rem Уровень лога (варианты 0 | 1 | 2 | 3)
set loglevel=2
rem Уровень сжатия (варианты 0 | 1 | 3 | 5 | 7 | 9 )
set compression=5
rem Зашифровать архив паролем
set password=
rem Не включать в архив файлы по маске ЗАДУМАНО, Но Не РЕАЛИЗОВАНО
rem set exclmask=
rem Архивировать или пропускать файлы открытые для записи. Архивировать - 1, пропускать - 0
set archopened=1
rem *** Блок настроек Б***



rem *** ТЕЛО ****
rem Определим дату в формате ДД.ММ.ГГГГ
set dt=%date%
rem Определим время в формате ЧЧ-ММ-СС
set tm=%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%
rem ключи для процедуры создания Olds
set oldsparm=-r -bb%loglevel% -mx%compression%
if %archopened%==1 set oldsparm=%oldsparm% -ssw
if defined password set oldsparm=%oldsparm%  -p%password%
rem ключи для процедуры создания mirror
set mirrorparm=-r -bb%loglevel% -mx%compression%
if %archopened%==1 set mirrorparm=%mirrorparm% -ssw
if defined password set mirrorparm=%mirrorparm%  -p%password%

rem Создать Olds. При этом не трогается основной архив.
"%arc%" u %oldsparm% -u- -up0q1r0x1y1z0w1!"%dest%\olds_%dt%_%tm%.7z" "%dest%\mirror.7z" %source%

rem Привести зеркало в соответствие оригинальному источику
"%arc%" u %mirrorparm% -up1q0r2x1y2z1w2 "%dest%\mirror.7z" %source%

rem Удаляем просроченные по дате файлы
@cd /d "%dest%" && @forfiles /d -%keepoldsdays% /C "cmd /c del /s /q /f @file"
