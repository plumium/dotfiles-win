$caller = pwd
cd "$PSScriptRoot\files"

# install scoop
try {
    if (Get-Command scoop) {
    }
}
catch {
    irm get.scoop.sh | iex
}
try {
    if (Get-Command zenhan) {
    }
}
catch {
    scoop install zenhan
}

# dbcli pgcli
cp -Force `
    -Path .\dbcli\pgcli\config `
    -Destination "$env:LOCALAPPDATA\dbcli\pgcli\config"

Start-Process -Verb runas -Wait pwsh.exe( `
        "-Command cd $pwd;" + `
        "$PSScriptRoot\scripts\runas.ps1;")

cd $caller
