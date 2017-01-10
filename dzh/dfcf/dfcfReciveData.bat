@echo off
setlocal EnableDelayedExpansion
set serilNumber=-s ENU7N16709000499
set uid=10110
set sleep=2

if exist "dfcfReciveData.txt" (del dfcfReciveData.txt ) else (echo "dfcfReciveData.txt not exist")
set count=1
if exist "%ANDROID_HOME%" (
		set adb=%ANDROID_HOME%\platform-tools\adb.exe
		) else (
		echo "ANDROID_HOME not exist, please set"
		exit
		)	

echo "***** %count% dfcf recive data test is in progress *****"
echo %date% %time% > dfcfReciveData.txt
echo "***** get dfcf recive data, please don't interrupt *****"
		
:loop
%adb% %serilNumber% shell "cat /proc/uid_stat/%uid%/tcp_rcv" >> dfcfReciveData.txt
ping -n %sleep% 127.0.0.1>nul
set /a count+=1
goto loop		