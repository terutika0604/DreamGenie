from process import createSchedule
from process import register_firestore
from schemas import ScheduleRequest
import json
import logging

def main_process(request: ScheduleRequest):
    ai_result = createSchedule.createSchedule(request)
    ai_json = json.loads(ai_result)
    
    # AIの処理結果をFirestoreに保存
    is_success, message_or_id = register_firestore.store_to_firestore(request, ai_json)

    if not is_success:
        # 保存失敗時のエラーハンドリングをここに追加できます
        logging.error(f"Firestoreへの保存に失敗しました: {message_or_id}")
    
    return ai_json
