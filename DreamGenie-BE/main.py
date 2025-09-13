from fastapi import FastAPI
from routers import callAIagent

app = FastAPI()

@app.get("/")
def hello():
    return {"message": "Hello!"}

@app.get("/makeScashule")
def makeScashule():
    anser = callAIagent.callAIagent()
    return {"message": f"{anser}"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)