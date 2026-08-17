// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: _idToString(json['id']),
  name: json['name'] as String,
  email: json['email'] as String,
  mobileNumber: json['mobile_number'] as String?,
  isActive: json['is_active'] as bool?,
  invitationTokenExpiresAt: json['invitation_token_expires_at'] as String?,
  emailVerifiedAt: json['email_verified_at'] as String?,
  createdBy: json['created_by'],
  updatedBy: json['updated_by'],
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  deletedAt: json['deleted_at'] as String?,
  isLoginAlert: json['is_login_alert'] as bool?,
  passwordResetTokenExpiresAt:
      json['password_reset_token_expires_at'] as String?,
  roleId: (json['role_id'] as num?)?.toInt(),
  address: json['address'] as Map<String, dynamic>?,
  role: json['role'] as Map<String, dynamic>?,
  roleLabel: json['role_label'] as String?,
  profilePictureUrl: json['profile_picture_url'] as String?,
  profilePicture: json['profile_picture'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'mobile_number': instance.mobileNumber,
  'is_active': instance.isActive,
  'invitation_token_expires_at': instance.invitationTokenExpiresAt,
  'email_verified_at': instance.emailVerifiedAt,
  'created_by': instance.createdBy,
  'updated_by': instance.updatedBy,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'deleted_at': instance.deletedAt,
  'is_login_alert': instance.isLoginAlert,
  'password_reset_token_expires_at': instance.passwordResetTokenExpiresAt,
  'role_id': instance.roleId,
  'address': instance.address,
  'role': instance.role,
  'role_label': instance.roleLabel,
  'profile_picture_url': instance.profilePictureUrl,
  'profile_picture': instance.profilePicture,
};
