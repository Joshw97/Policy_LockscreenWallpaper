#Policy Lockscreen Wallpaper Remediation Script
#IMPORTANT | Update version number below for each update for the Remediation and Discovery Script!!!
#Contact | Josh Woods

#Variables
$Version = "1.9"

#Version Control
#Test if the version Registry Item exists and create a new entry if it doesn't
$TestReg = Get-ItemProperty 'HKLM:\Software\CustomPolicies' -Name Policy_LockscreenWallpaper | Select-Object -ExpandProperty Policy_LockscreenWallpaper

if ($TestReg -eq $Version){
 
}
Else {
    New-Item -Path 'HKLM:\Software' -Name 'CustomPolicies' -ErrorAction SilentlyContinue
    New-ItemProperty -Path 'HKLM:\Software\CustomPolicies' -Name Policy_LockscreenWallpaper -Value $Version -Force
}

#Get Screen Resolution. The largest resolution is selected. If more than one of the largest resolution exists, both with be included.
$ScreenHeight = Get-WmiObject -Class Win32_DesktopMonitor | measure-object -Property ScreenHeight -maximum | Select-Object -ExpandProperty Maximum
$ScreenWidth = Get-WmiObject -Class Win32_DesktopMonitor | measure-object -Property ScreenWidth -maximum | Select-Object -ExpandProperty Maximum

#Copy BGInfo
New-Item -Path "C:\Program Files" -Name "BGInfo" -ItemType "directory"
New-Item -Path "C:\Program Files\BGInfo" -Name "BGInfoTheme" -ItemType "directory"
New-Item -Path "C:\Program Files\BGInfo" -Name "Wallpaper" -ItemType "directory"
Copy-Item -Path "$env:programfiles\Policy_LockscreenWallpaper\BGInfo\Bginfo64.exe" -Destination "C:\Program Files\BGInfo"

#Adds a Registry Key for Personalization if it doesn't already exist.
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Personalization"

#Resolution List
$ResolutionList = @(
    [pscustomobject]@{Name='1024x768';Width=1024;Height=768}
    [pscustomobject]@{Name='1280x720';Width=1280;Height=720}
    [pscustomobject]@{Name='1366x768';Width=1366;Height=768}
    [pscustomobject]@{Name='1440x900';Width=1440;Height=900}
    [pscustomobject]@{Name='1536x864';Width=1536;Height=864}
    [pscustomobject]@{Name='1600x900';Width=1600;Height=900}
    [pscustomobject]@{Name='1920x1080';Width=1920;Height=1080}
    [pscustomobject]@{Name='1920x1200';Width=1920;Height=1200}
    [pscustomobject]@{Name='2560x1440';Width=2560;Height=1440}
    [pscustomobject]@{Name='2560x1600';Width=2560;Height=1600}
    [pscustomobject]@{Name='2880x1920';Width=2880;Height=1920}
    [pscustomobject]@{Name='3440x1440';Width=3440;Height=1440}
    [pscustomobject]@{Name='3840x2160';Width=3840;Height=2160}
)

