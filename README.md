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


## 變數

pwd

	%CD%


local 日期

	%DATE%


local 時間

	%TIME%


0 ~ 32767 亂碼

	%RANDOM%


## 參考資源

* [Batch file – Programming tutorial](http://www.trytoprogram.com/batch-file)
* [batch 指令筆記](https://blog.poychang.net/note-batch/)
* [我的 Windows 平台自動化經驗：基礎批次檔撰寫實務](https://www.slideshare.net/WillHuangTW/windows-batch-scripting-for-begineers)
* [Windows Batch 常用命令](https://dotblogs.com.tw/grayyin/2016/07/28/171747)
