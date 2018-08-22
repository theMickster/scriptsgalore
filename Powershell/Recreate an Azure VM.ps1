<##############################################################################
 Created By:   Mick Letofsky
 Create Date:  2018.08.15
 Creation:     Script to recreate an Azure VM
##############################################################################>


<####################################################
Connect to the proper Azure Subscription
####################################################>
Login-AzureRmAccount -EnvironmentName AzureUSGovernment
Select-AzureRmSubscription '%SUBSCRIPTION_NAME_HERE%'
Get-AzureSubscription -Current


# Set variables
    $resourceGroup = "MickSQLServers"
    $vmName = "MickSQLProd04"
    $newAvailSetName = "MickSQLProdAG01"

$availSet = Get-AzureRmAvailabilitySet -ResourceGroupName $resourceGroup -Name $newAvailSetName       -ErrorAction Ignore
$MickSQL04 = New-AzureRmVMConfig -VMName 'MickSQL04' -VMSize 'Standard_D13_v2_Promo' -AvailabilitySetId $availSet1.Id

Set-AzureRmVMOSDisk -Name 'MickSQL04_OS'  -VM $MickSQL04 -CreateOption Attach  -Windows -VhdUri 'https://micksqlprod.blob.core.usgovcloudapi.net/vhds/MickSQL0420180221131939.vhd'

Add-AzureRmVMDataDisk -VM $MickSQL04 -Name 'MickSQL04-disk-01' -Caching $disk.Caching -Lun 0 -DiskSizeInGB 1023 -CreateOption Attach -VhdUri 'https://micksqlprod.blob.core.usgovcloudapi.net/vhds/MickSQL04-disk-1-20180221131939.vhd'
Add-AzureRmVMDataDisk -VM $MickSQL04 -Name 'MickSQL04-disk-02' -Caching $disk.Caching -Lun 1 -DiskSizeInGB 1280 -CreateOption Attach -VhdUri 'https://micksqlprod.blob.core.usgovcloudapi.net/vhds/MickSQL04-disk-2.vhd'


foreach ($nic in $originalVM.NetworkProfile.NetworkInterfaces) 
{
    Add-AzureRmVMNetworkInterface -VM $MickSQL04 -Id $nic.Id
}

New-AzureRmVM -ResourceGroupName $resourceGroup -Location $originalVM.Location -VM $MickSQL04 -DisableBginfoExtension -Verbose


