/**************************************************************************
** CREATED BY:   Mick Letofsky
** CREATED DATE: 2018.08.25
** CREATION:     Custom queries to find active transactions
**************************************************************************/

SELECT transaction_id
      ,database_id
	  ,DB_NAME(database_id) AS [database_name]
      ,database_transaction_begin_time
      ,database_transaction_type
      ,database_transaction_state
      ,database_transaction_status
      ,database_transaction_status2
      ,database_transaction_log_record_count
      ,database_transaction_replicate_record_count
      ,database_transaction_log_bytes_used
      ,database_transaction_log_bytes_reserved
      ,database_transaction_log_bytes_used_system
      ,database_transaction_log_bytes_reserved_system
      ,database_transaction_begin_lsn
      ,database_transaction_last_lsn
      ,database_transaction_most_recent_savepoint_lsn
      ,database_transaction_commit_lsn
      ,database_transaction_last_rollback_lsn
      ,database_transaction_next_undo_lsn
FROM sys.dm_tran_database_transactions


/*****************************************************
Additional Transaction level blocking querries
******************************************************/

SELECT DB_NAME(DT.database_id) As DBName,
	TranType = Case DT.database_transaction_type
		When 1 Then 'Read/write transaction'
		When 2 Then 'Read-only transaction'
		When 3 Then 'System transaction'
	End,
	TranState = Case database_transaction_state
		When 1 Then 'Transaction has not been initialized'
		When 3 Then 'Transaction has been initialized but has not generated any log records'
		When 4 Then 'Transaction has generated log records'
		When 5 Then 'Transaction has been prepared'
		When 10 Then 'Transaction has been committed'
		When 11 Then 'Transaction has been rolled back'
		When 12 Then 'Transaction is being committed. In this state the log record is being generated, but it has not been materialized or persisted'
	End,
	*
FROM sys.dm_tran_database_transactions DT
Left Join sys.dm_tran_session_transactions ST ON ST.transaction_id = DT.transaction_id
Left Join sys.dm_exec_sessions S On S.session_id = ST.session_id

/********************************************************************************
Which sessions are causing blocking and what statement are they running? 
*********************************************************************************/
SELECT  DTL.[request_session_id] AS [session_id]  ,
	        DB_NAME(DTL.[resource_database_id]) AS [Database]  ,
	        DTL.resource_type ,
	        CASE  WHEN DTL.resource_type  IN  ( 'DATABASE', 'FILE', 'METADATA' )
	             THEN DTL.resource_type
	             WHEN DTL.resource_type =  'OBJECT'
	             THEN  OBJECT_NAME(DTL.resource_associated_entity_id,
	                              DTL.[resource_database_id])
	             WHEN DTL.resource_type IN  ( 'KEY', 'PAGE', 'RID' )
	             THEN  (  SELECT  OBJECT_NAME([object_id])
	                    FROM    sys.partitions
	                    WHERE   sys.partitions.hobt_id = 
                                            DTL.resource_associated_entity_id
	                  )
	             ELSE  'Unidentified'
	        END  AS [Parent Object]  ,
	        DTL.request_mode AS [Lock Type]  ,
	        DTL.request_status AS [Request Status]  ,
	        DER.[blocking_session_id] ,
	        DES.[login_name]  ,
	        CASE DTL.request_lifetime
	          WHEN 0  THEN DEST_R.TEXT
	          ELSE DEST_C.TEXT
	        END  AS [Statement]
	FROM    sys.dm_tran_locks DTL
	        LEFT  JOIN  sys.[dm_exec_requests] DER
                   ON DTL.[request_session_id]  = DER.[session_id]
	        INNER  JOIN  sys.dm_exec_sessions  DES
                   ON DTL.request_session_id  =  DES.[session_id]
	        INNER  JOIN  sys.dm_exec_connections  DEC
                   ON DTL.[request_session_id]  =  DEC.[most_recent_session_id]
	        OUTER  APPLY  sys.dm_exec_sql_text(DEC.[most_recent_sql_handle])
                                                         AS DEST_C
	        OUTER  APPLY  sys.dm_exec_sql_text(DER.sql_handle) AS DEST_R
	WHERE   DTL.[resource_database_id] =  DB_ID()
	        AND DTL.[resource_type] NOT  IN  ( 'DATABASE', 'METADATA' )
	ORDER  BY DTL.[request_session_id]  ;



/************************************************************
Transaction log impact of active transactions. 
*************************************************************/
SELECT  DTST.session_id
       ,DES.login_name AS [Login Name]
       ,DB_NAME(DTDT.database_id) AS [Database]
       ,DTDT.database_transaction_begin_time AS [Begin Time]
       , 
 --  DATEDIFF(ms,DTDT.[database_transaction_begin_time],  GETDATE()) AS [Duration ms], 
        CASE DTAT.transaction_type
          WHEN 1 THEN 'Read/write'
          WHEN 2 THEN 'Read-only'
          WHEN 3 THEN 'System'
          WHEN 4 THEN 'Distributed'
        END AS [Transaction Type]
       ,CASE DTAT.transaction_state
          WHEN 0 THEN 'Not fully initialized'
          WHEN 1 THEN 'Initialized, not started'
          WHEN 2 THEN 'Active'
          WHEN 3 THEN 'Ended'
          WHEN 4 THEN 'Commit initiated'
          WHEN 5 THEN 'Prepared, awaiting resolution'
          WHEN 6 THEN 'Committed'
          WHEN 7 THEN 'Rolling back'
          WHEN 8 THEN 'Rolled back'
        END AS [Transaction State]
       ,DTDT.database_transaction_log_record_count AS [Log Records]
       ,DTDT.database_transaction_log_bytes_used AS [Log Bytes Used]
       ,DTDT.database_transaction_log_bytes_reserved AS [Log Bytes RSVPd]
       ,DEST.text AS [Last Transaction Text]
       ,DEQP.query_plan AS [Last Query Plan]
FROM    sys.dm_tran_database_transactions DTDT
        INNER JOIN sys.dm_tran_session_transactions DTST ON DTST.transaction_id = DTDT.transaction_id
        INNER JOIN sys.dm_tran_active_transactions DTAT ON DTST.transaction_id = DTAT.transaction_id
        INNER JOIN sys.dm_exec_sessions DES ON DES.session_id = DTST.session_id
        INNER JOIN sys.dm_exec_connections DEC ON DEC.session_id = DTST.session_id
        LEFT  JOIN sys.dm_exec_requests DER ON DER.session_id = DTST.session_id
        CROSS APPLY sys.dm_exec_sql_text(DEC.most_recent_sql_handle) AS DEST
        OUTER APPLY sys.dm_exec_query_plan(DER.plan_handle) AS DEQP
ORDER BY DTDT.database_transaction_log_bytes_used DESC;
	-- ORDER BY [Duration ms]  DESC;