foreach ($Item in $ResolutionList) {
    #Set Wallpaper and Lockscreen based on Screen Resolution
    if (($ScreenHeight -eq $Item.Height) -and ($ScreenWidth -eq $Item.Width)) {
        #Lockscreen
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization' -Name LockScreenImage -value "$env:programfiles\Policy_LockscreenWallpaper\Wallpaper\img0_$($Item.width)x$($Item.Height).jpg" -Force
        #BGInfo Wallpaper
        Remove-Item "C:\Program Files\BGInfo\Wallpaper\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\System32\oobe\info\backgrounds\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Program Files\BGInfo\BGInfoTheme\*" -Recurse -Force -ErrorAction SilentlyContinue
        Copy-Item "$env:programfiles\Policy_LockscreenWallpaper\Wallpaper\img0_$($Item.width)x$($Item.Height).jpg" -Destination "C:\Program Files\BGInfo\Wallpaper"
        Copy-Item "$env:programfiles\Policy_LockscreenWallpaper\Wallpaper\img0_$($Item.width)x$($Item.Height).jpg" -Destination "C:\Windows\System32\oobe\info\backgrounds"
        Copy-Item "$env:programfiles\Policy_LockscreenWallpaper\Wallpaper\img0_$($Item.width)x$($Item.Height).jpg" -Destination "C:\Windows\System32\oobe\info\backgrounds"
        Copy-Item "$env:programfiles\Policy_LockscreenWallpaper\BGInfo\$($Item.width)x$($Item.Height)\Config.bgi" -Destination "C:\Program Files\BGInfo\BGInfoTheme"
        Rename-Item -Path "C:\Windows\System32\oobe\info\backgrounds\img0_$($Item.width)x$($Item.Height).jpg" -NewName "backgroundDefault.jpg"
    }
    else {
        #Lockscreen
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization' -Name LockScreenImage -value "$env:programfiles\Policy_LockscreenWallpaper\Wallpaper\img0_$($Item.width)x$($Item.Height).jpg" -Force
        #BGInfo Wallpaper
        Remove-Item "C:\Program Files\BGInfo\Wallpaper\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\System32\oobe\info\backgrounds\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Program Files\BGInfo\BGInfoTheme\*" -Recurse -Force -ErrorAction SilentlyContinue
        Copy-Item "$env:programfiles\Policy_LockscreenWallpaper\Wallpaper\img0_$($Item.width)x$($Item.Height).jpg" -Destination "C:\Program Files\BGInfo\Wallpaper"
        Copy-Item "$env:programfiles\Policy_LockscreenWallpaper\Wallpaper\img0_$($Item.width)x$($Item.Height).jpg" -Destination "C:\Windows\System32\oobe\info\backgrounds"
        Copy-Item "$env:programfiles\Policy_LockscreenWallpaper\Wallpaper\img0_$($Item.width)x$($Item.Height).jpg" -Destination "C:\Windows\System32\oobe\info\backgrounds"
        Copy-Item "$env:programfiles\Policy_LockscreenWallpaper\BGInfo\$($Item.width)x$($Item.Height)\Config.bgi" -Destination "C:\Program Files\BGInfo\BGInfoTheme"
        Rename-Item -Path "C:\Windows\System32\oobe\info\backgrounds\img0_$($Item.width)x$($Item.Height).jpg" -NewName "backgroundDefault.jpg"
    }
}

#Run BGInfo at Logon
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BGInfo" -Value '"C:\Program Files\BGInfo\Bginfo64.exe" "C:\Program Files\BGInfo\BGInfoTheme\Config.bgi" /TIMER:0 /silent /NOLICPROMPT' -Force

#Run BGInfo Now (Do not use. If deploying as a configuration baseline in MECM this will not work as the system account is used. The Scheduled Task below works around this by running as the logged on user.)
#& "C:\Program Files\BGInfo\Bginfo64.exe" "C:\Program Files\BGInfo\BGInfoTheme\Config.bgi" /TIMER:0 /silent /NOLICPROMPT

#Scheduled Task - Refreshes the BGInfo Desktop Image (When running the script under the local System account this will run the BGInfo update as the currently logged on user)
$PS = New-ScheduledTaskAction -Execute "C:\Program Files\BGInfo\Bginfo64.exe" ` -Argument  '"C:\Program Files\BGInfo\BGInfoTheme\Config.bgi" /TIMER:0 /silent /NOLICPROMPT"'
$principal = New-ScheduledTaskPrincipal -UserId (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -expand UserName)
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -hidden
Register-ScheduledTask -TaskName "Wallpaper_BGInfo" -Action $PS -Principal $Principal -Settings $Settings | Out-Null
Start-ScheduledTask -TaskName "Wallpaper_BGInfo" | Out-Null
Start-Sleep -s 5
Unregister-ScheduledTask -TaskName "Wallpaper_BGInfo" -Confirm:$false