// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

@JsonKey(fromJson: _idToString) String get id; String get name; String get email;@JsonKey(name: 'mobile_number') String? get mobileNumber;@JsonKey(name: 'is_active') bool? get isActive;@JsonKey(name: 'invitation_token_expires_at') String? get invitationTokenExpiresAt;@JsonKey(name: 'email_verified_at') String? get emailVerifiedAt;@JsonKey(name: 'created_by') Object? get createdBy;@JsonKey(name: 'updated_by') Object? get updatedBy;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;@JsonKey(name: 'deleted_at') String? get deletedAt;@JsonKey(name: 'is_login_alert') bool? get isLoginAlert;@JsonKey(name: 'password_reset_token_expires_at') String? get passwordResetTokenExpiresAt;@JsonKey(name: 'role_id') int? get roleId;@JsonKey(name: 'fcm_token_web') String? get fcmTokenWeb;@JsonKey(name: 'fcm_token_app') String? get fcmTokenApp; Address? get address; Role? get role;@JsonKey(name: 'role_label') String? get roleLabel;@JsonKey(name: 'profile_picture_url') String? get profilePictureUrl;@JsonKey(name: 'profile_picture') Map<String, dynamic>? get profilePicture;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.mobileNumber, mobileNumber) || other.mobileNumber == mobileNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.invitationTokenExpiresAt, invitationTokenExpiresAt) || other.invitationTokenExpiresAt == invitationTokenExpiresAt)&&(identical(other.emailVerifiedAt, emailVerifiedAt) || other.emailVerifiedAt == emailVerifiedAt)&&const DeepCollectionEquality().equals(other.createdBy, createdBy)&&const DeepCollectionEquality().equals(other.updatedBy, updatedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.isLoginAlert, isLoginAlert) || other.isLoginAlert == isLoginAlert)&&(identical(other.passwordResetTokenExpiresAt, passwordResetTokenExpiresAt) || other.passwordResetTokenExpiresAt == passwordResetTokenExpiresAt)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.fcmTokenWeb, fcmTokenWeb) || other.fcmTokenWeb == fcmTokenWeb)&&(identical(other.fcmTokenApp, fcmTokenApp) || other.fcmTokenApp == fcmTokenApp)&&(identical(other.address, address) || other.address == address)&&(identical(other.role, role) || other.role == role)&&(identical(other.roleLabel, roleLabel) || other.roleLabel == roleLabel)&&(identical(other.profilePictureUrl, profilePictureUrl) || other.profilePictureUrl == profilePictureUrl)&&const DeepCollectionEquality().equals(other.profilePicture, profilePicture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,email,mobileNumber,isActive,invitationTokenExpiresAt,emailVerifiedAt,const DeepCollectionEquality().hash(createdBy),const DeepCollectionEquality().hash(updatedBy),createdAt,updatedAt,deletedAt,isLoginAlert,passwordResetTokenExpiresAt,roleId,fcmTokenWeb,fcmTokenApp,address,role,roleLabel,profilePictureUrl,const DeepCollectionEquality().hash(profilePicture)]);

@override
String toString() {
  return 'User(id: $id, name: $name, email: $email, mobileNumber: $mobileNumber, isActive: $isActive, invitationTokenExpiresAt: $invitationTokenExpiresAt, emailVerifiedAt: $emailVerifiedAt, createdBy: $createdBy, updatedBy: $updatedBy, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, isLoginAlert: $isLoginAlert, passwordResetTokenExpiresAt: $passwordResetTokenExpiresAt, roleId: $roleId, fcmTokenWeb: $fcmTokenWeb, fcmTokenApp: $fcmTokenApp, address: $address, role: $role, roleLabel: $roleLabel, profilePictureUrl: $profilePictureUrl, profilePicture: $profilePicture)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idToString) String id, String name, String email,@JsonKey(name: 'mobile_number') String? mobileNumber,@JsonKey(name: 'is_active') bool? isActive,@JsonKey(name: 'invitation_token_expires_at') String? invitationTokenExpiresAt,@JsonKey(name: 'email_verified_at') String? emailVerifiedAt,@JsonKey(name: 'created_by') Object? createdBy,@JsonKey(name: 'updated_by') Object? updatedBy,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt,@JsonKey(name: 'is_login_alert') bool? isLoginAlert,@JsonKey(name: 'password_reset_token_expires_at') String? passwordResetTokenExpiresAt,@JsonKey(name: 'role_id') int? roleId,@JsonKey(name: 'fcm_token_web') String? fcmTokenWeb,@JsonKey(name: 'fcm_token_app') String? fcmTokenApp, Address? address, Role? role,@JsonKey(name: 'role_label') String? roleLabel,@JsonKey(name: 'profile_picture_url') String? profilePictureUrl,@JsonKey(name: 'profile_picture') Map<String, dynamic>? profilePicture
});


