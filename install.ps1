$caller = pwd
cd "$PSScriptRoot\files"

Start-Process -Verb runas -Wait pwsh.exe( `
        "-Command cd $pwd;" + `
        "$PSScriptRoot\scripts\runas.ps1;")

cd $caller
