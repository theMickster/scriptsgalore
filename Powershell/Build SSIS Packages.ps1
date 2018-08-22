<##############################################################################
 Created By:   Mick Letofsky
 Create Date:  2018.08.15
 Creation:     Script to build SSIS Packages using PowerShell
##############################################################################>

Import-Module PSCI
Import-Module VstsTaskSdk

clear 
Set-Culture 'en-us'
$VisualStudioLocation = Get-VisualStudioPath -VisualStudioVersion '2012'
$VisualStudioLocation = "$VisualStudioLocation\Common7\IDE\devenv.com"
$version = '1.0'
$solutionFile = "E:\temp\BaseballStats\$version\SSIS\BaseballStats.Datamart.sln"
$buildType = '/build'
$buildConfiguration = 'Release'
$argsList = $solutionFile + " " + $buildType + " " + $buildConfiguration
$result = Invoke-VstsTool -FileName $VisualStudioLocation -Arguments  $argsList 
$arr_result =  $result -split "\r\n"
foreach ($line in $arr_result)
{
    Write $line
}
if($arr_result[-1].Contains("0 succeeded or up-to-date"))
{
    Write-Error "Zero build success means that an error occured. Please look at the build report for the build: $env:BUILD_BUILDNUMBER."
}