$AddressCopyWith<$Res>? get address;$RoleCopyWith<$Res>? get role;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? mobileNumber = freezed,Object? isActive = freezed,Object? invitationTokenExpiresAt = freezed,Object? emailVerifiedAt = freezed,Object? createdBy = freezed,Object? updatedBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? isLoginAlert = freezed,Object? passwordResetTokenExpiresAt = freezed,Object? roleId = freezed,Object? fcmTokenWeb = freezed,Object? fcmTokenApp = freezed,Object? address = freezed,Object? role = freezed,Object? roleLabel = freezed,Object? profilePictureUrl = freezed,Object? profilePicture = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,mobileNumber: freezed == mobileNumber ? _self.mobileNumber : mobileNumber // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,invitationTokenExpiresAt: freezed == invitationTokenExpiresAt ? _self.invitationTokenExpiresAt : invitationTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as String?,emailVerifiedAt: freezed == emailVerifiedAt ? _self.emailVerifiedAt : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy ,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy ,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,isLoginAlert: freezed == isLoginAlert ? _self.isLoginAlert : isLoginAlert // ignore: cast_nullable_to_non_nullable
as bool?,passwordResetTokenExpiresAt: freezed == passwordResetTokenExpiresAt ? _self.passwordResetTokenExpiresAt : passwordResetTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as String?,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int?,fcmTokenWeb: freezed == fcmTokenWeb ? _self.fcmTokenWeb : fcmTokenWeb // ignore: cast_nullable_to_non_nullable
as String?,fcmTokenApp: freezed == fcmTokenApp ? _self.fcmTokenApp : fcmTokenApp // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role?,roleLabel: freezed == roleLabel ? _self.roleLabel : roleLabel // ignore: cast_nullable_to_non_nullable
as String?,profilePictureUrl: freezed == profilePictureUrl ? _self.profilePictureUrl : profilePictureUrl // ignore: cast_nullable_to_non_nullable
as String?,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $AddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoleCopyWith<$Res>? get role {
    if (_self.role == null) {
    return null;
  }

  return $RoleCopyWith<$Res>(_self.role!, (value) {
    return _then(_self.copyWith(role: value));
  });
}
}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id,  String name,  String email, @JsonKey(name: 'mobile_number')  String? mobileNumber, @JsonKey(name: 'is_active')  bool? isActive, @JsonKey(name: 'invitation_token_expires_at')  String? invitationTokenExpiresAt, @JsonKey(name: 'email_verified_at')  String? emailVerifiedAt, @JsonKey(name: 'created_by')  Object? createdBy, @JsonKey(name: 'updated_by')  Object? updatedBy, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt, @JsonKey(name: 'is_login_alert')  bool? isLoginAlert, @JsonKey(name: 'password_reset_token_expires_at')  String? passwordResetTokenExpiresAt, @JsonKey(name: 'role_id')  int? roleId, @JsonKey(name: 'fcm_token_web')  String? fcmTokenWeb, @JsonKey(name: 'fcm_token_app')  String? fcmTokenApp,  Address? address,  Role? role, @JsonKey(name: 'role_label')  String? roleLabel, @JsonKey(name: 'profile_picture_url')  String? profilePictureUrl, @JsonKey(name: 'profile_picture')  Map<String, dynamic>? profilePicture)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.mobileNumber,_that.isActive,_that.invitationTokenExpiresAt,_that.emailVerifiedAt,_that.createdBy,_that.updatedBy,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.isLoginAlert,_that.passwordResetTokenExpiresAt,_that.roleId,_that.fcmTokenWeb,_that.fcmTokenApp,_that.address,_that.role,_that.roleLabel,_that.profilePictureUrl,_that.profilePicture);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id,  String name,  String email, @JsonKey(name: 'mobile_number')  String? mobileNumber, @JsonKey(name: 'is_active')  bool? isActive, @JsonKey(name: 'invitation_token_expires_at')  String? invitationTokenExpiresAt, @JsonKey(name: 'email_verified_at')  String? emailVerifiedAt, @JsonKey(name: 'created_by')  Object? createdBy, @JsonKey(name: 'updated_by')  Object? updatedBy, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt, @JsonKey(name: 'is_login_alert')  bool? isLoginAlert, @JsonKey(name: 'password_reset_token_expires_at')  String? passwordResetTokenExpiresAt, @JsonKey(name: 'role_id')  int? roleId, @JsonKey(name: 'fcm_token_web')  String? fcmTokenWeb, @JsonKey(name: 'fcm_token_app')  String? fcmTokenApp,  Address? address,  Role? role, @JsonKey(name: 'role_label')  String? roleLabel, @JsonKey(name: 'profile_picture_url')  String? profilePictureUrl, @JsonKey(name: 'profile_picture')  Map<String, dynamic>? profilePicture)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.name,_that.email,_that.mobileNumber,_that.isActive,_that.invitationTokenExpiresAt,_that.emailVerifiedAt,_that.createdBy,_that.updatedBy,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.isLoginAlert,_that.passwordResetTokenExpiresAt,_that.roleId,_that.fcmTokenWeb,_that.fcmTokenApp,_that.address,_that.role,_that.roleLabel,_that.profilePictureUrl,_that.profilePicture);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idToString)  String id,  String name,  String email, @JsonKey(name: 'mobile_number')  String? mobileNumber, @JsonKey(name: 'is_active')  bool? isActive, @JsonKey(name: 'invitation_token_expires_at')  String? invitationTokenExpiresAt, @JsonKey(name: 'email_verified_at')  String? emailVerifiedAt, @JsonKey(name: 'created_by')  Object? createdBy, @JsonKey(name: 'updated_by')  Object? updatedBy, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt, @JsonKey(name: 'is_login_alert')  bool? isLoginAlert, @JsonKey(name: 'password_reset_token_expires_at')  String? passwordResetTokenExpiresAt, @JsonKey(name: 'role_id')  int? roleId, @JsonKey(name: 'fcm_token_web')  String? fcmTokenWeb, @JsonKey(name: 'fcm_token_app')  String? fcmTokenApp,  Address? address,  Role? role, @JsonKey(name: 'role_label')  String? roleLabel, @JsonKey(name: 'profile_picture_url')  String? profilePictureUrl, @JsonKey(name: 'profile_picture')  Map<String, dynamic>? profilePicture)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.mobileNumber,_that.isActive,_that.invitationTokenExpiresAt,_that.emailVerifiedAt,_that.createdBy,_that.updatedBy,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.isLoginAlert,_that.passwordResetTokenExpiresAt,_that.roleId,_that.fcmTokenWeb,_that.fcmTokenApp,_that.address,_that.role,_that.roleLabel,_that.profilePictureUrl,_that.profilePicture);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({@JsonKey(fromJson: _idToString) required this.id, required this.name, required this.email, @JsonKey(name: 'mobile_number') this.mobileNumber, @JsonKey(name: 'is_active') this.isActive, @JsonKey(name: 'invitation_token_expires_at') this.invitationTokenExpiresAt, @JsonKey(name: 'email_verified_at') this.emailVerifiedAt, @JsonKey(name: 'created_by') this.createdBy, @JsonKey(name: 'updated_by') this.updatedBy, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'deleted_at') this.deletedAt, @JsonKey(name: 'is_login_alert') this.isLoginAlert, @JsonKey(name: 'password_reset_token_expires_at') this.passwordResetTokenExpiresAt, @JsonKey(name: 'role_id') this.roleId, @JsonKey(name: 'fcm_token_web') this.fcmTokenWeb, @JsonKey(name: 'fcm_token_app') this.fcmTokenApp, this.address, this.role, @JsonKey(name: 'role_label') this.roleLabel, @JsonKey(name: 'profile_picture_url') this.profilePictureUrl, @JsonKey(name: 'profile_picture') final  Map<String, dynamic>? profilePicture}): _profilePicture = profilePicture;
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override@JsonKey(fromJson: _idToString) final  String id;
@override final  String name;
@override final  String email;
@override@JsonKey(name: 'mobile_number') final  String? mobileNumber;
@override@JsonKey(name: 'is_active') final  bool? isActive;
@override@JsonKey(name: 'invitation_token_expires_at') final  String? invitationTokenExpiresAt;
@override@JsonKey(name: 'email_verified_at') final  String? emailVerifiedAt;
@override@JsonKey(name: 'created_by') final  Object? createdBy;
@override@JsonKey(name: 'updated_by') final  Object? updatedBy;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
@override@JsonKey(name: 'deleted_at') final  String? deletedAt;
@override@JsonKey(name: 'is_login_alert') final  bool? isLoginAlert;
@override@JsonKey(name: 'password_reset_token_expires_at') final  String? passwordResetTokenExpiresAt;
@override@JsonKey(name: 'role_id') final  int? roleId;
@override@JsonKey(name: 'fcm_token_web') final  String? fcmTokenWeb;
@override@JsonKey(name: 'fcm_token_app') final  String? fcmTokenApp;
@override final  Address? address;
@override final  Role? role;
@override@JsonKey(name: 'role_label') final  String? roleLabel;
@override@JsonKey(name: 'profile_picture_url') final  String? profilePictureUrl;
 final  Map<String, dynamic>? _profilePicture;
