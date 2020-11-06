# learning-batch-file
紀錄常用的批次檔寫法


## 常用寫法

執行時不顯示指令本身

	@echo off


按任意鍵繼續

	pause


輸出換行

	echo.


註解

	:: comment

	REM comment


delay 5 秒

	timeout /t 5


設定變數 set var

	set com=5


取用變數 %var%

	echo get info via COM%com%


列出所有可用的 COM port 清單
	
	WMIC PATH Win32_PnPEntity GET Caption | findstr "COM[0-9].*"


取得使用者的輸入，並存入變數 com

	set /P com=Choose a COM Port:


如果 com 變數的內容為空，則設定為 5

	if "%com%" == "" (
		set com=5
	)
	

回傳上一個指令的執行結果 {0: 成功, 非0: 失敗}

	echo %errorlevel%


取得 argv[0], argv[1], argv[2]...

	echo %0
	echo %1
	echo %2

for-loop

	for %%x in (1 2 3) do (
		echo %%x
	)


## 變數

pwd

	%CD%


local 日期

	%DATE%


local 時間

	%TIME%


0 ~ 32767 亂碼

	%RANDOM%

## 讀取設定檔

準備 .config 的設定檔 (Ref: [如何透過檔案總管建立 .gitignore 或 .editorconfig 等只有副檔名的檔案
](https://blog.miniasp.com/post/2017/01/01/Create-gitignore-editorconfig-from-Windows-Explorer))

其中開頭的 ; 會被當作註解

	C:\home\ws\wsms-149>type .config
	; 使用 name=value 的格式

	picFwPath=production\20201105\OBD_tracker_v1.0.5_prod.unified.hex
	nrfFwPath=production\20201105\nrf_unified_v1.0.1.hex
	uartComPort=COM4
	relayComPort=COM2

read_config.bat 的內容

	@echo off

	for /F "eol=; tokens=1,2 delims==" %%i in (.config) do (
		@echo %%i =	%%j
		set %%i=%%j
	)

	:: echo.
	:: set

	pause

執行結果

	C:\home\ws\wsms-149>read_config.bat
	picFwPath =     production\20201105\OBD_tracker_v1.0.5_prod.unified.hex
	nrfFwPath =     production\20201105\nrf_unified_v1.0.1.hex
	uartComPort =   COM4
	relayComPort =  COM2
	請按任意鍵繼續 . . .


## 參考資源

* [Batch file – Programming tutorial](http://www.trytoprogram.com/batch-file)
* [batch 指令筆記](https://blog.poychang.net/note-batch/)
* [我的 Windows 平台自動化經驗：基礎批次檔撰寫實務](https://www.slideshare.net/WillHuangTW/windows-batch-scripting-for-begineers)
* [Windows Batch 常用命令](https://dotblogs.com.tw/grayyin/2016/07/28/171747)
