
# alias
Set-Alias vi 'C:\Program Files\Vim\vim90\vim.exe'
Set-Alias eclipse 'C:\Program Files\Eclipse Foundation\2023-03-jee\eclipse\eclipse.exe'

function Prompt {
    Write-Host "${env:USERNAME}@${env:COMPUTERNAME} " -NoNewLine -ForegroundColor "Cyan"
    Write-Host $pwd -NoNewLine -ForegroundColor "DarkCyan"
    return ">"
}

# function
function GenerateMavenProject {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]$Scope
    )
    process {
        Invoke-Expression "mvn archetype:generate -DarchetypeCatalog=${scope}"
    }
}

function OpenEclipseWorkspace{
    param(
        [parameter(ValueFromPipeline)]$Path
    )
    if(-not(Test-Path "$Path\.metadata")){
        Write-Host "workspace not found"
        return
    }
    Invoke-Expression "eclipse -data ${Path}"
}

function DockerRemoveExitedProcess {
    Invoke-Expression 'docker ps -qf status=exited | % {docker rm $_}'
}

function DockerListImageTemplate {
    Invoke-Expression "docker images --format '{{.Repository}}:{{.Tag}}'"
}
