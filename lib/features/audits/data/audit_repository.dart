import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/features/audits/data/models/audit.dart';
import 'package:amanah/features/audits/data/models/audit_detail.dart';
import 'package:dio/dio.dart';

/// Reads the signed-in auditor's audits from `GET /my-audits`, grouped by
/// [AuditSection]. `keyword` maps to the endpoint's server-side search
/// (audit no / title / type / location / client).
abstract interface class AuditRepository {
  Future<List<Audit>> myAudits({
    required AuditSection section,
    String? keyword,
  });

  /// Full audit for the details screen — `GET /my-audits/{id}`.
  Future<AuditDetail> auditDetail(int id);

  /// Create/update an observation submission — `POST
  /// /my-audits/{eventId}/observations/{auditObservationId}/submit`.
  /// [newFilePaths] are local files to upload; [deleteFileIds] are existing
  /// file ids to remove. Returns the updated observation.
  Future<AuditObservation> submitObservation({
    required int eventId,
    required int auditObservationId,
    required Finding finding,
    String? note,
    List<String> newFilePaths,
    List<int> deleteFileIds,
  });

  /// Finalize the audit — `POST /my-audits/{eventId}/complete`. Optional
  /// [note] is attached to the completion.
  Future<void> completeAudit(int eventId, {String? note});
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

  @override
  Future<AuditDetail> auditDetail(int id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/my-audits/$id');
      return AuditDetail.fromJson(res.data!['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<AuditObservation> submitObservation({
    required int eventId,
    required int auditObservationId,
    required Finding finding,
    String? note,
    List<String> newFilePaths = const [],
    List<int> deleteFileIds = const [],
  }) async {
    try {
      final form = FormData();
      form.fields.add(MapEntry('finding', finding.api));
      if (note != null) form.fields.add(MapEntry('note', note));
      for (final id in deleteFileIds) {
        form.fields.add(MapEntry('delete_file_ids[]', '$id'));
      }
      for (final path in newFilePaths) {
        form.files.add(
          MapEntry('files[]', await MultipartFile.fromFile(path)),
        );
      }
      final res = await _dio.post<Map<String, dynamic>>(
        '/my-audits/$eventId/observations/$auditObservationId/submit',
        data: form,
      );
      return AuditObservation.fromJson(res.data!['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> completeAudit(int eventId, {String? note}) async {
    try {
      final trimmed = note?.trim();
      await _dio.post<Map<String, dynamic>>(
        '/my-audits/$eventId/complete',
        data: {
          if (trimmed != null && trimmed.isNotEmpty) 'note': trimmed,
        },
      );
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

  @override
  Future<AuditDetail> auditDetail(int id) async {
    await _latency();
    final base = _seed.firstWhere(
      (a) => a.id == id,
      orElse: () => _seed.first,
    );
    return AuditDetail(
      id: base.id,
      title: base.title,
      status: base.section.name,
      auditType: base.auditType,
      category: base.categoryName == null
          ? null
          : AuditCategoryInfo(id: 0, name: base.categoryName!),
      client: base.client,
      location: base.location,
      eventDate: base.eventDate,
      startTime: '09:00:00',
      endTime: '10:00:00',
      observationsTotal: base.observationsTotal,
      observationsCompleted: base.observationsCompleted,
      progressPercent: base.progressPercent,
      permissions: const AuditPermissions(canComplete: true, canSubmit: true),
      auditCategories: const [
        AuditCategory(
          auditCategoryId: 1,
          title: 'Verification',
          observationsTotal: 3,
          observations: [
            AuditObservation(auditObservationId: 1, name: 'Halal Process'),
            AuditObservation(
              auditObservationId: 2,
              name: 'Maintenance Process',
            ),
            AuditObservation(
              auditObservationId: 3,
              name: 'Production Process',
            ),
          ],
        ),
      ],
    );
  }

  @override
  Future<AuditObservation> submitObservation({
    required int eventId,
    required int auditObservationId,
    required Finding finding,
    String? note,
    List<String> newFilePaths = const [],
    List<int> deleteFileIds = const [],
  }) async {
    await _latency();
    return AuditObservation(
      auditObservationId: auditObservationId,
      name: 'Observation $auditObservationId',
      resultId: auditObservationId,
      isDraft: true,
      finding: finding.api,
      note: note,
      hasNote: note != null && note.isNotEmpty,
    );
  }

  @override
  Future<void> completeAudit(int eventId, {String? note}) => _latency();

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
