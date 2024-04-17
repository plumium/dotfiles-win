function Run {
    param (
        $Name
    )
    . "$PSScriptRoot/$Name"
}

Run -Name 'deps.ps1'
Run -Name 'symlink.ps1'