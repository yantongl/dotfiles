<#
Run this script as administrator!

How to setup Windows DevEnvironment:
1.  install MSYS2:     https://www.msys2.org/
    add `<path-to-msys64>\mingw64\bin` to environment path
2.  install Windows-Terminal
3.  run this script as Admin
#>

echo "Running init..."

# function to check if a tool is already installed
Function IsInstalled([string] $appname) {
    Get-Command $appname -ErrorAction SilentlyContinue | Select-Object Definition
    $?
}

Function MakeSymbolicLink([string] $target, [string] $source) {
    Remove-Item -Recurse "$target" -ErrorAction SilentlyContinue
    Write-Output "linking $target to $source"
    New-Item -Path "$target" -ItemType SymbolicLink -Value "$source"
}

Function ConfigPowershell {
    $profileDir = Split-Path -parent $profile
    New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue # create $profileDir folder

    # link all .ps1 files
    gci powershell *.ps1 | foreach-object { MakeSymbolicLink "$profileDir\$($_.Name)" $_.fullname }

    # install powershell modules
    Install-Module -Name Terminal-Icons -Repository PSGallery
    scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json
}

Function InstallPackageManager {
    # install chocolatey
    if (-not IsInstalled choco)
    {
        iwr -useb https://chocolatey.org/install.ps1 | iex
    }

    # install scoop and its extra buckets
    if (-not IsInstalled scoop)
    {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

        # this will install scoop to a custom directory
        # $env:SCOOP='C:\Scoop'
        # [Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')
        # $env:SCOOP_GLOBAL='C:\ScoopGlobalApps'
        # [Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine')

        #iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
        iwr -useb get.scoop.sh | iex

        # add additional buckets
        scoop bucket add extras
        scoop bucket add versions
        scoop bucket add nerd-fonts
    }

    # install core scoop apps
    $apps = gc scoop-key-apps.txt
    scoop install @apps
    # install apps on chocolatey only
    choco install barrier
}

Function ConfigMiscTools {
    $location = get-location
    $currentDir = $location.Path

    # apps nvim needs
    MakeSymbolicLink "$env:LOCALAPPDATA\nvim" "$currentDir/../shared/nvim"  # vim configuration
    python -m pip install --user --upgrade pynvim  # let python be aware of pynvim module
    # install tree-sitter.exe
    cargo install tree-sitter-cli
    pip3 install tree_sitter

    # starship
    MakeSymbolicLink "$HOME\.config\starship.toml" "$currentDir/../shared/.config/starship.toml"

    # sublime-text configuration
    $st_packages = "$env:userprofile\scoop\persist\sublime-text\Data\Packages"
    rmdir -recurse "$st_packages\User"
    # iex "cmd /c mklink /D $st_packages\User $currentDir\Sublime\User"
    MakeSymbolicLink "$st_packages\User" "$currentDir\Sublime\User"
    MakeSymbolicLink "$st_packages\myplugin" "$currentDir\Sublime\myplugin"

    ### vscode configuration
    MakeSymbolicLink "$env:appdata\Code\User\settings.json" "$currentDir\vscode\settings.json"

    if (IsInstalled wt) {
        $WTSettings_target = "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
        MakeSymbolicLink "$WTSettings_target" "$currentDir\WindowsTerminalSettings"
    }
}

################################################################################
# install

pushd
    ConfigPowershell
    ConfigWindowsTerminal
    InstallPackageManager
    ConfigMiscTools
popd


echo "done!"
