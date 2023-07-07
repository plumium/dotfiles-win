
# alias
Set-Alias vi 'C:\Program Files\Vim\vim90\vim.exe'
Set-Alias eclipse 'C:\Program Files\Eclipse Foundation\2023-03-jee\eclipse\eclipse.exe'

Set-PSReadLineOption `
    -PredictionViewStyle ListView `

function Prompt {
    Write-Host "${env:USERNAME}@${env:COMPUTERNAME} " -NoNewLine -ForegroundColor "Cyan"
    Write-Host $pwd -NoNewLine -ForegroundColor "DarkCyan"
    return ">"
}

# function
function Which($name) {
    Get-Command $name -ErrorAction SilentlyContinue
    | % { $_.Source.ToString() }
}

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

