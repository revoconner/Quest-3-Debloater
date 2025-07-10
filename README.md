# Meta Quest 3 Debloater
Debloats Quest 3 VR of Meta's social apps, and disables updates and ad services

## List of apps it disables
- Instagram
- Messenger
- Whatsapp
- Facebook
- Ad service ID
- Updater
- Horizon Worlds


## Why it's needed
Since update v76 you cannot uninstall the social apps, if you do they reinstall within minutes. This disables the apps on the HMD

## What's not disabled
- Store (so that games can be installed)
- People (it can be disabled using lighting launcher anyway)

## Prerequisite
ADB must be enabled and the device must be connected using USB

## How to run [For all users]
- You can use <br/>
  ```iex (iwr "https://raw.githubusercontent.com/revoconner/Quest-3-Debloater/main/q3debloater.ps1" -UseBasicParsing).Content``` <br/>
  to run it from powershell
- Search for CMD in your start menu
- Once the terminal opens, type powershell
- And then copy and paste the code
## How to run [For advance users]
- You can download the project as zip and run the .bat file
## Notes
- Last tested on quest 3 update v78
- Packaged using enigma virtual box
- The first time you enable adb (developer setting on oculus phone app) you may have to confirm the prompt on the headset else the device won't connect
