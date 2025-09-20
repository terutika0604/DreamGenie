import os
import logging
from dotenv import load_dotenv
from vertexai.generative_models import GenerativeModel, GenerationConfig
import vertexai
from typing import Dict, Any
from fastapi import HTTPException, status
from google.api_core import exceptions as google_exceptions

# .envの読み込み
load_dotenv()

def request_to_ai(prompt_text: str, schema: Dict[str, Any]) -> str:
    project_id = os.getenv("GOOGLE_CLOUD_PROJECT")
    location = os.getenv("GOOGLE_CLOUD_LOCATION")
    try:
        vertexai.init(project=project_id, location=location)
    except Exception:
        pass

    model = GenerativeModel("gemini-2.0-flash-001")

    try:
        response = model.generate_content(
            prompt_text,
            generation_config=GenerationConfig(response_mime_type="application/json", response_schema=schema),
        )
        return response.text
    except google_exceptions.GoogleAPICallError as e:
        logging.error(f"Vertex AI API呼び出しでエラーが発生しました: {e}", exc_info=True)
        raise HTTPException(status_code=status.HTTP_503_SERVICE_UNAVAILABLE, detail="AIサービスとの通信に失敗しました。")
    except Exception as e:
        logging.error(f"AIへのリクエスト中に予期せぬエラーが発生しました: {e}", exc_info=True)
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="AI処理中に内部エラーが発生しました。")
