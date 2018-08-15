<##############################################################################
 Created By:   Mick Letofsky
 Create Date:  2018.08.15
 Creation:     Script to install TrendMicro on remote PC
##############################################################################>

Invoke-Command -ComputerName AzureRemote01 -ScriptBlock { Start-Process "C:\ProgramData\WFBS-SVC_Agent_Installer.msi" -wait}
Invoke-Command -ComputerName AzureRemote02 -ScriptBlock { Start-Process "C:\ProgramData\WFBS-SVC_Agent_Installer.msi" -wait}
Invoke-Command -ComputerName AzureRemote03 -ScriptBlock { Start-Process "C:\ProgramData\WFBS-SVC_Agent_Installer.msi" -wait}


