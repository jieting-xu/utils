Start-Transcript -OutputDirectory $PSScriptRoot -NoClobber
Write-Host "This script is needed to run as administrator!" -ForegroundColor Magenta

$modules = Get-InstalledModule
foreach ($mod in $modules) {
    $modName = $mod.Name
    Write-Host "Checking $modName" -BackgroundColor DarkCyan
    $latest = Get-InstalledModule $modName
    $versions = Get-InstalledModule $modName -AllVersions
    $verCount = $versions.Count
    if ($null -eq $verCount) {
        Write-Host "Found 1 version(s) of module [$modName $($latest.Version)]"
    }
    else {
        Write-Host "Found $verCount version(s) of module [$modName]"
        foreach ($ver in $versions) {
            if ($ver.Version -ne $latest.Version) {
                Write-Host ">>Uninstalling $($ver.Name) ver: $($ver.Version) / Latest ver: $($latest.version)"
                $ver | Uninstall-Module -Force
                Write-Host "<<Done uninstall [$($ver.Name) - $($ver.Version)]"
                Write-Output "----------"
            }            
        }
    }   
}

Stop-Transcript -Verbose

#---------------------------------------
# ERROR HANDLING
#---------------------------------------
trap
{
    $_.Exception
    Exit 1001
}