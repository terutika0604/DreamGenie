import os
import firebase_admin
import logging
from firebase_admin import credentials, firestore
from typing import Tuple, Optional
from schemas import CreateScheduleRequest
from datetime import datetime

# アプリケーションの起動時に一度だけ初期化。
try:
    # アプリが既に初期化されている場合の重複エラーを回避
    firebase_admin.get_app()
except ValueError:
    firebase_admin.initialize_app()

# Firestoreクライアントを取得
project_id = os.environ.get('GOOGLE_CLOUD_PROJECT')
db = firestore.Client(project=project_id, database='dreamgeniedb')

def store_to_firestore(request_data: CreateScheduleRequest, ai_response) -> Tuple[bool, str]:
    try:

        # Pydanticモデルを辞書に変換し、Firestoreに保存するデータを準備
        data_to_store = request_data.model_dump()
        data_to_store.update({
            'tasks': ai_response.get('tasks', []),
            'ai_comment': ai_response.get('ai_comment', ''),
            'createdAt': datetime.now().strftime('%Y/%m/%d %H:%M:%S.%f')[:-3],
        })

        doc_ref = db.collection('schedules').document()
        data_to_store['project_id'] = doc_ref.id
        doc_ref.set(data_to_store)

        logging.info(f"Firestoreにデータを保存しました。Project ID: {doc_ref.id}")
        return True, doc_ref.id
    except firebase_admin.exceptions.FirebaseError as e:
        logging.error(f"Firestoreへの保存中にFirebaseエラーが発生しました: {e}", exc_info=True)
        return False, f"Firebase error: {e}"
    except Exception as e:
        logging.error(f"Firestoreへの保存中にエラーが発生しました: {e}", exc_info=True)
        return False, str(e)

def update_schedule_in_firestore(project_id: str, ai_response: dict) -> Tuple[bool, Optional[str]]:
   # Firestoreの既存のスケジュールを更新します。
   return()

def get_schedule_from_firestore(project_id: str, user_id: str) -> Optional[dict]:
    try:
        doc_ref = db.collection('schedules').document(project_id)
        doc = doc_ref.get()

        if not doc.exists:
            logging.info(f"指定されたプロジェクトIDのドキュメントが見つかりません: {project_id}")
            return None

        schedule_data = doc.to_dict()

        if schedule_data.get('user_id') != user_id:
            logging.warning(f"ユーザーIDが一致しません。Project ID: {project_id}, Request User ID: {user_id}")
            return None

        logging.info(f"Firestoreからデータを取得しました。Project ID: {project_id}")
        return schedule_data
    except Exception as e:
        logging.error(f"Firestoreからのデータ取得中に予期せぬエラーが発生しました: {e}", exc_info=True)
        return None