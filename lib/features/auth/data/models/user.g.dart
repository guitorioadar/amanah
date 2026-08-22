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
  fcmTokenWeb: json['fcm_token_web'] as String?,
  fcmTokenApp: json['fcm_token_app'] as String?,
  address: json['address'] == null
      ? null
      : Address.fromJson(json['address'] as Map<String, dynamic>),
  role: json['role'] == null
      ? null
      : Role.fromJson(json['role'] as Map<String, dynamic>),
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
  'fcm_token_web': instance.fcmTokenWeb,
  'fcm_token_app': instance.fcmTokenApp,
  'address': instance.address,
  'role': instance.role,
  'role_label': instance.roleLabel,
  'profile_picture_url': instance.profilePictureUrl,
  'profile_picture': instance.profilePicture,
};

_Role _$RoleFromJson(Map<String, dynamic> json) => _Role(
  id: _idToString(json['id']),
  title: json['title'] as String,
  slug: json['slug'] as String?,
  isActive: json['is_active'] as bool?,
);

Map<String, dynamic> _$RoleToJson(_Role instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'slug': instance.slug,
  'is_active': instance.isActive,
};

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
  country: json['country'] as String?,
  countryShortCode: json['country_short_code'] as String?,
  state: json['state'] as String?,
  stateShortCode: json['state_short_code'] as String?,
  city: json['city'] as String?,
  addressLine: json['address_line'] as String?,
  postalCode: json['postal_code'] as String?,
  mapAddress: json['map_address'] as String?,
);

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
  'country': instance.country,
  'country_short_code': instance.countryShortCode,
  'state': instance.state,
  'state_short_code': instance.stateShortCode,
  'city': instance.city,
  'address_line': instance.addressLine,
  'postal_code': instance.postalCode,
  'map_address': instance.mapAddress,
};
