import os
import firebase_admin
import logging
from firebase_admin import credentials, firestore
from typing import Tuple
from schemas import ScheduleRequest

# アプリケーションの起動時に一度だけ初期化。
try:
    # アプリが既に初期化されている場合の重複エラーを回避
    firebase_admin.get_app()
except ValueError:
    firebase_admin.initialize_app()

# Firestoreクライアントを取得
project_id = os.environ.get('GOOGLE_CLOUD_PROJECT')
db = firestore.Client(project=project_id, database='dreamgeniedb')

def store_to_firestore(request_data: ScheduleRequest, ai_response) -> Tuple[bool, str]:
    try:

        # Pydanticモデルを辞書に変換し、Firestoreに保存するデータを準備
        data_to_store = request_data.model_dump()
        data_to_store.update({
            'tasks': ai_response.get('tasks', []),
            'ai_comment': ai_response.get('ai_comment', ''),
            'createdAt': firestore.SERVER_TIMESTAMP,
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
        print(f"Firestoreへの保存中にエラーが発生しました: {e}")
        logging.error(f"Firestoreへの保存中にエラーが発生しました: {e}", exc_info=True)
        return False, str(e)