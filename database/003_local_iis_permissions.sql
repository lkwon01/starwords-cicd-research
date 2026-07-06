USE master;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_principals
    WHERE name = N'IIS APPPOOL\StarWordsApi'
)
BEGIN
    CREATE LOGIN [IIS APPPOOL\StarWordsApi] FROM WINDOWS;
END
GO

USE StarWordsResearch;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = N'IIS APPPOOL\StarWordsApi'
)
BEGIN
    CREATE USER [IIS APPPOOL\StarWordsApi]
    FOR LOGIN [IIS APPPOOL\StarWordsApi];
END
GO

IF ISNULL(IS_ROLEMEMBER(N'db_datareader', N'IIS APPPOOL\StarWordsApi'), 0) = 0
BEGIN
    ALTER ROLE db_datareader ADD MEMBER [IIS APPPOOL\StarWordsApi];
END
GO

IF ISNULL(IS_ROLEMEMBER(N'db_datawriter', N'IIS APPPOOL\StarWordsApi'), 0) = 0
BEGIN
    ALTER ROLE db_datawriter ADD MEMBER [IIS APPPOOL\StarWordsApi];
END
GO