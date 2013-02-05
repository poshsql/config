# General variables {{{
if ($env:COMPUTERNAME -eq 'shiju' -or $env:COMPUTERNAME -eq 'medusa'){
    set-variable work "D:\Work" 
}else{
    set-variable work "C:\Work" 
}
set-variable tools "$work\tools"
set-variable projects "$work\projects" 
set-variable PROFILE "$work\projects\config\Microsoft.PowerShell_profile.ps1" 
set-variable PROFILE2 "$work\projects\config\Private.PS_Profile.ps1" 
set-variable MYVIMRC "$work\projects\config\_vimrc" 
set-variable junk "$work\junk" 
set-variable poshsql "$work\projects\poshsql"
set-variable config "$work\projects\config"
Write-Host "Setting environment for $computerName" -foregroundcolor cyan

#$sw = @'
#[DllImport("user32.dll")]
#public static extern int ShowWindow(int hwnd, int nCmdShow);
#'@

#$type = Add-Type -Name ShowWindow2 -MemberDefinition $sw -Language CSharpVersion3 -Namespace Utils -PassThru

#}}}
# Environment variables {{{
# This is for C compiler
$env:INCLUDE = "D:\Work\tools\PellesC\Include"
$env:LIB = "D:\Work\tools\PellesC\LIB;D:\Work\tools\PellesC\LIB\win"
#}}}
# Setting the Path {{{
[System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";" +  $tools, "Process")
[System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";" + (Join-Path $tools "\git\bin"), "Process")
[System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";" + (Join-Path $tools "\PellesC\Bin"), "Process")
[System.Environment]::SetEnvironmentVariable("HOME", (Join-Path $Env:HomeDrive $Env:HomePath), "Process")
#}}}
# Powershell Alias {{{
new-item alias:np -value "C:\Windows\System32\notepad.exe"
new-item alias:gvim -value "$tools\vim\vim73\gvim.exe"
new-item alias:pixie -value "D:\Work\tools\pixie\pixie.exe"
new-item alias:vim -value "$tools\vim\vim73\vim.exe"
new-item alias:ediff -value "$tools\examdiff.exe"
new-item alias:fo -value "$tools\fossil.exe"
new-item alias:ex -value "explorer.exe"
#For explorer to work in a sepearate process below registry value should be set to 1
#This makes sure the process starts with a current
#HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\advanced\SeparateProcess 
#}}}
# Functions {{{
#Set-ExecutionPolicy remotesigned
function vi([string] $parameters){
	if ($parameters -eq "") {
        if (!(ps gvim -EA SilentlyContinue)){
    		gvim --servername Files
        }
	}else{
		gvim --servername Files --remote-silent-wait $parameters
	}
#    $gx = ps gvim #| select -first 1
#    $gx
#    $type::ShowWindow($gx.handle,6) #Minimize first
#    $type::ShowWindow($gx.handle,9) #Than restore

}
function c()
{
    dir *.c | sort -Property LastwriteTime -Descending | select -first 1 | % {cc $_.Name /x}
}

function cleanc()
{
    del *.exe 
    del *.obj 
}
function x()
{
    dir *.exe | sort -Property LastwriteTime -Descending | select -first 1 | % {&($_)}
}
function l()
{
    dir | sort LastWriteTime -Descending
}
cd $projects\programming\c\kr\ 
#import-module poshsql
function pq {
	remove-module poshsql;
	import-module poshsql;
	get-command -module poshsql;
}
# Get the current branch
function currentdir {
    $currentdir = (pwd).tostring().split('\')[-1]
    $Host.UI.RawUI.WindowTitle = $currentdir
}
#}}}
# Git functions {{{
# Mark Embling (http://www.markembling.info/)

# Is the current directory a git repository/working copy?
function isCurrentDirectoryGitRepository {
    if ((Test-Path ".git") -eq $TRUE) {
        return $TRUE
    }
    
    # Test within parent dirs
    $checkIn = (Get-Item .).parent
    while ($checkIn -ne $NULL) {
        $pathToTest = $checkIn.fullname + '/.git'
        if ((Test-Path $pathToTest) -eq $TRUE) {
            return $TRUE
        } else {
            $checkIn = $checkIn.parent
        }
    }
    
    return $FALSE
}

# Get the current branch
function gitBranchName {
    $currentBranch = ''
    git branch | foreach {
        if ($_ -match "^\* (.*)") {
            $currentBranch += $matches[1]
        }
    }
    return $currentBranch
}

# Extracts status details about the repo
function gitStatus {
    $untracked = $FALSE
    $added = 0
    $modified = 0
    $deleted = 0
    $ahead = $FALSE
    $aheadCount = 0
    
    $output = git status
    
    $branchbits = $output[0].Split(' ')
    $branch = $branchbits[$branchbits.length - 1]
    
    $output | foreach {
        if ($_ -match "^\#.*origin/.*' by (\d+) commit.*") {
            $aheadCount = $matches[1]
            $ahead = $TRUE
        }
        elseif ($_ -match "deleted:") {
            $deleted += 1
        }
        elseif (($_ -match "modified:") -or ($_ -match "renamed:")) {
            $modified += 1
        }
        elseif ($_ -match "new file:") {
            $added += 1
        }
        elseif ($_ -match "Untracked files:") {
            $untracked = $TRUE
        }
    }
    
    return @{"untracked" = $untracked;
             "added" = $added;
             "modified" = $modified;
             "deleted" = $deleted;
             "ahead" = $ahead;
             "aheadCount" = $aheadCount;
             "branch" = $branch}
}
#}}}
# Prompt Functions {{{
function prompt {
    Write-Host ("+ " + $(get-location)) -foregroundcolor Yellow
    currentdir
    
    if (isCurrentDirectoryGitRepository) {
        $status = gitStatus
        $currentBranch = $status["branch"]
        
        Write-Host('[') -nonewline -foregroundcolor Yellow
        if ($status["ahead"] -eq $FALSE) {
            # We are not ahead of origin
            Write-Host($currentBranch) -nonewline -foregroundcolor Cyan
        } else {
            # We are ahead of origin
            Write-Host($currentBranch) -nonewline -foregroundcolor Red
        }
        Write-Host(' +' + $status["added"]) -nonewline -foregroundcolor Yellow
        Write-Host(' ~' + $status["modified"]) -nonewline -foregroundcolor Yellow
        Write-Host(' -' + $status["deleted"]) -nonewline -foregroundcolor Yellow
        
        if ($status["untracked"] -ne $FALSE) {
            Write-Host(' !') -nonewline -foregroundcolor Yellow
        }
        
        Write-Host(']') -nonewline -foregroundcolor Yellow 
    }
    
	Write-Host('$') -nonewline -foregroundcolor Green    
	return " "
}
#}}}
# Source Private Profile {{{
if (test-Path $PROFILE2){
    & $PROFILE2
}
#}}}
