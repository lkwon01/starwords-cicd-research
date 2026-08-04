USE StarWordsResearch;
GO

DELETE FROM dbo.QuizAnswers;
DELETE FROM dbo.QuizAttempts;
DELETE FROM dbo.VocabularyWords;
DELETE FROM dbo.Lessons;
DELETE FROM dbo.Students;
GO

DBCC CHECKIDENT ('dbo.QuizAnswers', RESEED, 0);
DBCC CHECKIDENT ('dbo.QuizAttempts', RESEED, 0);
DBCC CHECKIDENT ('dbo.VocabularyWords', RESEED, 0);
DBCC CHECKIDENT ('dbo.Lessons', RESEED, 0);
DBCC CHECKIDENT ('dbo.Students', RESEED, 0);
GO

INSERT INTO dbo.Students (Username, Email)
VALUES
('test_student_1', 'student1@example.com'),
('test_student_2', 'student2@example.com');
GO

INSERT INTO dbo.Lessons (LessonTitle, MissionNumber)
VALUES
('Mission 1: Basic Korean Words', 1),
('Mission 2: Food and Places', 2);
GO

INSERT INTO dbo.VocabularyWords
(LessonId, KoreanWord, EnglishMeaning, Romanization, Category)
VALUES
(1, N'고양이', 'cat', 'goyangi', 'animal'),
(1, N'학교', 'school', 'hakgyo', 'place'),
(1, N'사과', 'apple', 'sagwa', 'food'),
(2, N'물', 'water', 'mul', 'food'),
(2, N'집', 'house', 'jip', 'place');
GO

INSERT INTO dbo.QuizAttempts
(StudentId, LessonId, CompletedAt, ScorePercent)
VALUES
(1, 1, SYSUTCDATETIME(), 66.67);
GO

INSERT INTO dbo.QuizAnswers
(AttemptId, WordId, UserAnswer, IsCorrect)
VALUES
(1, 1, 'cat', 1),
(1, 2, 'home', 0),
(1, 3, 'apple', 1);
GO

SELECT * FROM dbo.Students;
SELECT * FROM dbo.Lessons;
SELECT * FROM dbo.VocabularyWords;
SELECT * FROM dbo.QuizAttempts;
SELECT * FROM dbo.QuizAnswers;
GO