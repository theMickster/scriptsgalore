/**************************************************************************
** CREATED BY:   Mick Letofsky
** CREATED DATE: 2018.08.25
** CREATION:     Quick script to assist with backup and restoring certificates
**************************************************************************/

/************************************************************************************
Step 1: 
Create a master key in the master database for SQL Certificates on XXXXX
Create a new certificate.
************************************************************************************/
USE MASTER  
GO  
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'CREATE FIRST UNIQUE PASSWORD HERE' 
GO 
CREATE CERTIFICATE MY_TDE_Certificate WITH SUBJECT = 'My TDE Certificate', EXPIRY_DATE = '01-01-2025';
/*****************************************************************************************************
Step 2: 
Create a backup of the certificate. Must be to a local file (e.g. T:\SQL_Backups)
*****************************************************************************************************/
USE MASTER  
GO  
BACKUP CERTIFICATE MY_TDE_Certificate
TO FILE = 'T:\SQL_Backups\MY_TDE_Certificate_20180825.cer'  
WITH PRIVATE KEY (FILE = 'T:\SQL_Backups\MY_TDE_Certificate_20180825_Key.pvk' 
	, ENCRYPTION BY PASSWORD = 'CREATE SECOND UNIQUE PASSWORD HERE'  ) 
GO
/*********************************************************************************
Step 3: 
Copy the certificate backup files to a drive off server (SAN, NAS, Azure, etc).
*********************************************************************************/

/*********************************************************************************
Step 4: 
Import the certificate on another servers
*********************************************************************************/
USE MASTER  
GO
CREATE CERTIFICATE MY_TDE_Certificate  
FROM FILE = 'B:\SQL_Backups\MY_TDE_Certificate_20180825.cer'   
WITH PRIVATE KEY (FILE = 'B:\SQL_Backups\MY_TDE_Certificate_20180825_Key.pvk', 
					DECRYPTION BY PASSWORD =  'CREATE SECOND UNIQUE PASSWORD HERE' );
