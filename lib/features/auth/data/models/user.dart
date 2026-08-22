import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Authenticated auditor. Mirrors the backend `user` object. Every field except
/// [id]/[name]/[email] is nullable — the API returns `null` for anything unset,
/// so missing or empty values never crash parsing.
@freezed
sealed class User with _$User {
  const factory User({
    @JsonKey(fromJson: _idToString) required String id,
    required String name,
    required String email,
    @JsonKey(name: 'mobile_number') String? mobileNumber,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'invitation_token_expires_at') String? invitationTokenExpiresAt,
    @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
    @JsonKey(name: 'created_by') Object? createdBy,
    @JsonKey(name: 'updated_by') Object? updatedBy,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    @JsonKey(name: 'is_login_alert') bool? isLoginAlert,
    @JsonKey(name: 'password_reset_token_expires_at') String? passwordResetTokenExpiresAt,
    @JsonKey(name: 'role_id') int? roleId,
    @JsonKey(name: 'fcm_token_web') String? fcmTokenWeb,
    @JsonKey(name: 'fcm_token_app') String? fcmTokenApp,
    Address? address,
    Role? role,
    @JsonKey(name: 'role_label') String? roleLabel,
    @JsonKey(name: 'profile_picture_url') String? profilePictureUrl,
    @JsonKey(name: 'profile_picture') Map<String, dynamic>? profilePicture,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// The user's organizational role. [slug] (e.g. `auditor`, `super-admin`) is
/// the stable key for permission gating; [title] is the display name.
@freezed
sealed class Role with _$Role {
  const factory Role({
    @JsonKey(fromJson: _idToString) required String id,
    required String title,
    String? slug,
    @JsonKey(name: 'is_active') bool? isActive,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}

/// The user's mailing address. All fields nullable — the backend returns a
/// sparse object for partially-filled profiles.
@freezed
sealed class Address with _$Address {
  const factory Address({
    String? country,
    @JsonKey(name: 'country_short_code') String? countryShortCode,
    String? state,
    @JsonKey(name: 'state_short_code') String? stateShortCode,
    String? city,
    @JsonKey(name: 'address_line') String? addressLine,
    @JsonKey(name: 'postal_code') String? postalCode,
    @JsonKey(name: 'map_address') String? mapAddress,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}

/// Backend sends `id` as an int; the app models it as a String.
String _idToString(Object? value) => value.toString();
