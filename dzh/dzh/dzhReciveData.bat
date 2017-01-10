@echo off
setlocal EnableDelayedExpansion
set serilNumber=-s ENU7N16709000499
set uid=10113
set sleep=2

if exist "dzhReciveData.txt" (del dzhReciveData.txt ) else (echo "dzhReciveData.txt not exist")
set count=1
if exist "%ANDROID_HOME%" (
		set adb=%ANDROID_HOME%\platform-tools\adb.exe
		) else (
		echo "ANDROID_HOME not exist, please set"
		exit
		)	

echo "***** %count% dzh recive data test is in progress *****"
echo %date% %time% > dzhReciveData.txt
echo "***** get dzh recive data, please don't interrupt *****"
		
:loop
%adb% %serilNumber% shell "cat /proc/uid_stat/%uid%/tcp_rcv" >> dzhReciveData.txt
ping -n %sleep% 127.0.0.1>nul
set /a count+=1
goto loop		