# parent directory
Set-Variable -Option Constant -Name parent -Value ($PSScriptRoot | Split-Path)
Set-Variable -Option Constant -Name targetRoot -Value "$parent\home"
$dryRun = $false

if ($args[0] -eq '--dry-run') {
    $dryRun = $true
}

function ProcessBegin {
    foreach ($item in $input) {
        switch ($item | ForEach-Object GetType | ForEach-Object Name) {
            'FileInfo' { $item | ProcessFile }
            'DirectoryInfo' { $item | ProcessDirectory }
            Default { throw 'invalid file type' }
        }
    }
}

function ProcessFile {
    $input | 
        ForEach-Object {
            $path = $_.FullName |
                ForEach-Object Replace $targetRoot '' |
                ForEach-Object Substring(1) |
                ForEach-Object { Join-Path $env:USERPROFILE $_ }

                Write-Output "$path -> $($_.FullName)" 
                if (-not $dryRun) {
                    New-Item -Force -ItemType SymbolicLink -Path $path -Target $_.FullName | Out-Null
                }
            }
}

function ProcessDirectory {
    $input | Get-ChildItem -Recurse -File |
        ForEach-Object { 
            $_.Directory | 
                ForEach-Object FullName |
                ForEach-Object Replace $targetRoot '' |
                ForEach-Object Substring(1) |
                ForEach-Object { Join-Path $env:USERPROFILE $_ } |
                Where-Object { -not(Test-Path $_) } |
                ForEach-Object { mkdir $_ | Out-Null }

                $_ | ProcessFile
            }
}

Get-ChildItem $targetRoot | ProcessBegin
foreach ($item in @(
        @("$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json", "$parent\files\wt\settings.json"),
        @("$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 ", "$parent\files\pwsh\profile.ps1")
    )) {
    Write-Output "$($item[0]) -> $($item[1])" 
    if (-not $dryRun) {
        New-Item -Force -ItemType SymbolicLink -Path $item[0] -Target $((Get-ChildItem $item[1]).FullName) | Out-Null
    }
}
Pause