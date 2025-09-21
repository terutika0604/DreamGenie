from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from process import orchestrator
from schemas import CreateScheduleRequest, UpdateScheduleRequest, ApprovalScheduleRequest

app = FastAPI()

# 全てのオリジンからのリクエストを許可するCORS設定
origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def hello():
    return {"message": "Hello!"}

@app.post("/createSchedule")
def create_schedule(request: CreateScheduleRequest):
    response = orchestrator.orchestrate_schedule_creation(request)
    if response is None:
        raise HTTPException(status_code=500, detail="Failed to create and save schedule.")
    return response

@app.post("/updateSchedule")
def update_schedule(request: UpdateScheduleRequest):
    response = orchestrator.orchestrate_schedule_update(request)
    if response is None:
        raise HTTPException(status_code=404, detail="Schedule not found or access denied.")
    return response

@app.post("/approvalSchedule")
def approval_schedule(request: ApprovalScheduleRequest):
    response = orchestrator.orchestrate_schedule_approval(request.model_dump())
    if response is None:
        raise HTTPException(status_code=404, detail="Failed to approve schedule. Project not found, access denied, or update failed.")
    return response

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)