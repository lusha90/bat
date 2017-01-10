@echo off
setlocal EnableDelayedExpansion
set serilNumber=-s ENU7N16709000499
set uid=10110
set sleep=2

if exist "dfcfSendData.txt" (del dfcfSendData.txt ) else (echo "dfcfSendData.txt not exist")
set count=1
if exist "%ANDROID_HOME%" (
		set adb=%ANDROID_HOME%\platform-tools\adb.exe
		) else (
		echo "ANDROID_HOME not exist, please set"
		exit
		)

echo "***** %count% dfcf send data test is in progress *****"
echo %date% %time% > dfcfSendData.txt
echo "***** get dfcf send data, please don't interrupt *****"
			
:loop
%adb% %serilNumber% shell "cat /proc/uid_stat/%uid%/tcp_snd" >> dfcfSendData.txt
ping -n %sleep% 127.0.0.1>nul
set /a count+=1
goto loop		