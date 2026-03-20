from fastapi import FastAPI

app = FastAPI(title="HangeulForce API")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/")
def root() -> dict[str, str]:
    return {"message": "HangeulForce backend is running"}


@app.get("/lessons")
def lessons() -> list[dict[str, str]]:
    return [
        {"title": "Hangeul Basics", "difficulty": "beginner"},
        {"title": "Essential Korean Phrases", "difficulty": "beginner"},
        {"title": "Particles in Context", "difficulty": "intermediate"},
        {"title": "Conversational Korean", "difficulty": "intermediate"},
        {"title": "Korean News Reading", "difficulty": "advanced"},
    ]
