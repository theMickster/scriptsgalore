<##############################################################################
 Created By:   Mick Letofsky
 Create Date:  2018.08.15
 Creation:     Upload custom TFS build & release task (TFS 2017)
##############################################################################>
cd E:\Temp\TFSExtensions
clear
$credential = Get-Credential
.\CreateAndUploadTFSTask.ps1 -TaskPath 'E:\Temp\TFSExtensions\InvokeSQLCMD'  -Credential $credential

cd E:\Temp\TFSExtensions
clear
$credential = Get-Credential
.\CreateAndUploadTFSTask.ps1 -TaskPath 'E:\Temp\TFSExtensions\SQLBackupDatabase'  -Credential $credential

cd E:\Temp\TFSExtensions
clear
$credential = Get-Credential
.\CreateAndUploadTFSTask.ps1 -TaskPath 'E:\Temp\TFSExtensions\Upload2AzureFileStorage'  -Credential $credential

