from pydantic import BaseModel

class CreateScheduleRequest(BaseModel):
    user_id: str
    title: str
    start_date: str
    end_date: str
    user_goal: str

class UpdateScheduleRequest(BaseModel):
    project_id: str
    user_id: str
    user_message: str

class ApprovalScheduleRequest(BaseModel):
    project_id: str

    class Config:
        # updateScheduleのレスポンスに含まれる他のフィールドも受け入れる
        extra = "allow"
