import os
import json
from schemas import ScheduleRequest
from ai_func.request_ai import request_to_ai

def createSchedule(request: ScheduleRequest):

    base_dir = os.path.dirname(__file__)
    # ai_funcディレクトリ内のファイルを参照
    prompt_path = os.path.join(base_dir, "..", "ai_func", "makeProjectPrompt.txt")
    schema_path = os.path.join(base_dir, "..", "ai_func", "StructuredOutputs.json")

    #プロンプト作成
    with open(prompt_path, "r", encoding="utf-8") as f:
        system_message_template = f.read()

    system_message = system_message_template.format(start_day=request.start_day, end_day=request.end_day)
    prompt_text = system_message + request.user_message

    #構造化出力の形式を取得
    with open(schema_path, "r", encoding="utf-8") as f:
        your_schema_dict = json.load(f)

    # AIにリクエストを送信
    ai_response = request_to_ai(prompt_text, your_schema_dict)

    return ai_response
