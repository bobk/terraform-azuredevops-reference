<# 
.SYNOPSIS Find Terraform files under a directory location and run Terrascan on them
.DESCRIPTION 
#>

param (
    [Parameter(Mandatory = $true)] [string]$tffilesroot,
    [Parameter(Mandatory = $true)] [string]$tffilenamecommon,
    [Parameter(Mandatory = $true)] [string]$outputpath
)

$tffiles = get-childitem -path $tffilesroot -filter $tffilenamecommon -recurse 
foreach ($tffile in $tffiles)
{
    $tffilefullname = $tffile.FullName.ToLower()
    $tffilesubpath = $tffile.DirectoryName.ToLower().Replace($tffilesroot.ToLower(), "")
    $tffilesubpath = $tffilesubpath.Replace("\src", "")
    $tffilesubpath = $tffilesubpath.TrimStart("\").TrimEnd("\")
    $tffilesubpath = $tffilesubpath.Replace("\", "-")

    $tsexename = "terrascan.exe"
    $tsexeargs = "scan -f `"$tffilefullname`" -i terraform -t azure -o junit-xml --use-colors f"
    
    $process = new-object System.Diagnostics.Process
    $process.StartInfo.FileName = $tsexename
    $process.StartInfo.Arguments = $tsexeargs
    $process.StartInfo.RedirectStandardOutput = $true
    $process.StartInfo.RedirectStandardError = $true
    $process.StartInfo.UseShellExecute = $false
    $process.start() | Out-Null
    $process.WaitForExit()

    Write-Output "PROCESS"
    Write-Output $process.StartInfo

    $tsoutput = $process.StandardOutput.ReadToEnd()
    $tserror = $process.StandardError.ReadToEnd()

    Write-Output "OUTPUT"
    Write-Output $tsoutput
    
    Write-Output "ERROR"
    Write-Output $tserror

    set-content "$outputpath\test-$tffilesubpath-report.xml" $tsoutput

}
