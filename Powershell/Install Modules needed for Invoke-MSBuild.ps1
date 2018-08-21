<##############################################################################
 Created By:   Mick Letofsky
 Create Date:  2018.08.15
 Creation:     Install tools necessary for calling MSBuild from Powershell
##############################################################################>
 
Install-Module -Name Invoke-MsBuild -force -AllowClobber
Install-Module -Name PSCI -AllowClobber
Install-Module -Name VstsTaskSdk -AllowClobber
