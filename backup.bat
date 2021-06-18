::Backup.bat 0617
::sysdatetime
@echo off
@set today=%date:~0,4%%date:~5,2%%date:~8,2%
@set format_day=%date:~0,4%/%date:~5,2%/%date:~8,2%
@echo ---------%format_day%  %time:~0,8%-------- >> backup.log
::load ini
@set keybk=backupPath
@set keycp=copyPath
@set keyp=Progcount
for /f "eol=[ tokens=1,2 delims==" %%i in (bkconfig.ini) do (
    if %%i== %keybk% set bakpath=%%j
    if %%i== %keycp% set copath=%%j
		if %%i== %keyp% set pcount=%%j)
if %copath%==default set copath=%~dp0
set /A x=0
::setlocal enabledelayedexpansion
for /f "eol=[ skip=5 tokens=1,2 delims==" %%i in (bkconfig.ini) do (
		set /A x+=1
		::call echo %%x%%
		call set array[%%x%%]=%%j
		call set n=%%x%%
		)
:flag
SET /P str="請選擇欲備份檔案作業碼: A.all " < nul
for /L %%i in (1,1,%n%) do call SET /P str2= "%%i.%%array[%%i]%% " <nul
SET /P str3="X.exit " < nul
SET /P input=""
::@echo on
if %input% ==X exit
if %input% ==x exit
if %input% ==A (
	xcopy %copath%*.pbl %bakpath%%today% /i /y /d >> backup.log && echo pbl success || echo pbl error 
	xcopy %copath%*.pbd %bakpath%%today% /i /y /d >> backup.log && echo pbd success || echo pbd error
	::echo Errorcode : %errorlevel% >> backup.log
	goto flag)
if %input% ==a (
	xcopy %copath%*.pbl %bakpath%%today% /i /y /d >> backup.log && echo pbl success || echo pbl error
	xcopy %copath%*.pbd %bakpath%%today% /i /y /d >> backup.log && echo pbd success || echo pbd error
	::echo Errorcode : %errorlevel% >> backup.log
	goto flag
)else (
	call xcopy %copath%%%array[%input%]%%*.pbl %bakpath%%today% /i /y /d >> backup.log && echo pbl success || echo pbl error
	call xcopy %copath%%%array[%input%]%%*.pbd %bakpath%%today% /i /y /d >> backup.log && echo pbd success || echo pbd error
	::echo Errorcode : %errorlevel% >> backup.log
	goto flag
	)
::call echo %%array[%input%]%%
::endlocal
pause
