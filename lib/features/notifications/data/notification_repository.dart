import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/features/notifications/data/models/app_notification.dart';
import 'package:dio/dio.dart';

/// Reads and mutates the signed-in user's notifications.
///
/// The list endpoint is paginated (15/page); the app currently loads the first
/// page only — enough for the design's grouped feed. Add paging when needed.
abstract interface class NotificationRepository {
  /// `GET /notifications` — most recent first.
  Future<List<AppNotification>> list();

  /// `GET /notifications/unread-count` — badge count.
  Future<int> unreadCount();

  /// `POST /notifications/{id}/read`.
  Future<void> markRead(int id);

  /// `POST /notifications/mark-all-read`.
  Future<void> markAllRead();
}

/// Real implementation — talks to the backend over Dio.
class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<AppNotification>> list() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/notifications');
      final data = (res.data!['data'] as List).cast<Map<String, dynamic>>();
      return data.map(AppNotification.fromJson).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<int> unreadCount() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/notifications/unread-count',
      );
      final data = res.data!['data'] as Map<String, dynamic>;
      return data['count'] as int? ?? 0;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> markRead(int id) async {
    try {
      await _dio.post<Map<String, dynamic>>('/notifications/$id/read');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> markAllRead() async {
    try {
      await _dio.post<Map<String, dynamic>>('/notifications/mark-all-read');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
