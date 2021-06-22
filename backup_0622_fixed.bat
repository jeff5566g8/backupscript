::Backup.bat 0622
::sysdatetime
@echo off
set today=%date:~0,4%%date:~5,2%%date:~8,2%
set format_day=%date:~0,4%/%date:~5,2%/%date:~8,2%
echo ---------%format_day%  %time:~0,8%-------- >> backup.log
::load ini
set keybk=backupPath
set keycp=copyPath
set keyp=Progcount
set keytag=Prog
set /A x=0
set /A y=0
:flag
call set /A x+=1
for /f "eol=[ tokens=1,2 delims==" %%i in (bkconfig.ini) do (
    if "%%i"=="%keybk%" set bakpath=%%j
    if "%%i"=="%keycp%" set copath=%%j
		if "%%i"=="%keyp%" set pcount=%%j
		if "%%i"=="%keytag%%x%" call set array[%x%]=%%j
		if "%%i"=="%keytag%%x%" goto flag
		)
::fixed path with space
if "%copath%"=="default" set copath=%~dp0
echo backupPath: %bakpath% >> backup.log
echo copyPath: %copath% >> backup.log
::echo %y%
::setlocal enabledelayedexpansion
REM for /f "skip=%y% tokens=1,2 delims==" %%i in (bkconfig.ini) do (
		REM ::call echo %%x%%
		REM if "%%i"=="%keyp%" set pcount=%%j
		REM if not "%%i"=="%keyp%" call set /A x+=1
		REM if not "%%i"=="%keyp%" call set array[%%x%%]=%%j
		REM )
		::call set n=%%x%%

SET /P str="開始所列檔案之備份作業: " < nul
for /L %%i in (1,1,%pcount%) do call SET /P str2= "%%i.%%array[%%i]%% " <nul
echo.
for /L %%j in (1,1,%pcount%) do (
::fixed path with space
	call xcopy "%copath%%%array[%%j]%%.pbl" "%bakpath%%today%\" /i /y >> backup.log && call echo "%%array[%%j]%%.pbl" done || call echo "%%array[%%j]%%.pbl" error >> backup.log
	ping 127.0.0.1 -n 1 -w 1500 > nul
	call xcopy "%copath%%%array[%%j]%%.pbd" "%bakpath%%today%\" /i /y >> backup.log && call echo "%%array[%%j]%%.pbd" done || call echo "%%array[%%j]%%.pbd" error >> backup.log
	ping 127.0.0.1 -n 1 -w 1500 > nul
	)
echo 備份作業完成
REM :flag
REM SET /P str="請選擇欲備份檔案作業碼: A.all " < nul
REM for /L %%i in (1,1,%n%) do call SET /P str2= "%%i.%%array[%%i]%% " <nul
REM SET /P str3="X.exit " < nul
REM SET /P input=""
REM ::@echo on
REM if %input% ==X exit
REM if %input% ==x exit
REM if %input% ==A (
	REM xcopy "%copath%*.pbl" "%bakpath%%today%" /i /y /d >> backup.log && echo pbl success || echo pbl error 
	REM xcopy "%copath%*.pbd" "%bakpath%%today%" /i /y /d >> backup.log && echo pbd success || echo pbd error
	REM ::echo Errorcode : %errorlevel% >> backup.log
	REM goto flag)
REM if %input% ==a (
	REM xcopy "%copath%*.pbl" "%bakpath%%today%" /i /y /d >> backup.log && echo pbl success || echo pbl error
	REM xcopy "%copath%*.pbd" "%bakpath%%today%" /i /y /d >> backup.log && echo pbd success || echo pbd error
	REM ::echo Errorcode : %errorlevel% >> backup.log
	REM goto flag
REM )else (
	REM call xcopy "%copath%%%array[%input%]%%*.pbl" "%bakpath%%today%" /i /y /d >> backup.log && echo pbl success || echo pbl error
	REM call xcopy "%copath%%%array[%input%]%%*.pbd" "%bakpath%%today%" /i /y /d >> backup.log && echo pbd success || echo pbd error
	REM ::echo Errorcode : %errorlevel% >> backup.log
	REM goto flag
	REM )
::call echo %%array[%input%]%%
::endlocal
pause
