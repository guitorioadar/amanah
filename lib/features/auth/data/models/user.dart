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
    Map<String, dynamic>? address,
    Map<String, dynamic>? role,
    @JsonKey(name: 'role_label') String? roleLabel,
    @JsonKey(name: 'profile_picture_url') String? profilePictureUrl,
    @JsonKey(name: 'profile_picture') Map<String, dynamic>? profilePicture,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// Backend sends `id` as an int; the app models it as a String.
String _idToString(Object? value) => value.toString();
