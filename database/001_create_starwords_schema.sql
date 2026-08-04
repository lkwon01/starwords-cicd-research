IF DB_ID(N'StarWordsResearch') IS NULL
BEGIN
    CREATE DATABASE StarWordsResearch;
END
GO

USE StarWordsResearch;
GO

IF OBJECT_ID(N'dbo.Students', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Students (
        StudentId INT IDENTITY(1,1) PRIMARY KEY,
        Username NVARCHAR(100) NOT NULL,
        Email NVARCHAR(255) NULL,
        CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()
    );
END
GO

IF OBJECT_ID(N'dbo.Lessons', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Lessons (
        LessonId INT IDENTITY(1,1) PRIMARY KEY,
        LessonTitle NVARCHAR(200) NOT NULL,
        MissionNumber INT NOT NULL,
        CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()
    );
END
GO

IF OBJECT_ID(N'dbo.VocabularyWords', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.VocabularyWords (
        WordId INT IDENTITY(1,1) PRIMARY KEY,
        LessonId INT NOT NULL,
        KoreanWord NVARCHAR(100) NOT NULL,
        EnglishMeaning NVARCHAR(100) NOT NULL,
        Romanization NVARCHAR(100) NULL,
        Category NVARCHAR(100) NULL,
        CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_VocabularyWords_Lessons
            FOREIGN KEY (LessonId) REFERENCES dbo.Lessons(LessonId)
    );
END
GO

IF OBJECT_ID(N'dbo.QuizAttempts', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.QuizAttempts (
        AttemptId INT IDENTITY(1,1) PRIMARY KEY,
        StudentId INT NOT NULL,
        LessonId INT NOT NULL,
        StartedAt DATETIME2 DEFAULT SYSUTCDATETIME(),
        CompletedAt DATETIME2 NULL,
        ScorePercent DECIMAL(5,2) NULL,
        CONSTRAINT FK_QuizAttempts_Students
            FOREIGN KEY (StudentId) REFERENCES dbo.Students(StudentId),
        CONSTRAINT FK_QuizAttempts_Lessons
            FOREIGN KEY (LessonId) REFERENCES dbo.Lessons(LessonId)
    );
END
GO

IF OBJECT_ID(N'dbo.QuizAnswers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.QuizAnswers (
        AnswerId INT IDENTITY(1,1) PRIMARY KEY,
        AttemptId INT NOT NULL,
        WordId INT NOT NULL,
        UserAnswer NVARCHAR(100) NULL,
        IsCorrect BIT NOT NULL,
        AnsweredAt DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_QuizAnswers_QuizAttempts
            FOREIGN KEY (AttemptId) REFERENCES dbo.QuizAttempts(AttemptId),
        CONSTRAINT FK_QuizAnswers_VocabularyWords
            FOREIGN KEY (WordId) REFERENCES dbo.VocabularyWords(WordId)
    );
END
GO

IF OBJECT_ID(N'dbo.DeploymentRuns', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DeploymentRuns (
        RunId INT IDENTITY(1,1) PRIMARY KEY,
        EnvironmentName NVARCHAR(100) NOT NULL,
        DeploymentStart DATETIME2 NOT NULL,
        DeploymentEnd DATETIME2 NULL,
        DurationSeconds FLOAT NULL,
        Success BIT NOT NULL,
        ErrorStage NVARCHAR(100) NULL,
        ErrorMessage NVARCHAR(MAX) NULL,
        CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()
    );
END
GO