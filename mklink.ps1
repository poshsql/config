# Check variables {{{
if (!(test-path variable:global:work)){ write-host '$work not set aborting' -fore red; return; }
if (!(test-path variable:global:tools)){ write-host '$tools not set aborting' -fore red; return; }
if (!(test-path variable:global:projects)){ write-host '$projects not set aborting' -fore red; return; }
#}}}
#Vim colors {{{
if (!(test-path $tools\vim\bin\colors)){
    $cmd = "cmd /c 'mklink /D $tools\vim\bin\colors\' '$projects\config\colors\'" 
    invoke-expression $cmd 
}else {
    write-host "vim colors is already mapped" -fore cyan
}
#}}}
#Vim bundle (pathogen) {{{
if (!(test-path $tools\vim\bin\bundle)){
    $cmd = "cmd /c 'mklink /D $tools\vim\bin\bundle\' '$projects\config\bundle\'" 
    invoke-expression $cmd 
}else {
    write-host "vim bundle is already mapped" -fore cyan
}
#}}}
#Vim vimrc  {{{
if (!(test-path $tools\vim\_vimrc)){
    $cmd = "cmd /c 'mklink $tools\vim\_vimrc' '$projects\config\_vimrc'" 
    invoke-expression $cmd 
}else {
    write-host "vim vimrc is already mapped" -fore cyan
}
#}}}
#Vim executesql  {{{
if (!(test-path $tools\vim\executesql.vim)){
    $cmd = "cmd /c 'mklink $tools\vim\executesql.vim' '$projects\config\executesql.vim'" 
    invoke-expression $cmd 
}else {
    write-host "vim executesql is already mapped" -fore cyan
}
#}}}
#Powershell Profile {{{
if (!(test-path $profile)){
    $cmd = "cmd /c 'mklink $Profile' '$projects\config\Microsoft.PowerShell_profile.ps1'" 
    invoke-expression $cmd 
}else {
    write-host "Powershell Profile is already mapped" -fore cyan
}
#}}}
#Console2 {{{
if (!(test-path $tools\console2\console.xml)){
    $cmd = "cmd /c 'mklink $tools\console2\console.xml' '$projects\config\console.xml'" 
    invoke-expression $cmd 
}else {
    write-host "console2 is already mapped" -fore cyan
}
#}}}
# System gitconfig   {{{
if (!(test-path $tools\git\etc\gitconfig)){
    $cmd = "cmd /c 'mklink $tools\git\etc\gitconfig' '$projects\config\gitconfig'" 
    invoke-expression $cmd 
}else {
    write-host "console2 is already mapped" -fore cyan
}
#}}}
# PoshSql mapping to module {{{
$modulepath =  (($env:PSModulePath).split(";")[0])
if (!(test-path $modulepath\PoshSql)){
    $cmd = "cmd /c 'mklink /D $modulepath\poshsql\' '$projects\PoshSql\'" 
    invoke-expression $cmd 
}else {
    write-host "PoshSql is already mapped" -fore cyan
}
#}}}
