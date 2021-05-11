# My dotfiles for all systems
I originally forked [Mathias’s dotfiles](https://github.com/mathiasbynens/dotfiles) to fit my need.
After a lot of trimming+adjusting, this is different enough that it has little to do with the original
repo. It is fully my own dotfiles now.

## Folder Structures
- posix : configures for mac/linux
- shared: files used on multiple platforms
- windows: windows only configures.

## How to use on Windows

### The Profile Files

| Description               | Path                                                              |
| ------------------------- | ----------------------------------------------------------------- |
| All Users, All Hosts      | $PSHOME\Profile.ps1                                               |
| All Users, Current Host   | $PSHOME\Microsoft.PowerShell_profile.ps1                          |
| Current User, All Hosts   | $Home\[My ]Documents\PowerShell\Profile.ps1                       |
| Current user, Current Host| $Home\[My ]Documents\PowerShell\Microsoft.PowerShell_profile.ps1  |

### How to install
Simply run install.ps1 (may need admin permission).
It will make symlinks to other \*.ps1 files in the $profile directory.