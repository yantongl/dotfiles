
###########################################################
## powershell bookmarks
###########################################################

function yt_load_bookmarks
{
    $global:bookmarks = @{ }
    $bookmarkPath = Join-Path (split-path -parent $profile) .bookmarks
    if (test-path $bookmarkPath)
    {
        Import-Csv $bookmarkPath | ForEach-Object { $bookmarks[$_.key] = $_.value }
        # Write-Output ("Loaded bookmarks from '{0}'" -f $bookmarkPath)
    }
}

function yt_save_bookmarks {
    $bookmarkPath = Join-Path (split-path -parent $profile) .bookmarks
    $bookmarks.getenumerator() | export-csv $bookmarkPath -notype
}

function yt_add_bookmark () {
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

    yt_load_bookmarks
    $bookmarks["$Name"] = $dir
    yt_save_bookmarks
    Write-Output ("Location '{1}' saved to bookmark {0}" -f $Name, $dir)
}


function yt_remove_bookmark () {
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

    yt_load_bookmarks
    $bookmarks.Remove($Name)
    yt_save_bookmarks
    Write-Output ("Location '{0}' removed from bookmarks" -f $Name)
}

function yt_goto_bookmark() {
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

function yt_list_bookmarks {
    yt_load_bookmarks
    Write-Output ($bookmarks.GetEnumerator() | sort Name)
}

function yt_clear_bookmarks {
    $bookmarks = @{ }
    yt_save_bookmarks
}


$bookmarks = @{ }

yt_load_bookmarks

function yt_fzf_goto_bookmark {
    yt_goto_bookmark (yt_list_bookmarks | foreach-object {$_.Name} | fzf)
}

Set-Alias ba yt_add_bookmark
Set-Alias bg yt_fzf_goto_bookmark
Set-Alias bl yt_list_bookmarks
Set-Alias br yt_remove_bookmark
