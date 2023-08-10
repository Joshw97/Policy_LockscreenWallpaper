#Policy Lockscreen Wallpaper Discovery Script
#Discovery Script for Configuration baseline
#Contact | Josh Woods
#IMPORTANT | Update version number below for each update for the Remediation and Discovery Script!!!

#Variables
$Version = "1.9"

#Version Control
#Test if the current version is present
$TestReg = Get-ItemProperty 'HKLM:\Software\CustomPolicies' -Name Policy_LockscreenWallpaper | Select-Object -ExpandProperty Policy_LockscreenWallpaper

if ($TestReg -ne $Version){
    Write-Host "False"
    Exit
}


#Get Screen Resolution. The largest resolution is selected. If more than one of the largest resolution exists, both with be included.
$ScreenHeight = Get-WmiObject -Class Win32_DesktopMonitor | measure-object -Property ScreenHeight -maximum | Select-Object -ExpandProperty Maximum
$ScreenWidth = Get-WmiObject -Class Win32_DesktopMonitor | measure-object -Property ScreenWidth -maximum | Select-Object -ExpandProperty Maximum

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

    $TestImage = "$env:programfiles\Policy_LockscreenWallpaper\Wallpaper\img0_$($Item.Width)x$($Item.Height).jpg"
    $Testpath = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization' | select-object -ExpandProperty LockscreenImage

    if ($Testpath -eq $TestImage) {
        Write-Host "True"
        Exit 0
    }
    else {
        #Do nothing
    }
    }

}