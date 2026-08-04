from fastapi import FastAPI
app = FastAPI()

@app.get("/")
def home():
    return {"message": "Star Words backend is running."}