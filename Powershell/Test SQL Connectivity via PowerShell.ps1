<##############################################################################
 Created By:   Mick Letofsky
 Create Date:  2018.08.15
 Creation:     Script to test connectivity to SQL Server
##############################################################################>

$conn = New-Object System.Data.SqlClient.SqlConnection
$Conn.ConnectionString = 'Database=WideWorldImporters; Server=Mick; Integrated Security=SSPI;  Application Name = PowerShell Testing;'
$conn.Open()
$cmd.connection = $conn
$cmd.CommandText = "SELECT Count(*) FROM SYS.TABLES"
$cmd.CommandTimeout = 600
$cmd.ExecuteReader();
$conn.Close();

$conn = New-Object System.Data.SqlClient.SqlConnection
$connAG = New-Object System.Data.SqlClient.SqlConnection
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd2 = New-Object System.Data.SqlClient.SqlCommand
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter2 = New-Object System.Data.SqlClient.SqlDataAdapter
$DataSet = New-Object System.Data.DataSet
$DataSet2 = New-Object System.Data.DataSet

$conn.ConnectionString = 'Database=WideWorldImporters; Server=Mick; Integrated Security=SSPI;  Application Name = PowerShell Testing; MultiSubnetFailover=Yes'
$conn.Open()
$cmd.connection = $conn
$cmd.CommandText = "select count(*) from sales.Orders"
$cmd.CommandTimeout = 0
$SqlAdapter.SelectCommand = $cmd
$SqlAdapter.Fill($DataSet)
$connAG.Close()
$DataSet.Tables[0]

$connAG.ConnectionString = 'Database=WideWorldImporters; Server=Mick; Integrated Security=SSPI;  Application Name = PowerShell Testing; ConnectRetryCount= 5; ConnectRetryInterval = 4; Connection Timeout= 120; MultiSubnetFailover=True;'
$connAG.Open()
$cmd2.connection = $connAG
$cmd2.CommandText = "select count(*) from sales.OrderLines"
$cmd2.CommandTimeout = 0
$SqlAdapter2.SelectCommand = $cmd2
$SqlAdapter2.Fill($DataSet2)
$connAG.Close()
$DataSet2.Tables[0]