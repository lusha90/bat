@echo off
setlocal EnableDelayedExpansion
set serilNumber=-s ENU7N16709000499
set uid=10112
set sleep=2

if exist "cftSendData.txt" (del cftSendData.txt ) else (echo "cftSendData.txt not exist")
set count=1
if exist "%ANDROID_HOME%" (
		set adb=%ANDROID_HOME%\platform-tools\adb.exe
		) else (
		echo "ANDROID_HOME not exist, please set"
		exit
		)

echo "***** %count% cft send data test is in progress *****"
echo %date% %time% > cftSendData.txt
echo "***** get cft send data, please don't interrupt *****"
			
:loop
%adb% %serilNumber% shell "cat /proc/uid_stat/%uid%/tcp_snd" >> cftSendData.txt
ping -n %sleep% 127.0.0.1>nul
set /a count+=1
goto loop		