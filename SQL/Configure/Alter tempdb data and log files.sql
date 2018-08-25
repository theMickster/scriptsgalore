/**************************************************************************
** CREATED BY:   Mick Letofsky
** CREATED DATE: 2018.08.25
** CREATION:     Move and adjust SQL tempdb
**************************************************************************/

USE MASTER;
GO
ALTER DATABASE tempdb MODIFY FILE (NAME= tempdev, FILENAME= 'D:\tempdb.mdf', SIZE = 16GB) 
GO
ALTER DATABASE tempdb MODIFY FILE (name = templog, filename = 'D:\templog.ldf', SIZE = 16GB) 
GO
ALTER DATABASE tempdb MODIFY FILE (name = tempdev2, filename = 'D:\tempdev2.ndf', SIZE = 16GB) 
GO
ALTER DATABASE tempdb MODIFY FILE (name = tempdev3, filename = 'D:\tempdev3.ndf', SIZE = 16GB) 
GO
ALTER DATABASE tempdb MODIFY FILE (name = tempdev4, filename = 'D:\tempdev4.ndf', SIZE = 16GB) 
GO


ALTER DATABASE tempdb MODIFY FILE (NAME= tempdev, FILENAME= 'D:\tempdb.mdf', SIZE = 16GB) 
GO
ALTER DATABASE tempdb MODIFY FILE (name = templog, filename = 'D:\templog.ldf', SIZE = 16GB) 
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev2', FILENAME = N'D:\tempdev2.ndf' , SIZE = 16777216KB , FILEGROWTH = 10%)
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev3', FILENAME = N'D:\tempdev3.ndf' , SIZE = 16777216KB , FILEGROWTH = 10%)
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev4', FILENAME = N'D:\tempdev4.ndf' , SIZE = 16777216KB , FILEGROWTH = 10%)

