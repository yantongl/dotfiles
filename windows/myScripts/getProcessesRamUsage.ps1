<#
$Processes = get-process | Group-Object -Property ProcessName
foreach($Process in $Processes)
{
    $Obj = New-Object psobject
    $Obj | Add-Member -MemberType NoteProperty -Name Name -Value $Process.Name
    $Obj | Add-Member -MemberType NoteProperty -Name Mem -Value ($Process.Group|Measure-Object WorkingSet -Sum).Sum
    $Obj    
}
#>

$Processes = get-process | Group-Object -Property ProcessName 
$ProcArray = @()
foreach($Process in $Processes)
{
    $prop = @(
            @{n='Count';e={$Process.Count}}
            @{n='Name';e={$Process.Name}}
            @{n='Memory';e={($Process.Group | Measure-Object WS -Sum).Sum / 1mb}}
            )
    $ProcArray += "" | Select-Object $prop  
}

# output top 10 WS usage applications
$ProcArray | Sort-Object -Descending Memory | Select-Object -First 10 | Format-Table Count,Name,@{n='WS(MB)';e={"{0:N2}" -f ($_.Memory)};a='right'} -AutoSize

# ouput total WS usage
# $totalWS = ($ProcArray | Measure-Object Memory -Sum).Sum 
$totalWS = (get-process | Measure-Object WS -Sum).Sum/1gb
"Total working set RAM usage is {0:N2}GB" -f $totalWS

Function Test-MemoryUsage {
    [cmdletbinding()]
    Param()
     
    $os = Get-Ciminstance Win32_OperatingSystem
    $pctFree = [math]::Round(($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100,2)
     
    if ($pctFree -ge 45) {
    $Status = "OK"
    }
    elseif ($pctFree -ge 15 ) {
    $Status = "Warning"
    }
    else {
    $Status = "Critical"
    }
     
    $os | Select-Object @{Name = "Status";Expression = {$Status}},
    @{Name = "PctFree"; Expression = {$pctFree}},
    @{Name = "FreeGB";Expression = {[math]::Round($_.FreePhysicalMemory/1mb,2)}},
    @{Name = "TotalGB";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}}
}

Function Show-MemoryUsage { 
    [cmdletbinding()]
    Param()
     
    #get memory usage data
    $data = Test-MemoryUsage
     
    Switch ($data.Status) {
        "OK" { $color = "Green" }
        "Warning" { $color = "Yellow" }
        "Critical" {$color = "Red" }
    }
     
    $title = @"    
Memory Check
------------
"@
    
    Write-Host $title -foregroundColor Cyan
    
    $data | Format-Table -AutoSize | Out-String | Write-Host -ForegroundColor $color     
}

set-alias -Name smu -Value Show-MemoryUsage
Show-MemoryUsage