class UpdateData {
  final String projectId;
  final String userId;
  final String userMessage;

  UpdateData({
    required this.userId,
    required this.projectId,
    required this.userMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'project_id': projectId,
      'user_id': userId,
      'title': userMessage,
    };
  }
}
