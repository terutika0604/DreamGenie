from fastapi import FastAPI
from process import process
from schemas import ScheduleRequest

app = FastAPI()

@app.get("/")
def hello():
    return {"message": "Hello!"}

@app.post("/createSchedule")
def create_schedule(request: ScheduleRequest):
    response = process.main_process(request)
    return response

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)