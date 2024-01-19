# Example PowerShell Script for Silent Software Installation

# Define a function to download and execute an installer
function Install-Software([string]$url, [string]$installerPath, [string]$arguments) {
    # Download the installer
    Invoke-WebRequest -Uri $url -OutFile $installerPath

    # Execute the installer silently
    Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait -NoNewWindow

    # Optionally, remove the installer file after installation
    Remove-Item -Path $installerPath
}

# Software URLs and installer paths
$chromeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
$chromeInstaller = "C:\Temp\chrome_installer.exe"
$vlcUrl = "https://download.videolan.org/pub/videolan/vlc/last/win64/vlc-3.0.16-win64.exe"
$vlcInstaller = "C:\Temp\vlc_installer.exe"

# Installation arguments for silent installation
$chromeArgs = "/silent /install"
$vlcArgs = "/L=1033 /S /NCRC"

# Ensure the Temp directory exists
New-Item -Path "C:\Temp" -ItemType Directory -Force

# Install Google Chrome
Install-Software -url $chromeUrl -installerPath $chromeInstaller -arguments $chromeArgs

# Install VLC Media Player
Install-Software -url $vlcUrl -installerPath $vlcInstaller -arguments $vlcArgs
