// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditDetail _$AuditDetailFromJson(Map<String, dynamic> json) => _AuditDetail(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  status: json['status'] as String?,
  auditType: json['audit_type'] as String?,
  category: json['category'] == null
      ? null
      : AuditCategoryInfo.fromJson(json['category'] as Map<String, dynamic>),
  client: json['client'] == null
      ? null
      : AuditClient.fromJson(json['client'] as Map<String, dynamic>),
  location: json['location'] as String?,
  eventDate: json['event_date'] == null
      ? null
      : DateTime.parse(json['event_date'] as String),
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
  isCompleted: json['is_completed'] as bool? ?? false,
  observationsTotal: (json['observations_total'] as num?)?.toInt() ?? 0,
  observationsCompleted: (json['observations_completed'] as num?)?.toInt() ?? 0,
  progressPercent: (json['progress_percent'] as num?)?.toInt() ?? 0,
  permissions: json['permissions'] == null
      ? null
      : AuditPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
  auditCategories:
      (json['audit_categories'] as List<dynamic>?)
          ?.map((e) => AuditCategory.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AuditCategory>[],
);

Map<String, dynamic> _$AuditDetailToJson(_AuditDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
      'audit_type': instance.auditType,
      'category': instance.category,
      'client': instance.client,
      'location': instance.location,
      'event_date': instance.eventDate?.toIso8601String(),
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'is_completed': instance.isCompleted,
      'observations_total': instance.observationsTotal,
      'observations_completed': instance.observationsCompleted,
      'progress_percent': instance.progressPercent,
      'permissions': instance.permissions,
      'audit_categories': instance.auditCategories,
    };

_AuditCategoryInfo _$AuditCategoryInfoFromJson(Map<String, dynamic> json) =>
    _AuditCategoryInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$AuditCategoryInfoToJson(_AuditCategoryInfo instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_AuditPermissions _$AuditPermissionsFromJson(Map<String, dynamic> json) =>
    _AuditPermissions(
      isParticipant: json['is_participant'] as bool? ?? false,
      canSubmit: json['can_submit'] as bool? ?? false,
      canComplete: json['can_complete'] as bool? ?? false,
      canSeeDrafts: json['can_see_drafts'] as bool? ?? false,
    );

Map<String, dynamic> _$AuditPermissionsToJson(_AuditPermissions instance) =>
    <String, dynamic>{
      'is_participant': instance.isParticipant,
      'can_submit': instance.canSubmit,
      'can_complete': instance.canComplete,
      'can_see_drafts': instance.canSeeDrafts,
    };

_AuditCategory _$AuditCategoryFromJson(Map<String, dynamic> json) =>
    _AuditCategory(
      auditCategoryId: (json['audit_category_id'] as num).toInt(),
      title: json['title'] as String,
      eventId: (json['event_id'] as num?)?.toInt(),
      iconUrl: json['icon_url'] as String?,
      observationsTotal: (json['observations_total'] as num?)?.toInt() ?? 0,
      observationsCompleted:
          (json['observations_completed'] as num?)?.toInt() ?? 0,
      progressPercent: (json['progress_percent'] as num?)?.toInt() ?? 0,
      observations:
          (json['observations'] as List<dynamic>?)
              ?.map((e) => AuditObservation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AuditObservation>[],
    );

Map<String, dynamic> _$AuditCategoryToJson(_AuditCategory instance) =>
    <String, dynamic>{
      'audit_category_id': instance.auditCategoryId,
      'title': instance.title,
      'event_id': instance.eventId,
      'icon_url': instance.iconUrl,
      'observations_total': instance.observationsTotal,
      'observations_completed': instance.observationsCompleted,
      'progress_percent': instance.progressPercent,
      'observations': instance.observations,
    };

_AuditObservation _$AuditObservationFromJson(Map<String, dynamic> json) =>
    _AuditObservation(
      auditObservationId: (json['audit_observation_id'] as num).toInt(),
      name: json['name'] as String,
      resultId: (json['result_id'] as num?)?.toInt(),
      auditCategoryId: (json['audit_category_id'] as num?)?.toInt(),
      isDraft: json['is_draft'] as bool?,
      isCompleted: json['is_completed'] as bool? ?? false,
      finding: json['finding'] as String?,
      note: json['note'] as String?,
      hasNote: json['has_note'] as bool? ?? false,
      submittedAt: json['submitted_at'] == null
          ? null
          : DateTime.parse(json['submitted_at'] as String),
      submittedBy: json['submitted_by'] == null
          ? null
          : AuditClient.fromJson(json['submitted_by'] as Map<String, dynamic>),
      filesCount: (json['files_count'] as num?)?.toInt() ?? 0,
      photosCount: (json['photos_count'] as num?)?.toInt() ?? 0,
      videosCount: (json['videos_count'] as num?)?.toInt() ?? 0,
      documentsCount: (json['documents_count'] as num?)?.toInt() ?? 0,
      files:
          (json['files'] as List<dynamic>?)
              ?.map((e) => AuditFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AuditFile>[],
    );

Map<String, dynamic> _$AuditObservationToJson(_AuditObservation instance) =>
    <String, dynamic>{
      'audit_observation_id': instance.auditObservationId,
      'name': instance.name,
      'result_id': instance.resultId,
      'audit_category_id': instance.auditCategoryId,
      'is_draft': instance.isDraft,
      'is_completed': instance.isCompleted,
      'finding': instance.finding,
      'note': instance.note,
      'has_note': instance.hasNote,
      'submitted_at': instance.submittedAt?.toIso8601String(),
      'submitted_by': instance.submittedBy,
      'files_count': instance.filesCount,
      'photos_count': instance.photosCount,
      'videos_count': instance.videosCount,
      'documents_count': instance.documentsCount,
      'files': instance.files,
    };

_AuditFile _$AuditFileFromJson(Map<String, dynamic> json) => _AuditFile(
  id: (json['id'] as num).toInt(),
  url: json['url'] as String,
  type: json['type'] as String,
  name: json['name'] as String,
  extension: json['extension'] as String?,
  mimeType: json['mime_type'] as String?,
  size: (json['size'] as num?)?.toInt(),
);

Map<String, dynamic> _$AuditFileToJson(_AuditFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'type': instance.type,
      'name': instance.name,
      'extension': instance.extension,
      'mime_type': instance.mimeType,
      'size': instance.size,
    };
