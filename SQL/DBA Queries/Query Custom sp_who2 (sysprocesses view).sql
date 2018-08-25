/**************************************************************************
** CREATED BY:   Mick Letofsky
** CREATED DATE: 2018.08.25
** CREATION:     Custom queries against the sysprocesses view
**************************************************************************/

--****************************************************
-- Retrieve all of the spid's on the user databases
--****************************************************
SELECT  sp.spid
       ,sp.blocked
       ,DB_NAME(sp.dbid) databasename
       ,sp.status
       ,sp.hostname
       ,sp.program_name
       ,sp.cmd
       ,sp.loginame
       ,sp.last_batch
       ,sp.waittime
       ,sp.lastwaittype
       ,sp.cpu
       ,sp.physical_io
FROM    master.dbo.sysprocesses sp
WHERE   DB_NAME(sp.dbid) NOT IN ('master','msdb','model')
ORDER BY sp.spid;
GO



--****************************************************
-- Retrieve all of the blocking on the user databases
--	and who is doing the blocking.
--****************************************************
SELECT	Blockee.spid,
		Blockee.blocked,
		DB_NAME(Blockee.dbid) DatabaseName,
		Blockee.status,
		Blockee.hostname,
		Blockee.program_name,
		Blockee.cmd,
		Blockee.loginame,
		Blocker.spid,
		Blocker.blocked,
		DB_NAME(Blocker.dbid) DatabaseName,
		Blocker.status,
		Blocker.hostname,
		Blocker.program_name,
		Blocker.cmd,
		Blocker.loginame
		
FROM	master.dbo.sysprocesses Blockee WITH(NOLOCK)
		INNER JOIN master.dbo.sysprocesses Blocker WITH(NOLOCK) ON Blockee.blocked = Blocker.spid

WHERE	DB_NAME(Blocker.dbid) NOT IN ('master', 'msdb', 'model')
ORDER BY Blockee.spid, Blocker.spid

GO
--****************************************************
-- Retrieve all of the active spid's on webiz
--****************************************************
SELECT	SP.spid,
		SP.blocked,
		DB_NAME(SP.dbid) DatabaseName,
		SP.status,
		SP.hostname,
		SP.program_name,
		SP.cmd,
		SP.loginame,
		SP.last_batch
FROM	master.dbo.sysprocesses SP
WHERE	DB_NAME(SP.dbid) LIKE 'webiz_%'
ORDER BY DatabaseName

GO

--****************************************************
-- Retrieve all of the active spid's with specific application name 
--****************************************************
SELECT	SP.spid,
		SP.blocked,
		DB_NAME(SP.dbid) DatabaseName,
		SP.status,
		SP.hostname,
		SP.program_name,
		SP.cmd,
		SP.loginame,
		SP.last_batch
FROM	master.dbo.sysprocesses SP
WHERE	SP.program_name LIKE '%TFS%'
ORDER BY sp.last_batch DESC 

GO

--****************************************************
-- Retrieve all of the active spid's on webiz
--****************************************************
SELECT	SP.spid,
		SP.blocked,
		DB_NAME(SP.dbid) DatabaseName,
		SP.status,
		SP.hostname,
		SP.program_name,
		SP.cmd,
		SP.loginame,
		SP.last_batch
FROM	master.dbo.sysprocesses SP
WHERE	DB_NAME(SP.dbid) LIKE 'webiz%'
		AND sp.program_name NOT LIKE '%Microsoft SQL Server Management Studio%'
		AND sp.program_name = 'WebIZ vCurrent API'
ORDER BY sp.last_batch DESC 

GO

--****************************************************
-- Retrieve all of the active spid's on webiz
--****************************************************
SELECT	SP.spid,
		SP.blocked,
		DB_NAME(SP.dbid) DatabaseName,
		SP.status,
		SP.hostname,
		SP.program_name,
		SP.cmd,
		SP.loginame,
		SP.last_batch
FROM	master.dbo.sysprocesses SP
WHERE	DB_NAME(SP.dbid) LIKE ('webiz%')
ORDER BY SP.spid

GO

--******************************************************************
-- Retrieve all of the spid's on the user databases that are active
--******************************************************************
SELECT	SP.spid,
		SP.blocked,
		DB_NAME(SP.dbid) DatabaseName,
		SP.status,
		SP.hostname,
		SP.program_name,
		SP.cmd,
		SP.loginame
