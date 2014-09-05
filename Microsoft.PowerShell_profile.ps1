# General variables {{{
if ($env:COMPUTERNAME -eq 'shiju' -or $env:COMPUTERNAME -eq 'medusa' -or $env:COMPUTERNAME -eq 'pcshiju' ){
    set-variable work "D:\Work" 
}else{
    set-variable work "C:\Work" 
}

set-variable TOOLS "$work\tools"
set-variable PROJECTS "$work\projects" 
set-variable PROFILE "$work\projects\config\Microsoft.PowerShell_profile.ps1" 
set-variable PROFILE2 "$work\projects\config\Private.PS_Profile.ps1" 
set-variable MYVIMRC "$work\projects\config\_vimrc" 

set-variable JUNK "$work\junk" 
set-variable POSHSQL "$work\projects\programming\powershell\poshsql"
set-variable PS "$work\projects\programming\powershell\"
set-variable CONFIG "$work\projects\config"
set-variable VIM "$tools\vim\vim73\gvim.exe"
set-variable HOSTS "C:\Windows\System32\Drivers\etc\hosts"
Write-Host "Setting environment for $computerName" -foregroundcolor cyan


#$sw = @'
#[DllImport("user32.dll")]
#public static extern int ShowWindow(int hwnd, int nCmdShow);
#'@

#$type = Add-Type -Name ShowWindow2 -MemberDefinition $sw -Language CSharpVersion3 -Namespace Utils -PassThru

#}}}
# Environment variables {{{
# This is for C compiler
#$env:INCLUDE = "c:\Work\tools\PellesC\Include"
#$env:LIB = "c:\Work\tools\PellesC\LIB;c:\Work\tools\PellesC\LIB\win"
#}}}
# Dashboard Display {{{
# Display if we have entry in the host file
gc $hosts | ? {$_ -notlike '#*' -and $_.ToString().Trim() -ne ""} | % {write-host $_ -foregroundColor magenta}
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
new-item alias:vi -value "$tools\vim\vim73\gvim.exe"
new-item alias:pixie -value "D:\Work\tools\pixie\pixie.exe"
new-item alias:vim -value "$tools\vim\vim73\vim.exe"
new-item alias:ediff -value "$tools\examdiff.exe"
new-item alias:ex -value "explorer.exe"
new-item alias:wm -value "$tools\winmerge\winmergeu.exe"
new-item alias:vs -value "C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe"
new-item alias:wcf -value "C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\IDE\wcftestclient.exe"
new-item alias:excel -value "C:\Program Files\Microsoft Office 15\root\office15\excel.exe"
new-item alias:winword -value "C:\Program Files\Microsoft Office 15\root\office15\winword.exe"
#For explorer to work in a sepearate process below registry value should be set to 1
#This makes sure the process starts with a current
#HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\advanced\SeparateProcess 
#}}}
# Functions {{{
#Set-ExecutionPolicy remotesigned
<#
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
#>

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
cd $projects
import-module D:\Work\projects\programming\powershell\wmi\wmiquery.psm1 
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

function elevate-process
{
    $file, [string]$arguments = $args;
    $psi = new-object System.Diagnostics.ProcessStartInfo $file;
    $psi.Arguments = $arguments;
    $psi.Verb = "runas";
    $psi.WorkingDirectory = get-location;
    [System.Diagnostics.Process]::Start($psi);
} 
set-alias sudo elevate-process;

function edit-host {
    SUDO $VIM $HOSTS
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
    if ($(get-location).path  -like 'c:*' -or $(get-location).path  -like 'd:*'){
        Write-Host ("+ " + $(get-location)) -foregroundcolor Yellow
    }else {
        Write-Host ("+ " + $(get-location)) -foregroundcolor Red
    }

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
# Directory Bookmarks Functions {{{
$marks = @{};

#$marksPath = Join-Path (split-path -parent $profile) .bookmarks
$marksPath = "$PROJECTS\programming\powershell\data\bookmarks.txt"

if(test-path $marksPath){
import-csv $marksPath | %{$marks[$_.key]=$_.value}
}

function mset($number){
$marks["$number"] = (pwd).path
}

function mg($number){
cd $marks["$number"]
}

function mdump{
$marks.getenumerator() | export-csv $marksPath -notype
}

function mls{
$marks
}
#}}}
# Authentication Bookmarks Functions {{{
$AuthData = @{};

#$AuthPath = Join-Path (split-path -parent $profile) .bookmarks
$AuthPath = "$PROJECTS\programming\powershell\data\authinfo.txt"

if(test-path $AuthPath ){
import-csv $AuthPath | %{$AuthData[$_.key]=$_.value}
}

function set-ad($user,$password){
$AuthData["$user"] = $password 
dumpauthdata
}

function get-ad($user){
cd $AuthData["$user"]
}

function dumpauthdata{
$AuthData.getenumerator() | export-csv $authpath -notype
}

function lad{
$AuthData
}
#}}}
# Speak Line function {{{
function speak-line($line){
    (New-Object -ComObject SAPI.SPVoice).Speak($line) | Out-Null
}
#}}}
