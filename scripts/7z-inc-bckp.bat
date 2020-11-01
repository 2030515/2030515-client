@echo off
rem Работает так - автоматически создается заархивированное точное зеркало источника(ов).
rem При следующем запуске скрипта сначала ведется поиск отличающихся файлов в
rem источнике и основном архиве (mirror.7z). Все что отличается - переупаковывается из mirrir.7z в доп. архив Olds.
rem Следующим шагом основной архив приводиться в четкое соответствие с 
rem источником копирования - лишнее из основного архива удаляется, недостающее упаковывается.
rem Ну и на последок удаляются лишние Olds, их можно хранить определенное кол-во дней,
rem которое задается в настройках скрипта
rem *** ВОССТАНОВЛЕНИЕ ИНФОРМАЦИИ *** 
rem Чтобы восстановить на определенную дату что-то из архива нужно:
rem 1. Восстановить нужную информацию из mirrir.7z
rem 2. Восстановить нужную информацию из самого свежего Olds
rem 3. Восстановить по очереди все последующию Olds, двигаться от настоящего в сторону прошлого до нужной даты


rem *** Блок настроек А. Нужно править под каждый отдельный ПК ***
rem Указать путь до архиватора 7Z
set arc=c:\Program Files\7-Zip\7z.exe
rem Указать источник копирования (должен быть обрамлен кавычками). Или несколько источиков через пробел.
set source="d:\7" "d:\8"
rem Место хранения архивов. БЕЗ КАВЫЧЕК! БЕЗ ПРОБЕЛОВ! БЕЗ КИРИЛИЦЫ!
set dest=d:\9
rem Хранить последних Olds (в днях). Удалятся старше этого кол-ва дней.
set keepoldsdays=30
rem *** Блок настроек А ***



rem *** Блок настроек Б. Нужны для индивидуальных случаев. Для стандартного варианта тут уже все настроено***
rem Уровень лога (варианты 0 | 1 | 2 | 3)
set loglevel=0
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
set archsparm=-r -bse1 -bb%loglevel% -mx%compression%
if %archopened%==1 set archsparm=%archsparm% -ssw
if defined password set archsparm=%archsparm%  -p%password%
rem Определим лог файйл, положим его в месте хранения архивов
set logfile=%dest%\%dt%_%tm%_log.txt

echo Job start at %dt% %tm% >> "%logfile%"
echo Creating Olds >> "%logfile%"
rem Создать Olds. При этом не трогается основной архив.
"%arc%" u %archsparm% -u- -up0q1r0x1y1z0w1!"%dest%\%dt%_%tm%_olds.7z" "%dest%\mirror.7z" %source%>> "%logfile%"
echo Creating Olds complited >> "%logfile%"
echo. >> "%logfile%"
echo. >> "%logfile%"
echo. >> "%logfile%"

echo Syncing mirror >> "%logfile%"
rem Привести зеркало в соответствие оригинальному источику
"%arc%" u %archsparm% -up1q0r2x1y2z1w2 "%dest%\mirror.7z" %source%>> "%logfile%"
echo Syncing mirror complited >> "%logfile%"
echo. >> "%logfile%"
echo. >> "%logfile%"
echo. >> "%logfile%"

echo Removing old Olds >> "%logfile%"
rem Удаляем просроченные по дате файлы
@cd /d "%dest%" && @forfiles /d -%keepoldsdays% /C "cmd /c del /s /q /f @file" >> "%logfile%"

set dt=%date%
set tm=%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%
echo Job end at %dt% %tm% >> "%logfile%"
