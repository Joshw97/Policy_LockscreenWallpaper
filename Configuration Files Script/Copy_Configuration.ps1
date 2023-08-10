#Copy Configuration
#Copies the desktop background images and BGInfo config to the client
#Contact | Josh Woods | joshua.woods@srft.nhs.uk

#Delete Folder
Remove-Item -Path "$env:programfiles\Policy_LockscreenWallpaper\*" -Recurse

#Create Folder
New-Item -Path "$env:programfiles" -Name "Policy_LockscreenWallpaper" -ItemType "directory"

#Copy Files
Copy-Item -path "$PSScriptRoot\Config\*" -Destination "$env:programfiles\Policy_LockscreenWallpaper" -Recurse -Force
