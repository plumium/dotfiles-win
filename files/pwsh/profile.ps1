
# alias
Set-Alias vi 'C:\Program Files\Vim\Vim91\vim.exe'
Set-Alias eclipse 'C:\Program Files\Eclipse Foundation\2023-03-jee\eclipse\eclipse.exe'
Set-Alias 7z 'C:\Program Files\7-Zip\7z.exe'
Set-Alias msbuild 'C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe'

Set-PSReadLineOption -PredictionViewStyle ListView

function Prompt {
    Write-Host "$pwd`e[5 q" -NoNewLine -ForegroundColor Cyan
    Write-Host " $(Get-GitPrompt)" -NoNewline -ForegroundColor Red
    Write-Host ""
    Write-Host ">" -NoNewLine -ForegroundColor Blue
    return " "
}

# Define functions
function sudo() {
    $cmd = $args[0] 
    $cmdArgs = [System.Collections.ArrayList]::new($args.Count - 1)
    foreach ($arg in $args[1..$args.Count]) {
        if ($arg -match ' ') {
            $cmdArgs.Add("`'$arg`'") | Out-Null 
        }
        else {
            $cmdArgs.Add($arg) | Out-Null 
        }
    }
    $options = @{
        FilePath     = 'pwsh.exe'
        ArgumentList = '-Command', $cmd, $cmdArgs -join ' '
        Verb         = 'RunAs'
        WindowStyle  = 'Hidden'
        Wait         = $true
    }
    Start-Process @options
}

function du() {
    $folders = Get-ChildItem -Directory -Recurse $args[0]
    $FolderSizes = for ($i = 0; $i -lt $folders.Count; $i++) {
        $size = (Get-ChildItem -File -Recurse $folders[$i].FullName | Measure-Object Length -Sum).Sum
        $sizeInMB = $size / 1MB
        $per = (($i / $folders.Count) * 100).ToString('0') 
        Write-Progress -Activity "Calc in Progress" -Status "$per% Complete" -PercentComplete $per
        [PSCustomObject]@{
            FolderName = $folders[$i].FullName
            SizeInMB   = [Math]::Round($sizeInMB, 2)
        }
    }
    $FolderSizes | Format-Table
}

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

function Test-GitRepository([string]$Path = ".") {
    return $(git -C $Path rev-parse --is-inside-work-tree 2>$null) -eq $true
}

function Get-GitBranch([string]$Path = ".") {
    return $(git -C $Path branch 2>$null) |
        Select-String -Pattern '(?<=\*\s).*$' |
        ForEach-Object Matches |
        ForEach-Object Value
}

function Get-GitPrompt([string]$Path = ".") {
    if (Test-GitRepository $Path) {
        return "($(Get-GitBranch $Path))"
    }
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

Register-ArgumentCompleter -Native -CommandName vfox -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    $other = "$wordToComplete --generate-bash-completion"
    Invoke-Expression $other | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

Invoke-Expression "$(vfox activate pwsh)"