@override@JsonKey(name: 'profile_picture') Map<String, dynamic>? get profilePicture {
  final value = _profilePicture;
  if (value == null) return null;
  if (_profilePicture is EqualUnmodifiableMapView) return _profilePicture;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.mobileNumber, mobileNumber) || other.mobileNumber == mobileNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.invitationTokenExpiresAt, invitationTokenExpiresAt) || other.invitationTokenExpiresAt == invitationTokenExpiresAt)&&(identical(other.emailVerifiedAt, emailVerifiedAt) || other.emailVerifiedAt == emailVerifiedAt)&&const DeepCollectionEquality().equals(other.createdBy, createdBy)&&const DeepCollectionEquality().equals(other.updatedBy, updatedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.isLoginAlert, isLoginAlert) || other.isLoginAlert == isLoginAlert)&&(identical(other.passwordResetTokenExpiresAt, passwordResetTokenExpiresAt) || other.passwordResetTokenExpiresAt == passwordResetTokenExpiresAt)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.fcmTokenWeb, fcmTokenWeb) || other.fcmTokenWeb == fcmTokenWeb)&&(identical(other.fcmTokenApp, fcmTokenApp) || other.fcmTokenApp == fcmTokenApp)&&(identical(other.address, address) || other.address == address)&&(identical(other.role, role) || other.role == role)&&(identical(other.roleLabel, roleLabel) || other.roleLabel == roleLabel)&&(identical(other.profilePictureUrl, profilePictureUrl) || other.profilePictureUrl == profilePictureUrl)&&const DeepCollectionEquality().equals(other._profilePicture, _profilePicture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,email,mobileNumber,isActive,invitationTokenExpiresAt,emailVerifiedAt,const DeepCollectionEquality().hash(createdBy),const DeepCollectionEquality().hash(updatedBy),createdAt,updatedAt,deletedAt,isLoginAlert,passwordResetTokenExpiresAt,roleId,fcmTokenWeb,fcmTokenApp,address,role,roleLabel,profilePictureUrl,const DeepCollectionEquality().hash(_profilePicture)]);

