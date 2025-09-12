import os
import json
from dotenv import load_dotenv
from vertexai.generative_models import GenerativeModel
from vertexai.generative_models import GenerationConfig
import vertexai

# .envの読み込み
load_dotenv()

# 認証情報の設定
project_id = os.getenv("GOOGLE_CLOUD_PROJECT")
location = os.getenv("GOOGLE_CLOUD_LOCATION")
vertexai.init(project=project_id, location=location)

model = GenerativeModel("gemini-2.0-flash-001")

# def callAIagent():
userMessage = "3か月でウェブアプリを作れるようになりたいです。"

#プロンプト作成
with open("makeProjectPrompt.txt", "r", encoding="utf-8") as f:
    systemMessage = f.read()
text = systemMessage + userMessage

#構造化出力の形式を取得
with open("StructuredOutputs.json", "r", encoding="utf-8") as f:
    your_schema_dict = json.load(f)

#推論
response = model.generate_content(
    text,
    generation_config=GenerationConfig(
        response_mime_type="application/json",
        response_schema=your_schema_dict
    )
)


print(response.text)
