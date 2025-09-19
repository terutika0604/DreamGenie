from pydantic import BaseModel

class CreateScheduleRequest(BaseModel):
    user_id: str
    title: str
    start_day: str
    end_day: str
    user_goal: str

class UpdateScheduleRequest(BaseModel):
    project_id: str
    user_id: str
    user_message: str
