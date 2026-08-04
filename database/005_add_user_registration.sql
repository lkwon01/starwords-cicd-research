USE StarWordsResearch;
GO

/*
    Prevent two students from registering the same username.
*/
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'UX_Students_Username'
      AND object_id = OBJECT_ID(N'dbo.Students')
)
BEGIN
    CREATE UNIQUE INDEX UX_Students_Username
        ON dbo.Students (Username);
END
GO

/*
    Prevent two students from registering the same email address.
    NULL values are excluded for compatibility with older test accounts.
*/
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'UX_Students_Email'
      AND object_id = OBJECT_ID(N'dbo.Students')
)
BEGIN
    CREATE UNIQUE INDEX UX_Students_Email
        ON dbo.Students (Email)
        WHERE Email IS NOT NULL;
END
GO