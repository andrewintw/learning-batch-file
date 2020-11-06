@echo off

call :showMSG Hello World
echo.
call :showMSG 123 456

pause & goto :eof

:showMSG (
	echo arg[0] = %0
	echo arg[1] = %1
	echo arg[2] = %2
	echo arg[*] = %*
	goto :eof
)