@override
String toString() {
  return 'User(id: $id, name: $name, email: $email, mobileNumber: $mobileNumber, isActive: $isActive, invitationTokenExpiresAt: $invitationTokenExpiresAt, emailVerifiedAt: $emailVerifiedAt, createdBy: $createdBy, updatedBy: $updatedBy, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, isLoginAlert: $isLoginAlert, passwordResetTokenExpiresAt: $passwordResetTokenExpiresAt, roleId: $roleId, fcmTokenWeb: $fcmTokenWeb, fcmTokenApp: $fcmTokenApp, address: $address, role: $role, roleLabel: $roleLabel, profilePictureUrl: $profilePictureUrl, profilePicture: $profilePicture)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idToString) String id, String name, String email,@JsonKey(name: 'mobile_number') String? mobileNumber,@JsonKey(name: 'is_active') bool? isActive,@JsonKey(name: 'invitation_token_expires_at') String? invitationTokenExpiresAt,@JsonKey(name: 'email_verified_at') String? emailVerifiedAt,@JsonKey(name: 'created_by') Object? createdBy,@JsonKey(name: 'updated_by') Object? updatedBy,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt,@JsonKey(name: 'is_login_alert') bool? isLoginAlert,@JsonKey(name: 'password_reset_token_expires_at') String? passwordResetTokenExpiresAt,@JsonKey(name: 'role_id') int? roleId,@JsonKey(name: 'fcm_token_web') String? fcmTokenWeb,@JsonKey(name: 'fcm_token_app') String? fcmTokenApp, Address? address, Role? role,@JsonKey(name: 'role_label') String? roleLabel,@JsonKey(name: 'profile_picture_url') String? profilePictureUrl,@JsonKey(name: 'profile_picture') Map<String, dynamic>? profilePicture
});


