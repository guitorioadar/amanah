import 'package:amanah/features/audits/data/models/audit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_detail.freezed.dart';
part 'audit_detail.g.dart';

/// Finding field-state for an observation (the 3-way selector value).
enum Finding {
  compliant,
  nonCompliant,
  na;

  /// API token (`compliant` / `non_compliant` / `na`).
  String get api => switch (this) {
        Finding.compliant => 'compliant',
        Finding.nonCompliant => 'non_compliant',
        Finding.na => 'na',
      };

  String get label => switch (this) {
        Finding.compliant => 'Compliant',
        Finding.nonCompliant => 'Non-compliant',
        Finding.na => 'N/A',
      };

  static Finding? fromApi(String? value) => switch (value) {
        'compliant' => Finding.compliant,
        'non_compliant' => Finding.nonCompliant,
        'na' => Finding.na,
        _ => null,
      };
}

/// Lifecycle of an observation result.
/// `notSubmitted` (no result) → `draft` (saved, editable) → `completed`
/// (finalized by the complete-audit call).
enum ObservationState { notSubmitted, draft, completed }

/// Full audit from `GET /my-audits/{id}` — powers the Audit-details screen.
/// Every optional field is nullable / defaulted so a partial payload never
/// crashes parsing. The submission-modal fields (`files`, `submitted_by`) are
/// intentionally not modelled yet (schema pending).
@freezed
sealed class AuditDetail with _$AuditDetail {
  const factory AuditDetail({
    required int id,
    required String title,

    /// Section value: `running` / `upcoming` / `completed`.
    String? status,
    @JsonKey(name: 'audit_type') String? auditType,
    @JsonKey(name: 'category_name') String? categoryName,
    AuditClient? client,
    String? location,
    @JsonKey(name: 'event_date') DateTime? eventDate,
    @JsonKey(name: 'start_time') String? startTime,
    @JsonKey(name: 'end_time') String? endTime,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'observations_total') @Default(0) int observationsTotal,
    @JsonKey(name: 'observations_completed')
    @Default(0)
    int observationsCompleted,
    @JsonKey(name: 'progress_percent') @Default(0) int progressPercent,
    AuditPermissions? permissions,
    @JsonKey(name: 'audit_categories')
    @Default(<AuditCategory>[])
    List<AuditCategory> auditCategories,
  }) = _AuditDetail;
  const AuditDetail._();

  factory AuditDetail.fromJson(Map<String, dynamic> json) =>
      _$AuditDetailFromJson(json);

  /// The card/header status chip section, derived from [status].
  AuditSection get section => AuditSection.fromStatus(status);
}

/// What the signed-in auditor may do with this audit (drives the CTA / inputs).
@freezed
sealed class AuditPermissions with _$AuditPermissions {
  const factory AuditPermissions({
    @JsonKey(name: 'is_participant') @Default(false) bool isParticipant,
    @JsonKey(name: 'can_submit') @Default(false) bool canSubmit,
    @JsonKey(name: 'can_complete') @Default(false) bool canComplete,
    @JsonKey(name: 'can_see_drafts') @Default(false) bool canSeeDrafts,
  }) = _AuditPermissions;

  factory AuditPermissions.fromJson(Map<String, dynamic> json) =>
      _$AuditPermissionsFromJson(json);
}

/// One process/checklist category card on the details screen.
@freezed
sealed class AuditCategory with _$AuditCategory {
  const factory AuditCategory({
    @JsonKey(name: 'audit_category_id') required int auditCategoryId,
    required String title,
    @JsonKey(name: 'event_id') int? eventId,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'observations_total') @Default(0) int observationsTotal,
    @JsonKey(name: 'observations_completed')
    @Default(0)
    int observationsCompleted,
    @JsonKey(name: 'progress_percent') @Default(0) int progressPercent,
    @Default(<AuditObservation>[]) List<AuditObservation> observations,
  }) = _AuditCategory;

  factory AuditCategory.fromJson(Map<String, dynamic> json) =>
      _$AuditCategoryFromJson(json);
}

/// One observation row inside a category (the checklist item).
@freezed
sealed class AuditObservation with _$AuditObservation {
  const factory AuditObservation({
    @JsonKey(name: 'audit_observation_id') required int auditObservationId,
    required String name,
    @JsonKey(name: 'result_id') int? resultId,
    @JsonKey(name: 'audit_category_id') int? auditCategoryId,
    @JsonKey(name: 'is_draft') bool? isDraft,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,

    /// `compliant` / `non_compliant` / `na` — null until submitted.
    String? finding,
    String? note,
    @JsonKey(name: 'has_note') @Default(false) bool hasNote,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'submitted_by') AuditClient? submittedBy,
    @JsonKey(name: 'files_count') @Default(0) int filesCount,
    @JsonKey(name: 'photos_count') @Default(0) int photosCount,
    @JsonKey(name: 'videos_count') @Default(0) int videosCount,
    @JsonKey(name: 'documents_count') @Default(0) int documentsCount,
    @Default(<AuditFile>[]) List<AuditFile> files,
  }) = _AuditObservation;
  const AuditObservation._();

  factory AuditObservation.fromJson(Map<String, dynamic> json) =>
      _$AuditObservationFromJson(json);

  /// Selected finding as an enum (null until submitted).
  Finding? get findingValue => Finding.fromApi(finding);

  /// Lifecycle state derived from the result/completion flags.
  ObservationState get state {
    if (isCompleted) return ObservationState.completed;
    if (resultId != null) return ObservationState.draft;
    return ObservationState.notSubmitted;
  }

  /// Whether a submission exists (draft or completed).
  bool get isSubmitted => state != ObservationState.notSubmitted;
}

/// An uploaded file attached to an observation result.
@freezed
sealed class AuditFile with _$AuditFile {
  const factory AuditFile({
    required int id,
    required String url,

    /// `photo` / `video` / `document`.
    required String type,
    required String name,
    String? extension,
    @JsonKey(name: 'mime_type') String? mimeType,
    int? size,
  }) = _AuditFile;
  const AuditFile._();

  factory AuditFile.fromJson(Map<String, dynamic> json) =>
      _$AuditFileFromJson(json);

  bool get isPhoto => type == 'photo';
  bool get isVideo => type == 'video';
  bool get isDocument => type == 'document';
}
