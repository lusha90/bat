:: @echo off
setlocal EnableDelayedExpansion
set pwd=%cd%
set serilNumber=-s ENU7N16709000499
set screenWidth=1440
set screenHeight=2560

REM echo "********* start test *********"
REM goto setup
REM goto ready
REM goto before_sr
REM goto unintall
REM goto reboot
REM goto ready
REM goto install
REM goto startapp
REM goto after_sr
REM pause
REM echo "********* end test *********"

:setup
echo "********* setup env *********"
if exist "%ANDROID_HOME%" (
		set adb=%ANDROID_HOME%\platform-tools\adb.exe
		) else (
		echo "ANDROID_HOME not exist, please set"
		exit
		)

:ready
echo "********* wait device *********"
%adb% %serilNumber% wait-for-device
%adb% %serilNumber% shell "echo 'ready'"
%adb% %serilNumber% logcat -c
%adb% %serilNumber% shell type sed
echo "********* please close the wifi *********"
pause

:unintall
echo "********* unintall apk *********"	
%adb% %serilNumber% uninstall com.android.dazhihui
%adb% %serilNumber% uninstall com.android.dazhihui.classic
%adb% %serilNumber% uninstall com.hexin.plat.android
%adb% %serilNumber% uninstall com.eastmoney.android.berlin
%adb% %serilNumber% uninstall com.lphtsccft
%adb% %serilNumber% uninstall cn.com.gw.density

:reboot
echo "********* reboot phone *********"
%adb% %serilNumber% reboot
%adb% %serilNumber% wait-for-device
%adb% %serilNumber% shell "echo 'ready'"

:before_sr
echo "********* view uid_stat *********"
if exist "before_uid_stat_nexus" (del before_uid_stat_nexus.txt ) else (echo "before_uid_stat_nexus.txt not exist")
%adb% %serilNumber% shell "ls -al /proc/uid_stat" > before_uid_stat_nexus.txt

:install
echo "********* install apk *********"		
for %%i in (*.apk) do (   
    echo "installing: " %%i  
    %adb% %serilNumber% install "%%i"  
    )  
	
:startapp
echo "********* start app *********"
%adb% %serilNumber% shell wm size
echo WScript.sleep 10000 > sleep.vbs
set /a center_x=%screenWidth%/2
set /a center_y=%screenHeight%/2
	
%adb% %serilNumber% shell am start -S -W com.android.dazhihui/com.android.dazhihui.dzh.dzh
Wscript sleep.vbs
set /a dzh_x=%screenWidth%/10
set /a dzh_y=%screenHeight%-80
%adb% %serilNumber% shell input tap %dzh_x% %dzh_y%

%adb% %serilNumber% shell am start -S -W com.hexin.plat.android/.Hexin
Wscript sleep.vbs

%adb% %serilNumber% shell am start -S -W com.eastmoney.android.berlin/.activity.HomeActivity
Wscript sleep.vbs

%adb% %serilNumber% shell am start -S -W com.lphtsccft/.zhangle.startup.SplashScreenActivity
Wscript sleep.vbs
set /a zlt_start_x=%screenWidth%-20
set /a zlt_start_y=%screenHeight%/2
set /a zlt_end_x=20
set /a zlt_end_y=%screenHeight%/2
%adb% %serilNumber% shell input swipe %zlt_start_x% %zlt_start_y% %zlt_end_x% %zlt_end_y%
%adb% %serilNumber% shell inputs wipe %zlt_start_x% %zlt_start_y% %zlt_end_x% %zlt_end_y%
%adb% %serilNumber% shell input swipe %zlt_start_x% %zlt_start_y% %zlt_end_x% %zlt_end_y%
%adb% %serilNumber% shell input swipe %zlt_start_x% %zlt_start_y% %zlt_end_x% %zlt_end_y%
%adb% %serilNumber% shell input tap %center_x% %center_y%
echo "********* please open the wifi, and connect to the internet *********"
pause
REM echo WScript.sleep 300000 > sleep.vbs
echo WScript.sleep 60000 > sleep.vbs
echo "network flow test start, sleep 5 minutes"
Wscript sleep.vbs
%adb% %serilNumber% shell am start -S -W cn.com.gw.density/.MainActivity
pause
%adb% %serilNumber% shell am start -S -W cn.com.gw.density/.MainActivity

:after_sr
echo "********* view uid_stat *********"
if exist "after_uid_stat_nexus.txt" (del after_uid_stat_nexus.txt ) else (echo "after_uid_stat_nexus.txt not exist")
%adb% %serilNumber% shell "ls -al /proc/uid_stat" > after_uid_stat_nexus.txt

:getuid
for /f "delims=" %%a in ('%adb% %serilNumber% shell "sed -n '1p' /sdcard/allTestUid"') do (
	set dzhuid=%%a
	echo %%a
)

for /f "delims=" %%a in ('%adb% %serilNumber% shell "sed -n '2p' /sdcard/allTestUid"') do (
	set thsuid=%%a
	echo %%a
)

for /f "delims=" %%a in ('%adb% %serilNumber% shell "sed -n '3p' /sdcard/allTestUid"') do (
	set dfcfuid=%%a
	echo %%a
)
echo %uid%

for /f "delims=" %%a in ('%adb% %serilNumber% shell "sed -n '4p' /sdcard/allTestUid"') do (
	set cftuid=%%a
	echo %%a
)
echo ���ǻۣ�%dzhuid% ͬ��˳��%thsuid% �����Ƹ���%dfcfuid% ���ֲƸ�ͨ��%cftuid%

:calculated_flow_rate
echo "********* reciver data *********"
set dir=/proc/uid_stat/
%adb% %serilNumber% shell cat %dir%%dzhuid%/tcp_rcv ;cat %dir%%thsuid%/tcp_rcv ;cat %dir%%dfcfuid%/tcp_rcv ;cat %dir%%cftuid%/tcp_rcv
echo "********* send data *********"
%adb% %serilNumber% shell cat %dir%%dzhuid%/tcp_snd ;cat %dir%%thsuid%/tcp_snd ;cat %dir%%dfcfuid%/tcp_snd ;cat %dir%%cftuid%/tcp_snd

pause>nul 