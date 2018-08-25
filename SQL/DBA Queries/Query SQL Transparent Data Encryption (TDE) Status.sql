/**************************************************************************
** CREATED BY:   Mick Letofsky
** CREATION:     Quick query to check status of database encryption
**************************************************************************/
SET ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, NOCOUNT ON;

SELECT	db.dbid
		,db.name AS database_name
	   ,enc.encryption_state	   
	   ,CASE COALESCE( enc.encryption_state, 0)
		  WHEN 0 THEN 'No database encryption key present, no encryption'
		  WHEN 1 THEN 'Unencrypted'
		  WHEN 2 THEN 'Encryption in progress'
		  WHEN 3 THEN 'Encrypted'
		  WHEN 4 THEN 'Key change in progress'
		  WHEN 5 THEN 'Decryption in progress'
		  WHEN 6 THEN 'Protection change in progress'
		END AS encryption_state_name
	   ,COALESCE( enc.percent_complete, 0.0) as percent_complete
	   ,enc.create_date
	   ,enc.regenerate_date
	   ,enc.modify_date
	   ,enc.set_date
	   ,enc.encryptor_thumbprint
	   ,sc.certificate_id
	   ,sc.name AS certificate_name
       ,sc.start_date AS certificate_start_date
	   ,sc.expiry_date AS certificate_expiry_date
       
FROM	sys.sysdatabases db
		LEFT OUTER JOIN sys.dm_database_encryption_keys enc ON db.dbid = enc.database_id
		LEFT OUTER JOIN sys.certificates sc ON enc.encryptor_thumbprint = sc.thumbprint
order by db.name ASC




