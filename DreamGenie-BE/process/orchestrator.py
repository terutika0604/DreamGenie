from process import createSchedule
from process import registerFirestore
from schemas import CreateScheduleRequest, UpdateScheduleRequest
import json
import logging
import os
from ai_func.request_ai import request_to_ai

def orchestrate_schedule_creation(request: CreateScheduleRequest):
    ai_result = createSchedule.createSchedule(request)
    ai_json = json.loads(ai_result)
    
    # AIの処理結果をFirestoreに保存
    is_success, message_or_id = registerFirestore.store_to_firestore(request, ai_json)

    if not is_success:
        # 保存失敗時のエラーハンドリングをここに追加できます
        logging.error(f"Firestoreへの保存に失敗しました: {message_or_id}")
        return None

    # 成功した場合、Firestoreに保存されたドキュメントIDをレスポンスに追加
    ai_json['project_id'] = message_or_id
    return ai_json

def orchestrate_schedule_update(request: UpdateScheduleRequest):
    #DBから既存のスケジュール情報を取得
    schedule_data = registerFirestore.get_schedule_from_firestore(request.project_id, request.user_id)

    if schedule_data is None:
        logging.warning(f"指定されたプロジェクトが見つからないか、アクセス権がありません。project_id: {request.project_id}, user_id: {request.user_id}")
        return None

    #プロンプトを作成
    base_dir = os.path.dirname(__file__)
    prompt_path = os.path.join(base_dir, "..", "ai_func", "updateProjectPrompt.txt")
    schema_path = os.path.join(base_dir, "..", "ai_func", "StructuredOutputs.json")

    try:
        with open(prompt_path, "r", encoding="utf-8") as f:
            prompt_template = f.read()
        with open(schema_path, "r", encoding="utf-8") as f:
            schema_dict = json.load(f)
    except FileNotFoundError as e:
        logging.error(f"プロンプトまたはスキーマファイルが見つかりません: {e}", exc_info=True)
        return None

    # 既存スケジュールからAIに不要な情報を削除
    keys_to_remove = ['project_id', 'user_id', 'createdAt', 'updatedAt']
    for key in keys_to_remove:
        schedule_data.pop(key, None)

    existing_schedule_str = json.dumps(schedule_data, indent=2, ensure_ascii=False)
    
    prompt_text = prompt_template.format(
        existing_schedule=existing_schedule_str,
        user_message=request.user_message
    )

    # AIにリクエストを投げてスケジュールを更新
    ai_result_str = request_to_ai(prompt_text, schema_dict)
    ai_json = json.loads(ai_result_str)

    # is_success, _ = registerFirestore.update_schedule_in_firestore(request.project_id, ai_json)

    # 更新後のデータを返す
    ai_json['project_id'] = request.project_id
    return ai_json