@override $AddressCopyWith<$Res>? get address;@override $RoleCopyWith<$Res>? get role;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? mobileNumber = freezed,Object? isActive = freezed,Object? invitationTokenExpiresAt = freezed,Object? emailVerifiedAt = freezed,Object? createdBy = freezed,Object? updatedBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? isLoginAlert = freezed,Object? passwordResetTokenExpiresAt = freezed,Object? roleId = freezed,Object? fcmTokenWeb = freezed,Object? fcmTokenApp = freezed,Object? address = freezed,Object? role = freezed,Object? roleLabel = freezed,Object? profilePictureUrl = freezed,Object? profilePicture = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,mobileNumber: freezed == mobileNumber ? _self.mobileNumber : mobileNumber // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,invitationTokenExpiresAt: freezed == invitationTokenExpiresAt ? _self.invitationTokenExpiresAt : invitationTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as String?,emailVerifiedAt: freezed == emailVerifiedAt ? _self.emailVerifiedAt : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy ,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy ,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,isLoginAlert: freezed == isLoginAlert ? _self.isLoginAlert : isLoginAlert // ignore: cast_nullable_to_non_nullable
as bool?,passwordResetTokenExpiresAt: freezed == passwordResetTokenExpiresAt ? _self.passwordResetTokenExpiresAt : passwordResetTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as String?,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int?,fcmTokenWeb: freezed == fcmTokenWeb ? _self.fcmTokenWeb : fcmTokenWeb // ignore: cast_nullable_to_non_nullable
as String?,fcmTokenApp: freezed == fcmTokenApp ? _self.fcmTokenApp : fcmTokenApp // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role?,roleLabel: freezed == roleLabel ? _self.roleLabel : roleLabel // ignore: cast_nullable_to_non_nullable
as String?,profilePictureUrl: freezed == profilePictureUrl ? _self.profilePictureUrl : profilePictureUrl // ignore: cast_nullable_to_non_nullable
as String?,profilePicture: freezed == profilePicture ? _self._profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $AddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoleCopyWith<$Res>? get role {
    if (_self.role == null) {
    return null;
  }

  return $RoleCopyWith<$Res>(_self.role!, (value) {
    return _then(_self.copyWith(role: value));
  });
}
}


/// @nodoc
mixin _$Role {

@JsonKey(fromJson: _idToString) String get id; String get title; String? get slug;@JsonKey(name: 'is_active') bool? get isActive;
/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleCopyWith<Role> get copyWith => _$RoleCopyWithImpl<Role>(this as Role, _$identity);

  /// Serializes this Role to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Role&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,slug,isActive);

@override
String toString() {
  return 'Role(id: $id, title: $title, slug: $slug, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $RoleCopyWith<$Res>  {
  factory $RoleCopyWith(Role value, $Res Function(Role) _then) = _$RoleCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idToString) String id, String title, String? slug,@JsonKey(name: 'is_active') bool? isActive
});




}
/// @nodoc
class _$RoleCopyWithImpl<$Res>
    implements $RoleCopyWith<$Res> {
  _$RoleCopyWithImpl(this._self, this._then);

  final Role _self;
  final $Res Function(Role) _then;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? slug = freezed,Object? isActive = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Role].
