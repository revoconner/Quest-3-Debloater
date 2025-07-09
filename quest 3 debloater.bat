@echo off
cd "platform-tools"
adb devices

timeout /t 15 /nobreak

adb shell pm disable-user --user 0 com.facebook.orca
timeout /t 1 /nobreak

adb shell pm disable-user --user 0 com.oculus.facebook
timeout /t 1 /nobreak

adb shell pm disable-user --user 0 com.whatsapp
timeout /t 1 /nobreak

adb shell pm disable-user --user 0 com.meta.worlds
timeout /t 1 /nobreak

adb shell pm disable-user --user 0 com.oculus.updater
timeout /t 1 /nobreak

adb shell pm disable-user --user 0 com.oculus.socialplatform
timeout /t 1 /nobreak

adb shell pm disable-user --user 0 com.meta.horizonadidservice
timeout /t 1 /nobreak

adb shell pm disable-user --user 0 com.oculus.igvr

pause