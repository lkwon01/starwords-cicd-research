using Microsoft.Data.SqlClient;
using System.Net.Mail;
using Microsoft.AspNetCore.Identity;

var builder = WebApplication.CreateBuilder(args);

/*
  CI/CD RESEARCH CHANGE:
  Added CORS so the frontend index.html can call this backend API.
  This is needed because your frontend page and API may run from different origins:
  - frontend file or static site
  - IIS API at http://localhost:8080
*/
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowLocalFrontend", policy =>
    {
        policy.AllowAnyHeader()
              .AllowAnyMethod()
              .AllowAnyOrigin();
    });
});


var app = builder.Build();

app.UseCors("AllowLocalFrontend");

/*
  CI/CD RESEARCH CHANGE:
  Root endpoint confirms the API is running.
  This helps distinguish "IIS/API is down" from "database connection failed."
*/
app.MapGet("/", () => "Star Words API is running.");

/*
  CI/CD RESEARCH CHANGE:
  Database health endpoint.
  Research purpose:
  This proves the local simulated enterprise path:
  Browser -> IIS -> ASP.NET Core API -> SQL Server Express.
*/
app.MapGet("/health/db", async (IConfiguration config) =>
{
    var connectionString = config.GetConnectionString("StarWordsDb");

    try
    {
        await using var connection = new SqlConnection(connectionString);
        await connection.OpenAsync();

        var command = new SqlCommand(
            "SELECT COUNT(*) FROM dbo.VocabularyWords;",
            connection
        );

        var result = await command.ExecuteScalarAsync();
        var wordCount = Convert.ToInt32(result);

        return Results.Ok(new
        {
            database = "connected",
            wordCount = wordCount,
            environment = "Local IIS + SQL Server Express"
        });
    }
    catch (Exception ex)
    {
        return Results.Problem(
            title: "Database connection failed",
            detail: ex.Message
        );
    }
});

/*
  CI/CD RESEARCH CHANGE:
  Vocabulary endpoint.
  Research purpose:
  This proves the API can read actual Star Words learning data from SQL Server,
  not just open a database connection.
*/
app.MapGet("/api/words", async (IConfiguration config) =>
{
    try
    {
        var words = new List<object>();
        var connectionString = config.GetConnectionString("StarWordsDb");

        await using var connection = new SqlConnection(connectionString);
        await connection.OpenAsync();

        var command = new SqlCommand(
            """
            SELECT WordId, KoreanWord, EnglishMeaning, Romanization, Category
            FROM dbo.VocabularyWords
            ORDER BY WordId;
            """,
            connection
        );

        await using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            words.Add(new
            {
                wordId = reader.GetInt32(0),
                koreanWord = reader.GetString(1),
                englishMeaning = reader.GetString(2),
                romanization = reader.IsDBNull(3) ? "" : reader.GetString(3),
                category = reader.IsDBNull(4) ? "" : reader.GetString(4)
            });
        }

        return Results.Ok(words);
    }
    catch (Exception ex)
    {
        return Results.Problem(
            title: "Could not load vocabulary words",
            detail: ex.Message
        );
    }
});