extension RolePatterns on Role {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Role value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Role() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Role value)  $default,){
final _that = this;
switch (_that) {
case _Role():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Role value)?  $default,){
final _that = this;
switch (_that) {
case _Role() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id,  String title,  String? slug, @JsonKey(name: 'is_active')  bool? isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Role() when $default != null:
return $default(_that.id,_that.title,_that.slug,_that.isActive);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id,  String title,  String? slug, @JsonKey(name: 'is_active')  bool? isActive)  $default,) {final _that = this;
switch (_that) {
case _Role():
return $default(_that.id,_that.title,_that.slug,_that.isActive);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idToString)  String id,  String title,  String? slug, @JsonKey(name: 'is_active')  bool? isActive)?  $default,) {final _that = this;
switch (_that) {
case _Role() when $default != null:
return $default(_that.id,_that.title,_that.slug,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Role implements Role {
  const _Role({@JsonKey(fromJson: _idToString) required this.id, required this.title, this.slug, @JsonKey(name: 'is_active') this.isActive});
  factory _Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

@override@JsonKey(fromJson: _idToString) final  String id;
@override final  String title;
@override final  String? slug;
@override@JsonKey(name: 'is_active') final  bool? isActive;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleCopyWith<_Role> get copyWith => __$RoleCopyWithImpl<_Role>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Role&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,slug,isActive);

@override
String toString() {
  return 'Role(id: $id, title: $title, slug: $slug, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$RoleCopyWith<$Res> implements $RoleCopyWith<$Res> {
  factory _$RoleCopyWith(_Role value, $Res Function(_Role) _then) = __$RoleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idToString) String id, String title, String? slug,@JsonKey(name: 'is_active') bool? isActive
});




}
/// @nodoc
class __$RoleCopyWithImpl<$Res>
    implements _$RoleCopyWith<$Res> {
  __$RoleCopyWithImpl(this._self, this._then);

  final _Role _self;
  final $Res Function(_Role) _then;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? slug = freezed,Object? isActive = freezed,}) {
  return _then(_Role(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Address {

 String? get country;@JsonKey(name: 'country_short_code') String? get countryShortCode; String? get state;@JsonKey(name: 'state_short_code') String? get stateShortCode; String? get city;@JsonKey(name: 'address_line') String? get addressLine;@JsonKey(name: 'postal_code') String? get postalCode;@JsonKey(name: 'map_address') String? get mapAddress;
/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressCopyWith<Address> get copyWith => _$AddressCopyWithImpl<Address>(this as Address, _$identity);

  /// Serializes this Address to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Address&&(identical(other.country, country) || other.country == country)&&(identical(other.countryShortCode, countryShortCode) || other.countryShortCode == countryShortCode)&&(identical(other.state, state) || other.state == state)&&(identical(other.stateShortCode, stateShortCode) || other.stateShortCode == stateShortCode)&&(identical(other.city, city) || other.city == city)&&(identical(other.addressLine, addressLine) || other.addressLine == addressLine)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.mapAddress, mapAddress) || other.mapAddress == mapAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,country,countryShortCode,state,stateShortCode,city,addressLine,postalCode,mapAddress);

@override
String toString() {
  return 'Address(country: $country, countryShortCode: $countryShortCode, state: $state, stateShortCode: $stateShortCode, city: $city, addressLine: $addressLine, postalCode: $postalCode, mapAddress: $mapAddress)';
}


}

/// @nodoc
abstract mixin class $AddressCopyWith<$Res>  {
  factory $AddressCopyWith(Address value, $Res Function(Address) _then) = _$AddressCopyWithImpl;
@useResult
$Res call({
 String? country,@JsonKey(name: 'country_short_code') String? countryShortCode, String? state,@JsonKey(name: 'state_short_code') String? stateShortCode, String? city,@JsonKey(name: 'address_line') String? addressLine,@JsonKey(name: 'postal_code') String? postalCode,@JsonKey(name: 'map_address') String? mapAddress
});




}
/// @nodoc
class _$AddressCopyWithImpl<$Res>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._self, this._then);

  final Address _self;
  final $Res Function(Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? country = freezed,Object? countryShortCode = freezed,Object? state = freezed,Object? stateShortCode = freezed,Object? city = freezed,Object? addressLine = freezed,Object? postalCode = freezed,Object? mapAddress = freezed,}) {
  return _then(_self.copyWith(
country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,countryShortCode: freezed == countryShortCode ? _self.countryShortCode : countryShortCode // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,stateShortCode: freezed == stateShortCode ? _self.stateShortCode : stateShortCode // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,addressLine: freezed == addressLine ? _self.addressLine : addressLine // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,mapAddress: freezed == mapAddress ? _self.mapAddress : mapAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Address].
extension AddressPatterns on Address {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Address value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Address value)  $default,){
final _that = this;
switch (_that) {
case _Address():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Address value)?  $default,){
final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? country, @JsonKey(name: 'country_short_code')  String? countryShortCode,  String? state, @JsonKey(name: 'state_short_code')  String? stateShortCode,  String? city, @JsonKey(name: 'address_line')  String? addressLine, @JsonKey(name: 'postal_code')  String? postalCode, @JsonKey(name: 'map_address')  String? mapAddress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.country,_that.countryShortCode,_that.state,_that.stateShortCode,_that.city,_that.addressLine,_that.postalCode,_that.mapAddress);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? country, @JsonKey(name: 'country_short_code')  String? countryShortCode,  String? state, @JsonKey(name: 'state_short_code')  String? stateShortCode,  String? city, @JsonKey(name: 'address_line')  String? addressLine, @JsonKey(name: 'postal_code')  String? postalCode, @JsonKey(name: 'map_address')  String? mapAddress)  $default,) {final _that = this;
switch (_that) {
case _Address():
return $default(_that.country,_that.countryShortCode,_that.state,_that.stateShortCode,_that.city,_that.addressLine,_that.postalCode,_that.mapAddress);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? country, @JsonKey(name: 'country_short_code')  String? countryShortCode,  String? state, @JsonKey(name: 'state_short_code')  String? stateShortCode,  String? city, @JsonKey(name: 'address_line')  String? addressLine, @JsonKey(name: 'postal_code')  String? postalCode, @JsonKey(name: 'map_address')  String? mapAddress)?  $default,) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.country,_that.countryShortCode,_that.state,_that.stateShortCode,_that.city,_that.addressLine,_that.postalCode,_that.mapAddress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Address implements Address {
  const _Address({this.country, @JsonKey(name: 'country_short_code') this.countryShortCode, this.state, @JsonKey(name: 'state_short_code') this.stateShortCode, this.city, @JsonKey(name: 'address_line') this.addressLine, @JsonKey(name: 'postal_code') this.postalCode, @JsonKey(name: 'map_address') this.mapAddress});
  factory _Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

@override final  String? country;
@override@JsonKey(name: 'country_short_code') final  String? countryShortCode;
@override final  String? state;
@override@JsonKey(name: 'state_short_code') final  String? stateShortCode;
@override final  String? city;
@override@JsonKey(name: 'address_line') final  String? addressLine;
@override@JsonKey(name: 'postal_code') final  String? postalCode;
@override@JsonKey(name: 'map_address') final  String? mapAddress;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressCopyWith<_Address> get copyWith => __$AddressCopyWithImpl<_Address>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Address&&(identical(other.country, country) || other.country == country)&&(identical(other.countryShortCode, countryShortCode) || other.countryShortCode == countryShortCode)&&(identical(other.state, state) || other.state == state)&&(identical(other.stateShortCode, stateShortCode) || other.stateShortCode == stateShortCode)&&(identical(other.city, city) || other.city == city)&&(identical(other.addressLine, addressLine) || other.addressLine == addressLine)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.mapAddress, mapAddress) || other.mapAddress == mapAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,country,countryShortCode,state,stateShortCode,city,addressLine,postalCode,mapAddress);

