
###########################################################
## powershell bookmarks
###########################################################

function load_bookmarks
{
    $global:bookmarks = @{ }
    $bookmarkPath = Join-Path (split-path -parent $profile) .bookmarks
    if (test-path $bookmarkPath)
    {
        Import-Csv $bookmarkPath | ForEach-Object { $bookmarks[$_.key] = $_.value }
        # Write-Output ("Loaded bookmarks from '{0}'" -f $bookmarkPath)
    }
}

function save_bookmarks {
    $bookmarkPath = Join-Path (split-path -parent $profile) .bookmarks
    $bookmarks.getenumerator() | export-csv $bookmarkPath -notype
}

function add_bookmark () {
    Param (
        [Parameter(Position = 0, Mandatory = $true)]
        [Alias("Bookmark")]
        $Name,
        [Parameter(Position = 1, ValueFromPipeline  = $True)]
        [Alias("Path")]
        [string]$dir = $null
    )

    if ( [string]::IsNullOrEmpty($dir) ) {
        $dir = (Get-Location).Path
    }

    load_bookmarks
    $bookmarks["$Name"] = $dir
    save_bookmarks
    Write-Output ("Location '{1}' saved to bookmark {0}" -f $Name, $dir)
}


function remove_bookmark () {
    Param (
        [Parameter(Position = 0, Mandatory = $true)]
        [Alias("Bookmark")]
        [ArgumentCompleter(
            {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
                return @($bookmarks) -like "$WordToComplete*"
            }
        )]
        $Name
    )

    load_bookmarks
    $bookmarks.Remove($Name)
    save_bookmarks
    Write-Output ("Location '{0}' removed from bookmarks" -f $Name)
}

function goto_bookmark() {
    Param(
    [Parameter(Position = 0, ValueFromPipelineByPropertyName  = $True, Mandatory = $true)]
    [Alias("Bookmark")]
    [ArgumentCompleter(
        {
            param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
            return @($bookmarks) -like "$WordToComplete*"
        }
    )]
    $Name
    )
    Set-Location $bookmarks["$Name"]
}

function list_bookmarks {
    load_bookmarks
    Write-Output ($bookmarks.GetEnumerator() | sort Name)
}

function clear_bookmarks {
    $bookmarks = @{ }
    save_bookmarks
}


$bookmarks = @{ }

load_bookmarks

function fzf_goto_bookmark {
    goto_bookmark (list_bookmarks | foreach-object {$_.Name} | fzf)
}

Set-Alias ba add_bookmark
Set-Alias bg fzf_goto_bookmark
Set-Alias bl list_bookmarks
Set-Alias br remove_bookmark
