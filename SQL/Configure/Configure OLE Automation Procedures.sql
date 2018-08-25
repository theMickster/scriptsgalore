/**************************************************************************************
** CREATED BY:   Mick Letofsky
** CREATED DATE: 2018.08.21
** CREATION:     Quick script to get a comma separated list of data. 
**************************************************************************************/

SET ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, NOCOUNT ON;

USE master;
EXECUTE sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXECUTE sp_configure 'Ole Automation Procedures', 1;
GO
RECONFIGURE;
GO
