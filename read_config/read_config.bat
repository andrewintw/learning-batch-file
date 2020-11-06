@echo off

for /F "eol=; tokens=1,2 delims==" %%i in (.config) do (
	@echo %%i =	%%j
	set %%i=%%j
)

echo.
set

pause
