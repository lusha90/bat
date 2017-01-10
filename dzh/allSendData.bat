@echo off
setlocal EnableDelayedExpansion
set serilNumber=-s ENU7N16709000499
set dzhUid=10113
set thsUid=10111
set dfcfUid=10110
set zlcftUid=10112
set sleep=2

if exist "allSendData.txt" (del allSendData.txt ) else (echo "allSendData.txt not exist")
set count=1
if exist "%ANDROID_HOME%" (
		set adb=%ANDROID_HOME%\platform-tools\adb.exe
		) else (
		echo "ANDROID_HOME not exist, please set"
		exit
		)

echo "***** %count% all send data test is in progress *****"
echo %date% %time% > allSendData.txt
echo "***** get all send data, please don't interrupt *****"
			
:loop
%adb% %serilNumber% shell "cat /proc/uid_stat/%dzhUid%/tcp_snd ;cat /proc/uid_stat/%thsUid%/tcp_snd ;cat /proc/uid_stat/%dfcfUid%/tcp_snd ;cat /proc/uid_stat/%zlcftUid%/tcp_snd" >> allSendData.txt
echo "***********">>allSendData.txt
ping -n %sleep% 127.0.0.1>nul
set /a count+=1
goto loop
pause		