from pydantic import BaseModel

class ScheduleRequest(BaseModel):
    user_id: str
    title: str
    start_day: str
    end_day: str
    user_message: str
