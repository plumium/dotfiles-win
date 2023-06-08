#Requires -RunAsAdministrator

function CreateBackup {
    param (
        [string]$File
    )
    $now = (Get-Date).ToString("yyyyMMdd_HHmmss")
    $name = (ls $File).Name
    $fileName = "${now}_${name}.backup"
    cp $File $fileName
    return (ls $fileName).FullName
}

function CreateSymLink {
    param (
        [string]$File,
        [string]$Dest,
        [string]$Name
    )
    $fileInfo = ls $File
    $actualName = -not([string]::IsNullOrEmpty($Name)) ? $Name : $fileInfo.Name
    $targetFile = Join-Path $Dest $actualName 
    if (Test-Path $targetFile) {
        # backup if file
        if ((ls $targetFile).LinkTarget.Length -eq 0) {
            $backup = CreateBackup $targetFile
            $backupDir = "$env:USERPROFILE\dotfiles-win-backup"
            if (-not(Test-Path $backupDir)) {
                ni $backupDir -ItemType Directory
            }
            mv $backup $backupDir
            echo "backup old file: $targetFile to $backup"
        }
        rm $targetFile
    } 
    ni -Value $fileInfo.FullName `
        -Path $Dest `
        -Name $actualName `
        -ItemType SymbolicLink | Out-Null
    echo "create symlink: $targetFile to $fileInfo"
}

# create symbolic links
if ((pwd).ToString() -ne "$env:userprofile\dotfiles-win\files") {
    throw
    trap {
        'invalid operation'
        Read-Host "exit"
        break
    }
}

# windows terminal
CreateSymLink -File ".\wt\settings.json" -Dest "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

# powershell
$name = $PROFILE.Substring($PROFILE.LastIndexOf("\") + 1) 
$dir = $PROFILE.Substring(0, $PROFILE.LastIndexOf("\")) 
CreateSymLink -File ".\powershell\profile.ps1" -Dest $dir -Name $name

# git
CreateSymLink -File ".\git\.gitconfig" -Dest $env:USERPROFILE

# vim
CreateSymLink -File ".\vim\.vimrc" -Dest $env:USERPROFILE
CreateSymLink -File ".\vim\_vimrc" -Dest $env:USERPROFILE

# vrapper
CreateSymLink -File ".\vrapper\_vrapperrc" -Dest $env:USERPROFILE 

# vsvim
CreateSymLink -File ".\vsvim\_vsvimrc" -Dest $env:USERPROFILE 

# eclipse
CreateSymLink -File ".\eclipse\formatter.xml" -Dest $env:USERPROFILE 

Pause
