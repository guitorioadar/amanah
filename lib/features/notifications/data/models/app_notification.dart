/// A single in-app notification from `GET /notifications`. Plain model (no
/// codegen) — read-only apart from [copyWith] flipping `read_at` for optimistic
/// mark-as-read.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.readAt,
    this.actionUrl,
    this.causerName,
    this.causerType,
    this.causerAvatarUrl,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final causer = json['causer'] as Map<String, dynamic>?;
    final read = json['read_at'] as String?;
    return AppNotification(
      id: json['id'] as int,
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      readAt: read == null ? null : DateTime.parse(read),
      actionUrl: json['action_url'] as String?,
      causerName: causer?['name'] as String?,
      causerType: causer?['type'] as String?,
      causerAvatarUrl: causer?['profile_picture_url'] as String?,
    );
  }

  final int id;
  final String type;
  final String title;
  final String message;
  final DateTime createdAt;
  final DateTime? readAt;
  final String? actionUrl;
  final String? causerName;
  final String? causerType;
  final String? causerAvatarUrl;

  bool get isUnread => readAt == null;

  /// True for overdue / missed / expired / rejected events — the amber badge
  /// variant in the design. Everything else uses the blue "assignment" badge.
  bool get isAlert =>
      type.contains('overdue') ||
      type.contains('missed') ||
      type.contains('expired') ||
      type.contains('rejected') ||
      type.contains('pending');

  AppNotification copyWith({DateTime? readAt}) => AppNotification(
        id: id,
        type: type,
        title: title,
        message: message,
        createdAt: createdAt,
        readAt: readAt ?? this.readAt,
        actionUrl: actionUrl,
        causerName: causerName,
        causerType: causerType,
        causerAvatarUrl: causerAvatarUrl,
      );
}
