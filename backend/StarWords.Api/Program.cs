using Microsoft.Data.SqlClient;

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
app.MapPost("/api/auth/login", async (LoginRequest request, IConfiguration config) =>
{
    if (string.IsNullOrWhiteSpace(request.Username))
    {
        return Results.BadRequest(new
        {
            success = false,
            message = "Username is required."
        });
    }

    try
    {
        var connectionString = config.GetConnectionString("StarWordsDb");

        await using var connection = new SqlConnection(connectionString);
        await connection.OpenAsync();

        var command = new SqlCommand(
            """
            SELECT StudentId, Username, Email
            FROM dbo.Students
            WHERE Username = @Username
              AND IsActive = 1;
            """,
            connection
        );

        command.Parameters.AddWithValue("@Username", request.Username);

        await using var reader = await command.ExecuteReaderAsync();

        if (!await reader.ReadAsync())
        {
            return Results.NotFound(new
            {
                success = false,
                message = "Student not found or inactive."
            });
        }

        var studentId = reader.GetInt32(0);
        var username = reader.GetString(1);
        var email = reader.IsDBNull(2) ? "" : reader.GetString(2);

        await reader.CloseAsync();

        /*
          CI/CD RESEARCH CHANGE:
          Update LastLoginAt after successful login.
          This gives your database-backed login a visible data change,
          which is useful evidence for your research screenshots and testing.
        */
        var updateCommand = new SqlCommand(
            """
            UPDATE dbo.Students
            SET LastLoginAt = SYSUTCDATETIME()
            WHERE StudentId = @StudentId;
            """,
            connection
        );

        updateCommand.Parameters.AddWithValue("@StudentId", studentId);
        await updateCommand.ExecuteNonQueryAsync();

        return Results.Ok(new
        {
            success = true,
            studentId = studentId,
            username = username,
            email = email
        });
    }
    catch (Exception ex)
    {
        return Results.Problem(
            title: "Login failed because the API could not query SQL Server",
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
record LoginRequest(string Username);