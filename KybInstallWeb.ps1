Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to install Kyborg
function Install-Kyborg {
    # (Paste the entire Kyborg installation script here)
    # Create the directory
$temp_destination = "C:\temp"
New-Item -ItemType Directory -Path $temp_destination -ErrorAction SilentlyContinue | Out-Null

# Specify the file ID of the file you want to download
$fileId = "1bJso6Wrwgg3k0bsmfvPuTFJ8HfUkbznA"

# Specify the local path where you want to save the downloaded file
$destinationPath = "C:\temp\kyborg.zip"

# Generate the download URL for the file
$baseUrl = "https://drive.google.com/uc?export=download&id=$fileId"
$confirmParam = (Invoke-WebRequest -Uri $baseUrl -Method HEAD).Headers."Set-Cookie" -replace ".*confirm=([^;]+).*", '$1'
$downloadUrl = "$baseUrl&confirm=$confirmParam"

# Download the file using System.Net.WebClient
$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($downloadUrl, $destinationPath)

# Specify the path of the downloaded ZIP file
$zipFilePath = "C:\temp\kyborg.zip"

# Specify the destination folder where you want to extract the files
$destinationFolder = "C:\temp\"

# Extract the ZIP file
Expand-Archive -Path $zipFilePath -DestinationPath $destinationFolder

# Specify the paths for the directories
$kyborg = "C:\Program Files (x86)\Kyborg"
$kyborg4 = "C:\Program Files (x86)\Kyborg\Kyborg Emulator 4.0"
$autohotkey = "C:\Program Files (x86)\Kyborg\Kyborg Emulator 4.0\Autohotkey"
$xming = "C:\Program Files (x86)\Kyborg\Kyborg Emulator 4.0\Xming"
$final_destination = "C:\Program Files (x86)\Kyborg\Kyborg Emulator 4.0"

# Create the directories
New-Item -ItemType Directory -Path $kyborg -ErrorAction SilentlyContinue | Out-Null
New-Item -ItemType Directory -Path $kyborg4 -ErrorAction SilentlyContinue | Out-Null
New-Item -ItemType Directory -Path $autohotkey -ErrorAction SilentlyContinue | Out-Null
New-Item -ItemType Directory -Path $xming -ErrorAction SilentlyContinue | Out-Null

# Specify the path to the VC_redist.x64 installer
$installerPath = "C:\temp\VC_redist.x64.exe"

# Specify the command-line arguments for silent installation without restart
$arguments = "/install /quiet /norestart /log install_log.txt"

# Install VC_redist.x64 silently without restart
Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait

# Move the extracted file from C:\temp to the final destination
if (Test-Path "$temp_destination\kyborg.exe") {
    Move-Item -Path "$temp_destination\kyborg.exe" -Destination "$final_destination\kyborg.exe" -Force
}
else {
    Write-Output "Error: kyborg.exe does not exist in the temporary directory."
}

if (Test-Path "$temp_destination\AutoHotkey_2.0.2_setup.exe") {
    Move-Item -Path "$temp_destination\AutoHotkey_2.0.2_setup.exe" -Destination "$autohotkey\AutoHotkey_2.0.2_setup.exe" -Force
}
else {
    Write-Output "Error: AutoHotkey_2.0.2_setup.exe does not exist in the temporary directory."
}

if (Test-Path "$temp_destination\Kyborg.ahk") {
    Move-Item -Path "$temp_destination\Kyborg.ahk" -Destination "$autohotkey\Kyborg.ahk" -Force
}
else {
    Write-Output "Error: Kyborg.ahk does not exist in the temporary directory."
}

$lpd = "C:\temp\lpd"

# Specify the destination path for the folder
$lpddest = "$final_destination\lpd"

# Move the folder to the destination
Move-Item -Path $lpd -Destination $lpddest -Force

if (Test-Path "$temp_destination\Xming-6-9-0-31-setup.exe") {
    Move-Item -Path "$temp_destination\Xming-6-9-0-31-setup.exe" -Destination "$xming\Xming-6-9-0-31-setup.exe" -Force
}
else {
    Write-Output "Error: Xming-6-9-0-31-setup.exe does not exist in the temporary directory."
}

if (Test-Path "$temp_destination\Xming-7-7-0-46-setup.exe") {
    Move-Item -Path "$temp_destination\Xming-7-7-0-46-setup.exe" -Destination "$xming\Xming-7-7-0-46-setup.exe" -Force
}
else {
    Write-Output "Error: Xming-7-7-0-46-setup.exe does not exist in the temporary directory."
}

# Specify the path of the shortcut on the desktop
$shortcutPath = "$HOME\Desktop\Start Kyborg.lnk"

# Specify the target path, working directory, arguments, and icon path
$targetPath = "C:\Program Files (x86)\Kyborg\Kyborg Emulator 4.0\kyborg.exe"
$workingDirectory = "C:\Program Files (x86)\Kyborg\Kyborg Emulator 4.0"
$arguments = "-load kyborg.cfg"
$iconPath = "C:\Program Files (x86)\Kyborg\Kyborg Emulator 4.0\kyborg.exe"

# Create a shell object
$shell = New-Object -ComObject WScript.Shell

# Create a shortcut object
$shortcut = $shell.CreateShortcut($shortcutPath)

# Set the properties of the shortcut
$shortcut.TargetPath = $targetPath
$shortcut.WorkingDirectory = $workingDirectory
$shortcut.Arguments = $arguments
$shortcut.IconLocation = $iconPath

# Save the shortcut
$shortcut.Save()

# Remove the directory and all its contents recursively
Remove-Item -Path $temp_destination -Recurse -Force

# Modify Permissions
$folder_path = $kyborg
$command = "icacls `"$folder_path`" /grant Users:(OI)(CI)F /t /c"
Invoke-Expression $command
}

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Software Installer'
$form.Size = New-Object System.Drawing.Size(320, 240) # Adjusted size to accommodate new checkbox
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$form.ForeColor = [System.Drawing.Color]::WhiteSmoke
$form.FormBorderStyle = 'FixedDialog'

# Checkbox for Kyborg
$kyborgCheckbox = New-Object System.Windows.Forms.CheckBox
$kyborgCheckbox.Location = New-Object System.Drawing.Point(20, 20)
$kyborgCheckbox.Size = New-Object System.Drawing.Size(280, 20)
$kyborgCheckbox.Text = 'Install Kyborg'
$kyborgCheckbox.ForeColor = [System.Drawing.Color]::WhiteSmoke
$form.Controls.Add($kyborgCheckbox)

# Install button
$installButton = New-Object System.Windows.Forms.Button
$installButton.Location = New-Object System.Drawing.Point(20, 50)
$installButton.Size = New-Object System.Drawing.Size(130, 30)
$installButton.Text = 'Install'
$installButton.BackColor = [System.Drawing.Color]::FromArgb(28, 151, 234)
$installButton.ForeColor = [System.Drawing.Color]::WhiteSmoke
$installButton.Add_Click({
    if ($kyborgCheckbox.Checked) {
        Install-Kyborg
    }
})
$form.Controls.Add($installButton)

# Exit button
$exitButton = New-Object System.Windows.Forms.Button
$exitButton.Location = New-Object System.Drawing.Point(160, 50)
$exitButton.Size = New-Object System.Drawing.Size(130, 30)
$exitButton.Text = 'Exit'
$exitButton.BackColor = [System.Drawing.Color]::FromArgb(255, 80, 80)
$exitButton.ForeColor = [System.Drawing.Color]::WhiteSmoke
$exitButton.Add_Click({$form.Close()})
$form.Controls.Add($exitButton)

# Show the form
$form.ShowDialog()
