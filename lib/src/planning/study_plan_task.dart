/// 「やること」を期限付きで計画・管理するための学習タスク1件を表す
/// 不変モデル。「やること、タスク化して期限設定できる」という共通
/// 要件向けの最小単位。保存・一覧表示・通知自体はアプリ側の責務と
/// する。
class StudyPlanTask {
  const StudyPlanTask({
    required this.id,
    required this.title,
    required this.dueDate,
    this.isCompleted = false,
  });

  /// タスクを一意に識別するID。
  final String id;

  /// タスクの内容（例: 「算数の単元テストを復習する」）。
  final String title;

  /// 期限日。
  final DateTime dueDate;

  /// 完了済みかどうか。
  final bool isCompleted;

  /// [isCompleted]のみを変更した新しいインスタンスを返す。
  StudyPlanTask copyWith({bool? isCompleted}) {
    return StudyPlanTask(
      id: id,
      title: title,
      dueDate: dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// [asOf]時点で期限を過ぎており、かつ未完了であれば真を返す。
  bool isOverdue(DateTime asOf) {
    return !isCompleted && dueDate.isBefore(asOf);
  }
}
