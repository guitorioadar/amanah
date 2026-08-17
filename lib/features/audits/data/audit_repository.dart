import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/features/audits/data/models/audit.dart';
import 'package:dio/dio.dart';

/// Reads the signed-in auditor's audits from `GET /my-audits`, grouped by
/// [AuditSection]. `keyword` maps to the endpoint's server-side search
/// (audit no / title / type / location / client).
// ignore: one_member_abstracts
abstract interface class AuditRepository {
  Future<List<Audit>> myAudits({
    required AuditSection section,
    String? keyword,
  });
}

/// Real implementation — talks to the backend over Dio.
class AuditRepositoryImpl implements AuditRepository {
  AuditRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<Audit>> myAudits({
    required AuditSection section,
    String? keyword,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/my-audits',
        queryParameters: {
          'section': section.query,
          if (keyword != null && keyword.trim().isNotEmpty)
            'keyword': keyword.trim(),
        },
      );
      final data = (res.data!['data'] as List).cast<Map<String, dynamic>>();
      // Section isn't in the payload — inject the requested one for the chip.
      return data
          .map((j) => Audit.fromJson(j).copyWith(section: section))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

/// Mock implementation — dummy data, no backend. For tests / offline demo.
class MockAuditRepository implements AuditRepository {
  static Future<void> _latency() =>
      Future<void>.delayed(const Duration(milliseconds: 600));

  @override
  Future<List<Audit>> myAudits({
    required AuditSection section,
    String? keyword,
  }) async {
    await _latency();
    final all = _seed.where((a) => a.section == section);
    if (keyword == null || keyword.trim().isEmpty) return all.toList();
    final q = keyword.trim().toLowerCase();
    return all
        .where((a) =>
            a.title.toLowerCase().contains(q) ||
            (a.location?.toLowerCase().contains(q) ?? false) ||
            (a.client?.name.toLowerCase().contains(q) ?? false))
        .toList();
  }

  static final _seed = <Audit>[
    Audit(
      id: 3,
      title: 'Factory Verification',
      auditType: 'Special Audit',
      categoryName: 'Agricultural & Meat Processing',
      client: const AuditClient(id: 6, name: 'M.H. Shakkhor'),
      location: 'ON-8, Stratford, ON, Canada',
      eventDate: DateTime(2026, 8, 16),
      observationsTotal: 3,
      progressPercent: 64,
      observationsCompleted: 2,
    ),
    Audit(
      id: 5,
      title: 'Data Validation Reports',
      auditType: 'Annual',
      categoryName: 'Hotel Industry',
      client: const AuditClient(id: 7, name: 'The Table at Season To Taste'),
      location: 'Philadelphia, PA, United States',
      eventDate: DateTime(2026, 9, 13),
      observationsTotal: 25,
      section: AuditSection.upcoming,
    ),
  ];
}
