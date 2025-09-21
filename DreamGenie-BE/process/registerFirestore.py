import os
import firebase_admin
import logging
from firebase_admin import credentials, firestore
from typing import Tuple, Optional
from schemas import CreateScheduleRequest

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

        # start_dateとend_dateはAIのレスポンスから取得するため、リクエストデータから除外
        data_to_store = request_data.model_dump(exclude={'start_date', 'end_date'})
        # AIのレスポンス内容で更新
        data_to_store.update(ai_response)

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

def update_schedule_in_firestore(project_id: str, update_data: dict) -> bool:
    try:
        doc_ref = db.collection('schedules').document(project_id)

        # ドキュメントの存在をチェック
        doc = doc_ref.get()
        if not doc.exists:
            logging.warning(f"更新対象のドキュメントが見つかりません: {project_id}")
            return False

        # 更新データに更新日時を追加
        data_to_update = update_data.copy()
        data_to_update['updatedAt'] = firestore.SERVER_TIMESTAMP

        # ドキュメントを更新 (updateは指定したフィールドのみを更新/追加する)
        doc_ref.update(data_to_update)

        logging.info(f"Firestoreのデータを更新しました。Project ID: {project_id}")

        return True
    except Exception as e:
        logging.error(f"Firestoreの更新中に予期せぬエラーが発生しました: {e}", exc_info=True)
        return False

def get_schedule_from_firestore(project_id: str, user_id: str) -> Optional[dict]:
    try:
        doc_ref = db.collection('schedules').document(project_id)
        doc = doc_ref.get()

        if not doc.exists:
            logging.info(f"指定されたプロジェクトIDのドキュメントが見つかりません: {project_id}")
            return None

        schedule_data = doc.to_dict()

        logging.info(f"Firestoreからデータを取得しました。Project ID: {project_id}")
        return schedule_data
    except Exception as e:
        logging.error(f"Firestoreからのデータ取得中に予期せぬエラーが発生しました: {e}", exc_info=True)
        return None