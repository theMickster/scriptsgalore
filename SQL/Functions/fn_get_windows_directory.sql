IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('dbo.fn_get_windows_directory') AND type in (N'FN', N'IF', N'FS', N'FT', N'TF'))
	DROP FUNCTION dbo.fn_get_windows_directory;
GO
CREATE FUNCTION dbo.fn_get_windows_directory
(
	@Wildcard VARCHAR(8000)
)
RETURNS @MyDir TABLE
(
	name VARCHAR(2000)
	,path VARCHAR(2000)
	,ModifyDate DATETIME
	,IsFileSystem INT
	,IsFolder INT
	,error VARCHAR(2000)
)
/***********************************************************************************
** CREATED BY:   Mick Letofsky
** CREATED DATE: 2018.08.21
** CREATED:      Function to retrieve the list of files in a Windows directory
***********************************************************************************/
AS
BEGIN
	DECLARE @objShellApplication	INT
		,@objFolder				INT
		,@objItem				INT
		,@objErrorObject		INT
		,@objFolderItems		INT
		,@strErrorMessage		VARCHAR(1000)
		,@Command				VARCHAR(1000)
		,@hr					INT
		,@count					INT
		,@ii					INT
		,@name					VARCHAR(2000)
		,@path					VARCHAR(2000)
		,@ModifyDate			DATETIME
		,@IsFileSystem			INT
		,@IsFolder				INT;

	IF LEN(COALESCE(@Wildcard, '')) < 2
		RETURN;

	SELECT	@strErrorMessage	= 'opening the Shell Application Object';
	EXECUTE @hr = sp_OACreate 'Shell.Application', @objShellApplication OUT;

	IF @hr = 0
		SELECT	@objErrorObject = @objShellApplication
			,@strErrorMessage = 'Getting Folder"' + @Wildcard + '"'
			,@Command		= 'NameSpace("' + @Wildcard + '")';
	IF @hr = 0
		EXECUTE @hr = sp_OAMethod @objShellApplication, @Command, @objFolder OUT;
	IF @objFolder IS NULL
		RETURN; 

	SELECT	@objErrorObject = @objFolder
		,@strErrorMessage = 'Getting count of Folder items in "' + @Wildcard + '"'
		,@Command		= 'Items.Count';
	IF @hr = 0
		EXECUTE @hr = sp_OAMethod @objFolder, @Command, @count OUT;
	IF @hr = 0  
		SELECT	@objErrorObject = @objFolder
			,@strErrorMessage = ' getting folderitems'
			,@Command		= 'items()';
	IF @hr = 0
		EXECUTE @hr = sp_OAMethod @objFolder, @Command, @objFolderItems OUTPUT;
	SELECT	@ii = 0;
	WHILE @hr = 0 AND @ii < @count
	BEGIN
		IF	@hr = 0
			SELECT	@objErrorObject = @objFolderItems
				,@strErrorMessage = ' getting folder item ' + CAST(@ii AS VARCHAR(5))
				,@Command		= 'item(' + CAST(@ii AS VARCHAR(5)) + ')';
		IF @hr = 0
			EXECUTE @hr = sp_OAMethod @objFolderItems, @Command, @objItem OUTPUT;

		IF @hr = 0
			SELECT	@objErrorObject = @objItem
				,@strErrorMessage = ' getting folder item properties' + CAST(@ii AS VARCHAR(5));
		IF @hr = 0
			EXECUTE @hr = sp_OAMethod @objItem, 'path', @path OUTPUT;
		IF @hr = 0
			EXECUTE @hr = sp_OAMethod @objItem, 'name', @name OUTPUT;
		IF @hr = 0
			EXECUTE @hr = sp_OAMethod @objItem, 'ModifyDate', @ModifyDate OUTPUT;
		IF @hr = 0
			EXECUTE @hr = sp_OAMethod @objItem, 'IsFileSystem', @IsFileSystem OUTPUT;
		IF @hr = 0
			EXECUTE @hr = sp_OAMethod @objItem, 'IsFolder', @IsFolder OUTPUT;

		INSERT INTO @MyDir
		(
			name
			,path
			,ModifyDate
			,IsFileSystem
			,IsFolder
		)
		SELECT	@name
				,@path
				,@ModifyDate
				,@IsFileSystem
				,@IsFolder;
		IF @hr = 0
			EXECUTE sp_OADestroy @objItem;
		SELECT	@ii = @ii + 1;
	END;
	IF @hr <> 0
	BEGIN
		DECLARE @Source		VARCHAR(255)
			,@Description VARCHAR(255)
			,@Helpfile	VARCHAR(255)
			,@HelpID	INT;

		EXECUTE sp_OAGetErrorInfo @objErrorObject
								,@Source OUTPUT
								,@Description OUTPUT
								,@Helpfile OUTPUT
								,@HelpID OUTPUT;
		SELECT	@strErrorMessage	= 'Error whilst ' + COALESCE(@strErrorMessage, 'doing something') + ', ' + COALESCE(@Description, '');
		INSERT INTO @MyDir
		(
			error
		)
					SELECT	LEFT(@strErrorMessage, 2000);
	END;
	EXECUTE sp_OADestroy @objFolder;
	EXECUTE sp_OADestroy @objShellApplication;

	RETURN;
END;

GO