,sp.*		
FROM	master.dbo.sysprocesses SP
WHERE	DB_NAME(SP.dbid) NOT IN ('master', 'msdb', 'model')
		AND SP.CMD <> 'AWAITING COMMAND'
ORDER BY SP.spid

GO

--****************************************************
-- Retrieve all of the spid's on the user databases
--****************************************************
SELECT	DB_NAME(SP.dbid) DatabaseName,
		SP.program_name ProgramName,
		COUNT(*) AS Tally
		
FROM	master.dbo.sysprocesses SP
WHERE	DB_NAME(SP.dbid) NOT IN ('master', 'msdb', 'model')
GROUP BY DB_NAME(SP.dbid), sp.program_name
ORDER BY TALLY DESC

GO

--****************************************************************
-- Retrieve all of the connection protocols on the user databases
--	Used to help determine whether NTLM or Kerberos authentication
--	is being employed to connect to SQL.
--****************************************************************
SELECT	SP.spid SessionID,
		SP.loginame,
		SP.hostname,
		DB_NAME(SP.dbid) DatabaseName,
		SP.program_name ProgramName,
		SP.status,		
		conn.auth_scheme AuthenticationScheme,
		conn.net_transport PhysicalTransportProtocol
FROM	master.dbo.sysprocesses SP
		INNER JOIN sys.dm_exec_connections Conn on SP.spid = Conn.session_id
WHERE	DB_NAME(SP.dbid) NOT IN ('master', 'msdb', 'model')
ORDER BY DatabaseName ASC, SessionID ASC		

GO

--****************************************************************
-- Retrieve all of the connection protocols on the user databases
--	Used to help determine whether NTLM or Kerberos authentication
--	is being employed to connect to SQL.
--****************************************************************
SELECT	SP.spid SessionID,
		SP.loginame,
		SP.hostname,
		DB_NAME(SP.dbid) DatabaseName,
		SP.program_name ProgramName,
		SP.status,		
		conn.auth_scheme AuthenticationScheme,
		conn.net_transport PhysicalTransportProtocol
FROM	master.dbo.sysprocesses SP
		INNER JOIN sys.dm_exec_connections Conn on SP.spid = Conn.session_id
WHERE	DB_NAME(SP.dbid) LIKE 'Share%'
ORDER BY DatabaseName ASC, SessionID ASC		

GO




--****************************************************
-- Retrieve all of the spid's on the user databases
--****************************************************
SELECT	SP.spid,
		SP.blocked,
		DB_NAME(SP.dbid) DatabaseName,
		SP.status,
		SP.hostname,
		SP.program_name,
		SP.cmd,
		SP.loginame,
		SP.last_batch
FROM	master.dbo.sysprocesses SP
WHERE	DB_NAME(SP.dbid) NOT IN ('master', 'msdb', 'model')
ORDER BY SP.spid
GO


GO



SELECT  ar.replica_server_name
       ,adc.database_name
       ,ag.name AS ag_name
       ,drs.is_local
       ,drs.is_primary_replica
       ,drs.synchronization_state_desc
       ,drs.is_commit_participant
       ,drs.synchronization_health_desc
       ,drs.recovery_lsn
       ,drs.truncation_lsn
       ,drs.last_sent_lsn
       ,drs.last_sent_time
       ,drs.last_received_lsn
       ,drs.last_received_time
       ,drs.last_hardened_lsn
       ,drs.last_hardened_time
       ,drs.last_redone_lsn
       ,drs.last_redone_time
       ,drs.log_send_queue_size
       ,drs.log_send_rate
       ,drs.redo_queue_size
       ,drs.redo_rate
       ,drs.filestream_send_rate
       ,drs.end_of_log_lsn
       ,drs.last_commit_lsn
       ,drs.last_commit_time
FROM    sys.dm_hadr_database_replica_states AS drs
        INNER JOIN sys.availability_databases_cluster AS adc ON drs.group_id = adc.group_id
                                                                AND drs.group_database_id = adc.group_database_id
        INNER JOIN sys.availability_groups AS ag ON ag.group_id = drs.group_id
        INNER JOIN sys.availability_replicas AS ar ON drs.group_id = ar.group_id
                                                      AND drs.replica_id = ar.replica_id
ORDER BY ag.name
       ,ar.replica_server_name
       ,adc.database_name;