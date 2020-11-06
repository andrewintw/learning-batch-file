::: ver3

@echo off

set cfgFile=.config

set randomNum=%random:~-1%%random:~-1%%random:~-1%%random:~-1%
set HWID=0x00002500
set SN=BWOBDLR915EV%randomNum%
set DEVEUI=e8e1:e100:0101:%randomNum%
set JOINEUI=e8e1:e100:0101:%randomNum%
set NWKKEY=43b6057606fc58474faacbbd6f46%randomNum%
set APPKEY=9334ccd2d5312aa0fc3990a5df24%randomNum%
set buzzerDuration=1000

:: ------------------------------------------

call :setEnv
echo.
call :relayCtrl uart_rx off && timeout /t 5
call :relayCtrl uart_rx on  && Timeout /t 1
call :relayCtrl reset       && Timeout /t 1
call :programMCU            && Timeout /t 1
call :cleanFiles

call :programNRF     && Timeout /t 1
call :writePersoInfo && Timeout /t 1
call :getPersoInfo   && Timeout /t 1
call :buzzerOn       && Timeout /t 1

call :getVoltageInfo vsupply && Timeout /t 1
call :getVoltageInfo vbat    && Timeout /t 1

call :runG76SRXCmd && pause
call :loraTXTest   && Timeout /t 1
call :runG76STXCmd && pause
call :loraRXTest   && Timeout /t 1

call :mcuSWReset   && Timeout /t 5
:: call :relayCtrl reset && Timeout /t 5

call :switchToMode flight


:: ------------------------------------------

goto :eof

:: ------------------------------------------

:setEnv (
	for /F "eol=; tokens=1,2 delims==" %%i in (%cfgFile%) do (
		@echo %%i =	%%j
		set %%i=%%j
	)
	goto :eof
)

:relayCtrl (
	python relay_ctrl.py %relayComPort% %~1 %~2
	goto :eof
)


:programMCU (
	ipecmd -P32MX550F256H -TPPK4 -OL -E -M -F"%picFwPath%"
	goto :eof
)

:cleanFiles (
	del log.* MPLABXLog.xml* *.log > nul 2>&1
	goto :eof
)

:programNRF (
	nrfjprog -f NRF52 --program %nrfFwPath% --sectorerase -r
	goto :eof
)

:writePersoInfo (

	echo ----------------------------------
	echo {random} = %randomNum%
	echo HwID     = %HWID%
	echo SN       = %SN%
	echo DevEUI   = %DEVEUI%
	echo JoinEUI  = %JOINEUI%
	echo NwkKEY   = %NWKKEY%
	echo AppKEY   = %APPKEY%
	echo ----------------------------------

	python common.py personalize --port %uartComPort% ^
			%HWID% ^
			%SN% ^
			%DEVEUI% ^
			%JOINEUI% ^
			%NWKKEY% ^
			%APPKEY%
	goto :eof
)

:getPersoInfo (
	python common.py info --port %uartComPort%
	goto :eof
)

:buzzerOn (
	python -u obd.py nrfbeep --port %uartComPort% --duration %buzzerDuration% --freq 500
	goto :eof
)

:getVoltageInfo (
	python obd.py %~1 --port %uartComPort%
	goto :eof
)

:runG76SRXCmd (
	echo Run the following command on G76S CLI:
	echo.
	echo at+gpt="TXPP,0,0010,902.300,00,0,5,1,0,1,0,0100,1234"
	goto :eof
)

:loraTXTest (
	python radio.py version --port %uartComPort%
	echo.
	echo open TX 3 seconds...
	python -u radio.py txcont --port %uartComPort% --duration 3 --sf 7 --bw 125 --freq 902300000 --txpow 20 --data 31323334
	goto :eof
)

:runG76STXCmd (
	echo Run the following command on G76S CLI:
	echo.
	echo at+gpt="TXPP,1,0020,902.300,20,0,5,1,0,1,0,0100,1234"
	goto :eof
)

:loraRXTest (
	python radio.py version --port %uartComPort%
	echo.
	echo open RX 10 seconds...
	python -u radio.py rxcont --port %uartComPort% --ppl --duration 10 --sf 7 --bw 125 --freq 902300000 --data 31323334
	goto :eof
)

:mcuSWReset (
	python common.py reset --port %uartComPort%
	goto :eof
)

:switchToMode (
	python common.py bootmode --port %uartComPort% %~1
	python -u common.py run      --port %uartComPort% --terminal
	goto :eof
)