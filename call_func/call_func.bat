@echo off

call :showTime

pause & goto :eof
:: goto :eof 用來避免二次執行下面的函式定義
:: 也可以用 exit /b
:: 可以寫成一行 pause & goto :eof

:: ------------------------------
:: -- 函式統一定義在最下面
:: ------------------------------

:showTime (
	echo %TIME%
	goto :eof
)