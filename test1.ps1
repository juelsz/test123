Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to install software
function Install-Software([string]$url, [string]$installerPath, [string]$arguments) {
    Invoke-WebRequest -Uri $url -OutFile $installerPath
    Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait -NoNewWindow
    Remove-Item -Path $installerPath
}

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Software Installer'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

# Checkbox for Google Chrome
$chromeCheckbox = New-Object System.Windows.Forms.CheckBox
$chromeCheckbox.Location = New-Object System.Drawing.Point(10,10)
$chromeCheckbox.Size = New-Object System.Drawing.Size(280,20)
$chromeCheckbox.Text = 'Install Google Chrome'
$form.Controls.Add($chromeCheckbox)

# Checkbox for VLC Media Player
$vlcCheckbox = New-Object System.Windows.Forms.CheckBox
$vlcCheckbox.Location = New-Object System.Drawing.Point(10,40)
$vlcCheckbox.Size = New-Object System.Drawing.Size(280,20)
$vlcCheckbox.Text = 'Install VLC Media Player'
$form.Controls.Add($vlcCheckbox)

# Install button
$installButton = New-Object System.Windows.Forms.Button
$installButton.Location = New-Object System.Drawing.Point(10,70)
$installButton.Size = New-Object System.Drawing.Size(280,30)
$installButton.Text = 'Install'
$installButton.Add_Click({
    if ($chromeCheckbox.Checked) {
        Install-Software -url 'https://dl.google.com/chrome/install/latest/chrome_installer.exe' -installerPath 'C:\Temp\chrome_installer.exe' -arguments '/silent /install'
    }
    if ($vlcCheckbox.Checked) {
        Install-Software -url 'https://download.videolan.org/pub/videolan/vlc/last/win64/vlc-3.0.16-win64.exe' -installerPath 'C:\Temp\vlc_installer.exe' -arguments '/L=1033 /S /NCRC'
    }
})
$form.Controls.Add($installButton)

# Show the form
$form.ShowDialog()
