
# alias
Set-Alias vi 'C:\Program Files\Vim\vim90\vim.exe'
Set-Alias eclipse 'C:\Program Files\Eclipse Foundation\2023-03-jee\eclipse\eclipse.exe'

Set-PSReadLineOption `
    -PredictionViewStyle ListView `

function Prompt {
    Write-Host "${env:USERNAME}@${env:COMPUTERNAME} " -NoNewLine -ForegroundColor Cyan
    Write-Host "$pwd`e[5 q" -NoNewLine -ForegroundColor DarkCyan
    Write-Host $($(Test-GitRepository) ? " ($(Get-CurrentGitBranchName 2>$null))":"") -NoNewline -ForegroundColor Red
    return ">"
}

# Define functions
function New-MavenProject {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]$Scope = "internal"
    )
    process {
        Invoke-Expression "mvn archetype:generate -DarchetypeCatalog=${scope}"
    }
}

function Start-Eclipse {
    param(
        [parameter(ValueFromPipeline)]$Path = ".\"
    )
    if (-not(Test-Path "$Path\.metadata")) {
        Write-Host "Eclipse workspace does not found in $Path"
        return
    }
    Invoke-Expression "eclipse -data $Path"
}

function Test-GitRepository ([string]$Path = ".\") {
    return $(git -C $Path rev-parse --is-inside-work-tree 2>$null) -eq $true
}

function Get-CurrentGitBranchName ([string]$Path = ".\") {
    return $(git -C $Path branch) |
        Select-String -Pattern '(?<=\*\s).*$' |
        ForEach-Object { $_.Matches.Value }
}

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param(
            $wordToComplete,
            $commandAst,
            $cursorPosition
         )
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

