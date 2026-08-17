// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditClient _$AuditClientFromJson(Map<String, dynamic> json) => _AuditClient(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String?,
);

Map<String, dynamic> _$AuditClientToJson(_AuditClient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };

_Audit _$AuditFromJson(Map<String, dynamic> json) => _Audit(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  auditNo: json['audit_no'] as String?,
  status: json['status'] as String?,
  auditType: json['audit_type'] as String?,
  categoryName: json['category_name'] as String?,
  client: json['client'] == null
      ? null
      : AuditClient.fromJson(json['client'] as Map<String, dynamic>),
  location: json['location'] as String?,
  eventDate: json['event_date'] == null
      ? null
      : DateTime.parse(json['event_date'] as String),
  isCompleted: json['is_completed'] as bool? ?? false,
  observationsTotal: (json['observations_total'] as num?)?.toInt() ?? 0,
  observationsCompleted: (json['observations_completed'] as num?)?.toInt() ?? 0,
  progressPercent: (json['progress_percent'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AuditToJson(_Audit instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'audit_no': instance.auditNo,
  'status': instance.status,
  'audit_type': instance.auditType,
  'category_name': instance.categoryName,
  'client': instance.client,
  'location': instance.location,
  'event_date': instance.eventDate?.toIso8601String(),
  'is_completed': instance.isCompleted,
  'observations_total': instance.observationsTotal,
  'observations_completed': instance.observationsCompleted,
  'progress_percent': instance.progressPercent,
};
