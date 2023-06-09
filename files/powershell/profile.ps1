
# alias
Set-Alias vi 'C:\Program Files\Vim\vim90\vim.exe'
Set-Alias eclipse 'C:\Program Files\Eclipse Foundation\2023-03-jee\eclipse\eclipse.exe'

function Prompt {
    Write-Host "${env:USERNAME}@${env:COMPUTERNAME} " -NoNewLine -ForegroundColor "Cyan"
    Write-Host $pwd -NoNewLine -ForegroundColor "DarkCyan"
    return ">"
}
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    }
    else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}
Set-PSReadLineOption `
    -PredictionViewStyle ListView `
    -EditMode Vi `
    -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

# function
function MvnArchetypeGenerate {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]$Scope
    )
    process {
        Invoke-Expression "mvn archetype:generate -DarchetypeCatalog=${scope}"
    }
}

function EclipseOpenWorkspace {
    param(
        [parameter(ValueFromPipeline)]$Path
    )
    if (-not(Test-Path "$Path\.metadata")) {
        Write-Host "workspace not found"
        return
    }
    Invoke-Expression "eclipse -data ${Path}"
}

