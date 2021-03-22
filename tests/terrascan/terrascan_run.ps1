<# 
.SYNOPSIS Find Terraform files in a directory tree and run Terrascan on them, outputting junit XML
.DESCRIPTION

This short script looks for Terraform files in a given directory tree, and runs Terraform on each one of them to generate a unique output file
It then stores the output files in the specified output location for Azure Pipelines to pick up as Test Results

#>

param (
    [Parameter(Mandatory = $true)] [string]$tffilesroot,         # the directory tree that we want to scan for .tf files - where is it's root? (do not end with \)
    [Parameter(Mandatory = $true)] [string]$tffilenamecommon,    # the .tf filename we want to scan for, e.g. main.tf (no wildcards)
    [Parameter(Mandatory = $true)] [string]$outputpath           # the location that Terrascan should output junit XML files into (do not end with \)
)

# get all .tf files that match the specified filename
$tffiles = get-childitem -path $tffilesroot -filter $tffilenamecommon -recurse 
foreach ($tffile in $tffiles)
{
# for each one of them, get the unique part of the path, since we will use that in the junit XML file name
# this could be changed to scan each file's contents for some unique token or comment and then use that instead    
# to get the unique part of the path, we remove the directory tree root and any \src subdirectory names
    $tffilefullname = $tffile.FullName.ToLower()
    $tffilesubpath = $tffile.DirectoryName.ToLower().Replace($tffilesroot.ToLower(), "")
    $tffilesubpath = $tffilesubpath.Replace("\src", "")
    $tffilesubpath = $tffilesubpath.TrimStart("\").TrimEnd("\")
    $tffilesubpath = $tffilesubpath.Replace("\", "-")

# now we run Terrascan (assumed to be in the PATH) with our desired options (could be put in config file), and capture the junit XML that goes to stdio
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

# now write out some diags to prove that the process ran
    Write-Output "PROCESS"
    Write-Output $process.StartInfo

    $tsoutput = $process.StandardOutput.ReadToEnd()
    $tserror = $process.StandardError.ReadToEnd()

    Write-Output "OUTPUT"
    Write-Output $tsoutput
    
    Write-Output "ERROR"
    Write-Output $tserror

# now write out the stdio output that we collected, using the custom filename, to the output dir
    set-content "$outputpath\test-$tffilesubpath-report.xml" $tsoutput

}
