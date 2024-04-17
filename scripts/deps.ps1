if ((Get-Command -Type Application | Where-Object Name -EQ 'winget.exe').Count -eq 0) {
    # https://learn.microsoft.com/en-us/windows/package-manager
    $ProgressPreference = 'SilentlyContinue'
    Write-Information "Downloading WinGet and its dependencies..."
    Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
    Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
    Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
    Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
}

$ProgressPreference = 'Continue'
winget source update
winget install --id Microsoft.PowerShell --version 7.4.2 --source winget 
winget install --id Git.Git --source winget
winget install --id vim.vim --source winget
winget install --id version-fox.vfox --source winget 
winget install --id 7zip.7zip --source winget

vfox add python
vfox add golang
vfox add java
vfox add maven
vfox install python@3.12.0
vfox install golang@1.22.2
vfox install java@21.0.2+13
vfox install java@8.0.342+7
vfox install maven@3.9.6

python -m pip install pgcli
python -m pip install 'psycopg[binary,pool]'