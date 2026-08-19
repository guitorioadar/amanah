import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit.freezed.dart';
part 'audit.g.dart';

/// Which `/my-audits` list an audit belongs to. Drives the card's status chip.
/// The value comes from the request `section`, **not** the per-item `status`
/// field (which is a separate outcome flag like "missed"). See §M3 analysis.
enum AuditSection {
  running,
  upcoming,
  completed;

  /// Query value for `?section=`.
  String get query => name;

  /// Maps the detail payload's `status` string to a section. Falls back to
  /// [running] for an unknown/absent value.
  static AuditSection fromStatus(String? status) => switch (status) {
        'upcoming' => upcoming,
        'completed' => completed,
        _ => running,
      };

  /// Chip label shown on the card.
  String get chipLabel => switch (this) {
        AuditSection.running => 'In progress',
        AuditSection.upcoming => 'Upcoming',
        AuditSection.completed => 'Completed',
      };
}

/// The client an audit is performed for. Only the fields the card/detail needs.
@freezed
sealed class AuditClient with _$AuditClient {
  const factory AuditClient({
    required int id,
    required String name,
    String? email,
  }) = _AuditClient;

  factory AuditClient.fromJson(Map<String, dynamic> json) =>
      _$AuditClientFromJson(json);
}

/// A single audit from `GET /my-audits`. Every optional field is nullable so a
/// missing value (null `location`, `category_name`, `event_date`, …) never
/// crashes parsing — the card hides the corresponding chip/row instead.
///
/// [section] is injected by the repository from the requested section and is
/// not part of the JSON payload.
@freezed
sealed class Audit with _$Audit {
  const factory Audit({
    required int id,
    required String title,
    @JsonKey(name: 'audit_no') String? auditNo,

    /// Per-item outcome flag (e.g. "missed"). Not the section — kept for detail.
    String? status,
    @JsonKey(name: 'audit_type') String? auditType,

    /// Industry / category tag chip (e.g. "Agricultural & Meat Processing").
    @JsonKey(name: 'category_name') String? categoryName,
    AuditClient? client,
    String? location,
    @JsonKey(name: 'event_date') DateTime? eventDate,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'observations_total') @Default(0) int observationsTotal,
    @JsonKey(name: 'observations_completed') @Default(0) int observationsCompleted,
    @JsonKey(name: 'progress_percent') @Default(0) int progressPercent,

    // Injected from the request; not in the JSON.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(AuditSection.running)
    AuditSection section,
  }) = _Audit;

  factory Audit.fromJson(Map<String, dynamic> json) => _$AuditFromJson(json);
}
