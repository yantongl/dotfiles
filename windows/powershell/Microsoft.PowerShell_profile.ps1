# Profile for the Microsoft.Powershell Shell, only. (Not Visual Studio or other PoSh instances)
# ===========

$sw = [Diagnostics.Stopwatch]::StartNew()
    Push-Location (Split-Path -parent $profile)
    "functions","alias", "bookmark" | Where-Object {Test-Path "$_.ps1"} | ForEach-Object -process {Invoke-Expression ". .\$_.ps1"}
    Pop-Location
$sw.Stop()
"$($sw.Elapsed.TotalSeconds) seconds: load other scripts"

$sw.Restart()
    Invoke-Expression (&starship init powershell)
$sw.Stop()
"$($sw.Elapsed.TotalSeconds) seconds: init starship"

#Invoke-Expression (oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh3)/themes/material.omp.json")
$sw.Restart()
    Import-Module -Name Terminal-Icons
$sw.Stop()
"$($sw.Elapsed.TotalSeconds) seconds: import Terminal-Icons"

# use zoxide
$sw.Restart()
    Invoke-Expression (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
        (zoxide init --hook $hook powershell) -join "`n"
    })
$sw.Stop()
"$($sw.Elapsed.TotalSeconds) seconds: init zoxide"