@override
String toString() {
  return 'Address(country: $country, countryShortCode: $countryShortCode, state: $state, stateShortCode: $stateShortCode, city: $city, addressLine: $addressLine, postalCode: $postalCode, mapAddress: $mapAddress)';
}


}

/// @nodoc
abstract mixin class _$AddressCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$AddressCopyWith(_Address value, $Res Function(_Address) _then) = __$AddressCopyWithImpl;
@override @useResult
$Res call({
 String? country,@JsonKey(name: 'country_short_code') String? countryShortCode, String? state,@JsonKey(name: 'state_short_code') String? stateShortCode, String? city,@JsonKey(name: 'address_line') String? addressLine,@JsonKey(name: 'postal_code') String? postalCode,@JsonKey(name: 'map_address') String? mapAddress
});




}
/// @nodoc
class __$AddressCopyWithImpl<$Res>
    implements _$AddressCopyWith<$Res> {
  __$AddressCopyWithImpl(this._self, this._then);

  final _Address _self;
  final $Res Function(_Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? country = freezed,Object? countryShortCode = freezed,Object? state = freezed,Object? stateShortCode = freezed,Object? city = freezed,Object? addressLine = freezed,Object? postalCode = freezed,Object? mapAddress = freezed,}) {
  return _then(_Address(
country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,countryShortCode: freezed == countryShortCode ? _self.countryShortCode : countryShortCode // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,stateShortCode: freezed == stateShortCode ? _self.stateShortCode : stateShortCode // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,addressLine: freezed == addressLine ? _self.addressLine : addressLine // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,mapAddress: freezed == mapAddress ? _self.mapAddress : mapAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