/*
  CI/CD RESEARCH CHANGE:
  Added a basic login endpoint for the "Join the Rebellion" button on index.html.

  Research purpose:
  This proves the full database-backed application flow:
  index.html -> IIS API -> SQL Server Students table.

  Note:
  This is a simple research/demo login using username only.
  It is not production authentication yet.
*/
app.MapPost("/api/auth/register", async (
    RegisterRequest request,
    IConfiguration config) =>
{
    var username = request.Username?.Trim() ?? "";
    var email = request.Email?.Trim().ToLowerInvariant() ?? "";
    var password = request.Password ?? "";

    if (username.Length < 3 || username.Length > 100)
    {
        return Results.BadRequest(new
        {
            success = false,
            message = "Username must contain between 3 and 100 characters."
        });
    }

    if (email.Length == 0 || email.Length > 255)
    {
        return Results.BadRequest(new
        {
            success = false,
            message = "A valid email address is required."
        });
    }

    try
    {
        _ = new MailAddress(email);
    }
    catch (FormatException)
    {
        return Results.BadRequest(new
        {
            success = false,
            message = "Please enter a valid email address."
        });
    }

    if (password.Length < 8 || password.Length > 100)
    {
        return Results.BadRequest(new
        {
            success = false,
            message = "Password must contain between 8 and 100 characters."
        });
    }

    try
    {
        var connectionString =
            config.GetConnectionString("StarWordsDb");

        await using var connection =
            new SqlConnection(connectionString);

        await connection.OpenAsync();

        var existingCommand = new SqlCommand(
            """
            SELECT
                CASE
                    WHEN EXISTS
                    (
                        SELECT 1
                        FROM dbo.Students
                        WHERE Username = @Username
                    )
                    THEN 'username'

                    WHEN EXISTS
                    (
                        SELECT 1
                        FROM dbo.Students
                        WHERE Email = @Email
                    )
                    THEN 'email'

                    ELSE NULL
                END;
            """,
            connection
        );

        existingCommand.Parameters.Add(
            "@Username",
            System.Data.SqlDbType.NVarChar,
            100
        ).Value = username;

        existingCommand.Parameters.Add(
            "@Email",
            System.Data.SqlDbType.NVarChar,
            255
        ).Value = email;

        var existingValue =
            await existingCommand.ExecuteScalarAsync();

        var existingField =
            existingValue == null ||
            existingValue == DBNull.Value
                ? null
                : Convert.ToString(existingValue);

        if (existingField == "username")
        {
            return Results.Conflict(new
            {
                success = false,
                message = "That username is already registered."
            });
        }

        if (existingField == "email")
        {
            return Results.Conflict(new
            {
                success = false,
                message = "That email address is already registered."
            });
        }

        var passwordHasher =
            new PasswordHasher<string>();

        var passwordHash =
            passwordHasher.HashPassword(username, password);

        var insertCommand = new SqlCommand(
            """
            INSERT INTO dbo.Students
            (
                Username,
                Email,
                PasswordHash,
                IsActive
            )
            OUTPUT INSERTED.StudentId
            VALUES
            (
                @Username,
                @Email,
                @PasswordHash,
                1
            );
            """,
            connection
        );

        insertCommand.Parameters.Add(
            "@Username",
            System.Data.SqlDbType.NVarChar,
            100
        ).Value = username;

        insertCommand.Parameters.Add(
            "@Email",
            System.Data.SqlDbType.NVarChar,
            255
        ).Value = email;

        insertCommand.Parameters.Add(
            "@PasswordHash",
            System.Data.SqlDbType.NVarChar,
            255
        ).Value = passwordHash;

        var result =
            await insertCommand.ExecuteScalarAsync();

        var studentId = Convert.ToInt32(result);

        return Results.Created(
            "/api/auth/login",
            new
            {
                success = true,
                studentId,
                username,
                email,
                message = "Your rebel account was created."
            }
        );
    }
    catch (SqlException ex)
        when (ex.Number == 2601 || ex.Number == 2627)
    {
        return Results.Conflict(new
        {
            success = false,
            message = "That username or email is already registered."
        });
    }
    catch (Exception ex)
    {
        return Results.Problem(
            title: "Registration failed",
            detail: ex.Message
        );
    }
});
app.MapPost("/api/auth/login", async (
    LoginRequest request,
    IConfiguration config) =>
{
    var username = request.Username?.Trim() ?? "";
    var password = request.Password ?? "";

    if (string.IsNullOrWhiteSpace(username) ||
        string.IsNullOrWhiteSpace(password))
    {
        return Results.BadRequest(new
        {
            success = false,
            message = "Username and password are required."
        });
    }

    try
    {
        var connectionString =
            config.GetConnectionString("StarWordsDb");

        await using var connection =
            new SqlConnection(connectionString);

        await connection.OpenAsync();

        var command = new SqlCommand(
            """
            SELECT
                StudentId,
                Username,
                Email,
                PasswordHash
            FROM dbo.Students
            WHERE Username = @Username
              AND IsActive = 1;
            """,
            connection
        );

        command.Parameters.Add(
            "@Username",
            System.Data.SqlDbType.NVarChar,
            100
        ).Value = username;

        await using var reader =
            await command.ExecuteReaderAsync();

        if (!await reader.ReadAsync())
        {
            return Results.Unauthorized();
        }

        var studentId = reader.GetInt32(0);
        var storedUsername = reader.GetString(1);
        var email =
            reader.IsDBNull(2) ? "" : reader.GetString(2);

        var passwordHash =
            reader.IsDBNull(3) ? "" : reader.GetString(3);

        await reader.CloseAsync();

        if (string.IsNullOrWhiteSpace(passwordHash))
        {
            return Results.Unauthorized();
        }

        var passwordHasher =
            new PasswordHasher<string>();

        var verificationResult =
            passwordHasher.VerifyHashedPassword(
                storedUsername,
                passwordHash,
                password
            );

        if (verificationResult ==
            PasswordVerificationResult.Failed)
        {
            return Results.Unauthorized();
        }

        var updateCommand = new SqlCommand(
            """
            UPDATE dbo.Students
            SET LastLoginAt = SYSUTCDATETIME()
            WHERE StudentId = @StudentId;
            """,
            connection
        );

        updateCommand.Parameters.Add(
            "@StudentId",
            System.Data.SqlDbType.Int
        ).Value = studentId;

        await updateCommand.ExecuteNonQueryAsync();

        return Results.Ok(new
        {
            success = true,
            studentId,
            username = storedUsername,
            email
        });
    }
    catch (Exception ex)
    {
        return Results.Problem(
            title: "Login failed",
            detail: ex.Message
        );
    }
});
/*
  CI/CD RESEARCH CHANGE:
  app.Run() must stay after all app.MapGet/app.MapPost endpoint definitions.
  Any endpoint placed after app.Run() will not be reachable.
*/
app.Run();

/*
  CI/CD RESEARCH CHANGE:
  Defines the JSON body expected by POST /api/auth/login.
  Example request body:
  { "username": "test_student_1" }
*/
record LoginRequest(string Username, string Password);
record RegisterRequest(string Username, string Email, string Password);