USE StarWordsResearch;
GO

IF COL_LENGTH('dbo.Students', 'PasswordHash') IS NULL
BEGIN
    ALTER TABLE dbo.Students
    ADD PasswordHash NVARCHAR(255) NULL;
END
GO

IF COL_LENGTH('dbo.Students', 'LastLoginAt') IS NULL
BEGIN
    ALTER TABLE dbo.Students
    ADD LastLoginAt DATETIME2 NULL;
END
GO

IF COL_LENGTH('dbo.Students', 'IsActive') IS NULL
BEGIN
    ALTER TABLE dbo.Students
    ADD IsActive BIT NOT NULL CONSTRAINT DF_Students_IsActive DEFAULT 1;
END
GO