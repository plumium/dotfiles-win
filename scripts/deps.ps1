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
winget install --id Microsoft.PowerShell --source winget --version 7.4.2
winget install --id Git.Git --source winget --version 2.45.2
winget install --id vim.vim --source winget --version 9.1.0514
winget install --id version-fox.vfox --source winget --version 0.5.4
winget install --id 7zip.7zip --source winget --version 24.07
winget install --id Alacritty.Alacritty --source winget --version 0.13.2
winget install --id Task.Task --source winget --version 3.37.2

vfox add python
vfox install python@3.12.0
python -m pip install pgcli
python -m pip install 'psycopg[binary,pool]'

vfox add golang
vfox install golang@1.22.2

vfox add java
vfox install java@21.0.2+13

vfox add maven
vfox install maven@3.9.6

vfox add gradle
vfox install gradle@8.8
