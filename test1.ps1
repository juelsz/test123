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
$form.Size = New-Object System.Drawing.Size(320, 200)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$form.ForeColor = [System.Drawing.Color]::WhiteSmoke

# Checkbox for Google Chrome
$chromeCheckbox = New-Object System.Windows.Forms.CheckBox
$chromeCheckbox.Location = New-Object System.Drawing.Point(20, 20)
$chromeCheckbox.Size = New-Object System.Drawing.Size(280, 20)
$chromeCheckbox.Text = 'Install Google Chrome'
$chromeCheckbox.ForeColor = [System.Drawing.Color]::WhiteSmoke
$form.Controls.Add($chromeCheckbox)

# Checkbox for VLC Media Player
$vlcCheckbox = New-Object System.Windows.Forms.CheckBox
$vlcCheckbox.Location = New-Object System.Drawing.Point(20, 50)
$vlcCheckbox.Size = New-Object System.Drawing.Size(280, 20)
$vlcCheckbox.Text = 'Install VLC Media Player'
$vlcCheckbox.ForeColor = [System.Drawing.Color]::WhiteSmoke
$form.Controls.Add($vlcCheckbox)

# Install button
$installButton = New-Object System.Windows.Forms.Button
$installButton.Location = New-Object System.Drawing.Point(20, 80)
$installButton.Size = New-Object System.Drawing.Size(130, 30)
$installButton.Text = 'Install'
$installButton.BackColor = [System.Drawing.Color]::FromArgb(28, 151, 234)
$installButton.ForeColor = [System.Drawing.Color]::WhiteSmoke
$installButton.Add_Click({
    if ($chromeCheckbox.Checked) {
        Install-Software -url 'https://dl.google.com/chrome/install/latest/chrome_installer.exe' -installerPath 'C:\Temp\chrome_installer.exe' -arguments '/silent /install'
    }
    if ($vlcCheckbox.Checked) {
        Install-Software -url 'https://download.videolan.org/pub/videolan/vlc/last/win64/vlc-3.0.16-win64.exe' -installerPath 'C:\Temp\vlc_installer.exe' -arguments '/L=1033 /S /NCRC'
    }
})
$form.Controls.Add($installButton)

# Exit button
$exitButton = New-Object System.Windows.Forms.Button
$exitButton.Location = New-Object System.Drawing.Point(160, 80)
$exitButton.Size = New-Object System.Drawing.Size(130, 30)
$exitButton.Text = 'Exit'
$exitButton.BackColor = [System.Drawing.Color]::FromArgb(255, 80, 80)
$exitButton.ForeColor = [System.Drawing.Color]::WhiteSmoke
$exitButton.Add_Click({$form.Close()})
$form.Controls.Add($exitButton)

# Show the form
$form.ShowDialog()
