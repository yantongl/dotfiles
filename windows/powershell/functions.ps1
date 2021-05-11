# Basic commands
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function touch($file) { "" | Out-File $file -Encoding ASCII }

# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
Set-Alias ".." cd..
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }


# Directory Listing: Use `ls.exe` if available
# if (Get-Command ls.exe -ErrorAction SilentlyContinue | Test-Path) {
#     rm alias:ls -ErrorAction SilentlyContinue
#     # Set `ls` to call `ls.exe` and always use --color
#     ${function:ls} = { ls.exe --color @args }
#     # List all files in long format
#     ${function:l} = { ls -lF @args }
#     # List all files in long format, including hidden files
#     ${function:la} = { ls -laF @args }
# } else {
#     # List all files, including hidden files
#     ${function:la} = { ls -Force @args }
# }

# List only directories
#${function:lsd} = { Get-ChildItem -Directory -Force @args }  # conflicting with rust lsd

# add VC vars
function add_vc_vars {
    cmd.exe /c "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build\vcvars32.bat"
}

function check_system_paths { echo $env:path.Split(';') }

function reload_system_path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

function remove_empty_dir {
    # gci is get-childitem
    $folder = $args[0]
    write-output ("working directory:"+$folder)

    # find all folders recursively that has no files.
    # if a folder has only folder child items, it will also be included.
    $dirs = gci $folder -directory -recurse | Where { (gci $_.fullName -recurse -file).count -eq 0 } | select -expandproperty FullName
    # reverse the order, so we always delete child item before parent folder
    $reverse = $dirs | ForEach-Object { $_ }
    [array]::Reverse($reverse)
    $reverse | Foreach-Object {
        write-output ("deleting:"+$_)
        Remove-Item $_
    }
}

function get_functions {
    # read current file
    # $ProfileDir = Split-Path -parent $profile
    # $CurrentFilePath = "$ProfileDir\functions.ps1"
    $CurrentFilePath = Join-Path (split-path -parent $profile) functions.ps1
    $CurrentFileContent = get-content $CurrentFilePath
    # get functions defined in this file
    gci function: -Name | foreach-object { if ($_ -notlike "*:") {
        # special check "cd\" because -imatch will consider '\' as escape character and the
        # function as in-complete string
        if ($_ -eq "cd\") { $_ }
        elseif ($CurrentFileContent -imatch $_) { $_ } }
    } | sort-object
}

function search_word
{
    $word = $args[0]

    if ($args.Length -eq 1) {
        Start-Process "www.google.com/search?q=define+$word"
    }
    else {
        switch ($args[1]) {
            "mw" { Start-Process "https://www.merriam-webster.com/dictionary/$word" }
            "dict" { Start-Process "https://www.dictionary.com/browse/$word" }
            "ud" { Start-Process "https://www.urbandictionary.com/define.php?term=$word" }
        }
    }
}

# export scoop app names to scoop-apps.txt
function scoop_export
{
    $filename = "scoop-apps.txt"
    if ($args.Length -gt 0) {
        $filename = $args[0]
    }
    (scoop export) | sls '^([\w-.]+)' |% { $_.matches.groups[1].value } > $filename
}

# install apps from scoop-apps.txt
function scoop_import
{
    $filename = "scoop-apps.txt"
    if ($args.Length -gt 0) {
        $filename = $args[0]
    }
    $apps = gc $filename
    scoop install @apps
}

# find out what app is installed locally but not in scoop-apps.txt
function scoop_diff_apps
{
    $filename = "scoop-apps.txt"
    if ($args.Length -gt 0) {
        $filename = $args[0]
    }
    $installed = (scoop export) | sls '^([\w-.]+)' |% { $_.matches.groups[1].value }
    $keyapps = gc $filename
    compare-object -ReferenceObject $installed -DifferenceObject $keyapps -PassThru
}

function setup_powershell_theme
{
    Invoke-Expression (&starship init powershell)
    Import-Module -Name Terminal-Icons

    #Invoke-Expression (oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh3)/themes/material.omp.json")

#     using pshazz
#     $null = gcm pshazz -ea stop;
#     pshazz init 'default'
#     pshazz use lukes
}

function cleanup_build_files {
    rm -Recurse *.sdf
    rm -Recurse *.pdb
    rm -Recurse *.ilk
    rm -Recurse *.obj
    rm -Recurse *.pch
    rm -Recurse *.ipch
    rm -Recurse *.pchast
    rm -Recurse *.so
    rm -Recurse *.tlog
    rm -Recurse *.o
    rm -Recurse *.suo
    rm -Recurse *.idb
}

# snippets

## find-and-open-file:
##    gci $args[0] -Recurse -Name $args[1] | ? { vim $_ }

