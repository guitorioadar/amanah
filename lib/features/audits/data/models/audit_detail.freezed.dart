// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditDetail {

 int get id; String get title;/// Section value: `running` / `upcoming` / `completed`.
 String? get status;@JsonKey(name: 'audit_type') String? get auditType; AuditCategoryInfo? get category; AuditClient? get client; String? get location;@JsonKey(name: 'event_date') DateTime? get eventDate;@JsonKey(name: 'start_time') String? get startTime;@JsonKey(name: 'end_time') String? get endTime;@JsonKey(name: 'is_completed') bool get isCompleted;@JsonKey(name: 'observations_total') int get observationsTotal;@JsonKey(name: 'observations_completed') int get observationsCompleted;@JsonKey(name: 'progress_percent') int get progressPercent; AuditPermissions? get permissions;@JsonKey(name: 'audit_categories') List<AuditCategory> get auditCategories;
/// Create a copy of AuditDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditDetailCopyWith<AuditDetail> get copyWith => _$AuditDetailCopyWithImpl<AuditDetail>(this as AuditDetail, _$identity);

  /// Serializes this AuditDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.auditType, auditType) || other.auditType == auditType)&&(identical(other.category, category) || other.category == category)&&(identical(other.client, client) || other.client == client)&&(identical(other.location, location) || other.location == location)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.observationsTotal, observationsTotal) || other.observationsTotal == observationsTotal)&&(identical(other.observationsCompleted, observationsCompleted) || other.observationsCompleted == observationsCompleted)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&const DeepCollectionEquality().equals(other.auditCategories, auditCategories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,auditType,category,client,location,eventDate,startTime,endTime,isCompleted,observationsTotal,observationsCompleted,progressPercent,permissions,const DeepCollectionEquality().hash(auditCategories));

@override
String toString() {
  return 'AuditDetail(id: $id, title: $title, status: $status, auditType: $auditType, category: $category, client: $client, location: $location, eventDate: $eventDate, startTime: $startTime, endTime: $endTime, isCompleted: $isCompleted, observationsTotal: $observationsTotal, observationsCompleted: $observationsCompleted, progressPercent: $progressPercent, permissions: $permissions, auditCategories: $auditCategories)';
}


}

/// @nodoc
abstract mixin class $AuditDetailCopyWith<$Res>  {
  factory $AuditDetailCopyWith(AuditDetail value, $Res Function(AuditDetail) _then) = _$AuditDetailCopyWithImpl;
@useResult
$Res call({
 int id, String title, String? status,@JsonKey(name: 'audit_type') String? auditType, AuditCategoryInfo? category, AuditClient? client, String? location,@JsonKey(name: 'event_date') DateTime? eventDate,@JsonKey(name: 'start_time') String? startTime,@JsonKey(name: 'end_time') String? endTime,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'observations_total') int observationsTotal,@JsonKey(name: 'observations_completed') int observationsCompleted,@JsonKey(name: 'progress_percent') int progressPercent, AuditPermissions? permissions,@JsonKey(name: 'audit_categories') List<AuditCategory> auditCategories
});


$AuditCategoryInfoCopyWith<$Res>? get category;$AuditClientCopyWith<$Res>? get client;$AuditPermissionsCopyWith<$Res>? get permissions;

}
/// @nodoc
class _$AuditDetailCopyWithImpl<$Res>
    implements $AuditDetailCopyWith<$Res> {
  _$AuditDetailCopyWithImpl(this._self, this._then);

  final AuditDetail _self;
  final $Res Function(AuditDetail) _then;

/// Create a copy of AuditDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? status = freezed,Object? auditType = freezed,Object? category = freezed,Object? client = freezed,Object? location = freezed,Object? eventDate = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? isCompleted = null,Object? observationsTotal = null,Object? observationsCompleted = null,Object? progressPercent = null,Object? permissions = freezed,Object? auditCategories = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,auditType: freezed == auditType ? _self.auditType : auditType // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as AuditCategoryInfo?,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as AuditClient?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,eventDate: freezed == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,observationsTotal: null == observationsTotal ? _self.observationsTotal : observationsTotal // ignore: cast_nullable_to_non_nullable
as int,observationsCompleted: null == observationsCompleted ? _self.observationsCompleted : observationsCompleted // ignore: cast_nullable_to_non_nullable
as int,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as AuditPermissions?,auditCategories: null == auditCategories ? _self.auditCategories : auditCategories // ignore: cast_nullable_to_non_nullable
as List<AuditCategory>,
  ));
}
/// Create a copy of AuditDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuditCategoryInfoCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $AuditCategoryInfoCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of AuditDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuditClientCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $AuditClientCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of AuditDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuditPermissionsCopyWith<$Res>? get permissions {
    if (_self.permissions == null) {
    return null;
  }

  return $AuditPermissionsCopyWith<$Res>(_self.permissions!, (value) {
    return _then(_self.copyWith(permissions: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuditDetail].
extension AuditDetailPatterns on AuditDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditDetail value)  $default,){
final _that = this;
switch (_that) {
case _AuditDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditDetail value)?  $default,){
final _that = this;
switch (_that) {
case _AuditDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String? status, @JsonKey(name: 'audit_type')  String? auditType,  AuditCategoryInfo? category,  AuditClient? client,  String? location, @JsonKey(name: 'event_date')  DateTime? eventDate, @JsonKey(name: 'start_time')  String? startTime, @JsonKey(name: 'end_time')  String? endTime, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'observations_total')  int observationsTotal, @JsonKey(name: 'observations_completed')  int observationsCompleted, @JsonKey(name: 'progress_percent')  int progressPercent,  AuditPermissions? permissions, @JsonKey(name: 'audit_categories')  List<AuditCategory> auditCategories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditDetail() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.auditType,_that.category,_that.client,_that.location,_that.eventDate,_that.startTime,_that.endTime,_that.isCompleted,_that.observationsTotal,_that.observationsCompleted,_that.progressPercent,_that.permissions,_that.auditCategories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String? status, @JsonKey(name: 'audit_type')  String? auditType,  AuditCategoryInfo? category,  AuditClient? client,  String? location, @JsonKey(name: 'event_date')  DateTime? eventDate, @JsonKey(name: 'start_time')  String? startTime, @JsonKey(name: 'end_time')  String? endTime, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'observations_total')  int observationsTotal, @JsonKey(name: 'observations_completed')  int observationsCompleted, @JsonKey(name: 'progress_percent')  int progressPercent,  AuditPermissions? permissions, @JsonKey(name: 'audit_categories')  List<AuditCategory> auditCategories)  $default,) {final _that = this;
switch (_that) {
case _AuditDetail():
return $default(_that.id,_that.title,_that.status,_that.auditType,_that.category,_that.client,_that.location,_that.eventDate,_that.startTime,_that.endTime,_that.isCompleted,_that.observationsTotal,_that.observationsCompleted,_that.progressPercent,_that.permissions,_that.auditCategories);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String? status, @JsonKey(name: 'audit_type')  String? auditType,  AuditCategoryInfo? category,  AuditClient? client,  String? location, @JsonKey(name: 'event_date')  DateTime? eventDate, @JsonKey(name: 'start_time')  String? startTime, @JsonKey(name: 'end_time')  String? endTime, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'observations_total')  int observationsTotal, @JsonKey(name: 'observations_completed')  int observationsCompleted, @JsonKey(name: 'progress_percent')  int progressPercent,  AuditPermissions? permissions, @JsonKey(name: 'audit_categories')  List<AuditCategory> auditCategories)?  $default,) {final _that = this;
switch (_that) {
case _AuditDetail() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.auditType,_that.category,_that.client,_that.location,_that.eventDate,_that.startTime,_that.endTime,_that.isCompleted,_that.observationsTotal,_that.observationsCompleted,_that.progressPercent,_that.permissions,_that.auditCategories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditDetail extends AuditDetail {
  const _AuditDetail({required this.id, required this.title, this.status, @JsonKey(name: 'audit_type') this.auditType, this.category, this.client, this.location, @JsonKey(name: 'event_date') this.eventDate, @JsonKey(name: 'start_time') this.startTime, @JsonKey(name: 'end_time') this.endTime, @JsonKey(name: 'is_completed') this.isCompleted = false, @JsonKey(name: 'observations_total') this.observationsTotal = 0, @JsonKey(name: 'observations_completed') this.observationsCompleted = 0, @JsonKey(name: 'progress_percent') this.progressPercent = 0, this.permissions, @JsonKey(name: 'audit_categories') final  List<AuditCategory> auditCategories = const <AuditCategory>[]}): _auditCategories = auditCategories,super._();
  factory _AuditDetail.fromJson(Map<String, dynamic> json) => _$AuditDetailFromJson(json);

@override final  int id;
@override final  String title;
/// Section value: `running` / `upcoming` / `completed`.
@override final  String? status;
@override@JsonKey(name: 'audit_type') final  String? auditType;
@override final  AuditCategoryInfo? category;
@override final  AuditClient? client;
@override final  String? location;
@override@JsonKey(name: 'event_date') final  DateTime? eventDate;
@override@JsonKey(name: 'start_time') final  String? startTime;
@override@JsonKey(name: 'end_time') final  String? endTime;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;
@override@JsonKey(name: 'observations_total') final  int observationsTotal;
@override@JsonKey(name: 'observations_completed') final  int observationsCompleted;
@override@JsonKey(name: 'progress_percent') final  int progressPercent;
@override final  AuditPermissions? permissions;
 final  List<AuditCategory> _auditCategories;
@override@JsonKey(name: 'audit_categories') List<AuditCategory> get auditCategories {
  if (_auditCategories is EqualUnmodifiableListView) return _auditCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_auditCategories);
}


/// Create a copy of AuditDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditDetailCopyWith<_AuditDetail> get copyWith => __$AuditDetailCopyWithImpl<_AuditDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.auditType, auditType) || other.auditType == auditType)&&(identical(other.category, category) || other.category == category)&&(identical(other.client, client) || other.client == client)&&(identical(other.location, location) || other.location == location)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.observationsTotal, observationsTotal) || other.observationsTotal == observationsTotal)&&(identical(other.observationsCompleted, observationsCompleted) || other.observationsCompleted == observationsCompleted)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&const DeepCollectionEquality().equals(other._auditCategories, _auditCategories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,auditType,category,client,location,eventDate,startTime,endTime,isCompleted,observationsTotal,observationsCompleted,progressPercent,permissions,const DeepCollectionEquality().hash(_auditCategories));

@override
String toString() {
  return 'AuditDetail(id: $id, title: $title, status: $status, auditType: $auditType, category: $category, client: $client, location: $location, eventDate: $eventDate, startTime: $startTime, endTime: $endTime, isCompleted: $isCompleted, observationsTotal: $observationsTotal, observationsCompleted: $observationsCompleted, progressPercent: $progressPercent, permissions: $permissions, auditCategories: $auditCategories)';
}


}

/// @nodoc
abstract mixin class _$AuditDetailCopyWith<$Res> implements $AuditDetailCopyWith<$Res> {
  factory _$AuditDetailCopyWith(_AuditDetail value, $Res Function(_AuditDetail) _then) = __$AuditDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String? status,@JsonKey(name: 'audit_type') String? auditType, AuditCategoryInfo? category, AuditClient? client, String? location,@JsonKey(name: 'event_date') DateTime? eventDate,@JsonKey(name: 'start_time') String? startTime,@JsonKey(name: 'end_time') String? endTime,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'observations_total') int observationsTotal,@JsonKey(name: 'observations_completed') int observationsCompleted,@JsonKey(name: 'progress_percent') int progressPercent, AuditPermissions? permissions,@JsonKey(name: 'audit_categories') List<AuditCategory> auditCategories
});


@override $AuditCategoryInfoCopyWith<$Res>? get category;@override $AuditClientCopyWith<$Res>? get client;@override $AuditPermissionsCopyWith<$Res>? get permissions;

}
/// @nodoc
class __$AuditDetailCopyWithImpl<$Res>
    implements _$AuditDetailCopyWith<$Res> {
  __$AuditDetailCopyWithImpl(this._self, this._then);

  final _AuditDetail _self;
  final $Res Function(_AuditDetail) _then;

/// Create a copy of AuditDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? status = freezed,Object? auditType = freezed,Object? category = freezed,Object? client = freezed,Object? location = freezed,Object? eventDate = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? isCompleted = null,Object? observationsTotal = null,Object? observationsCompleted = null,Object? progressPercent = null,Object? permissions = freezed,Object? auditCategories = null,}) {
  return _then(_AuditDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,auditType: freezed == auditType ? _self.auditType : auditType // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as AuditCategoryInfo?,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as AuditClient?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,eventDate: freezed == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,observationsTotal: null == observationsTotal ? _self.observationsTotal : observationsTotal // ignore: cast_nullable_to_non_nullable
as int,observationsCompleted: null == observationsCompleted ? _self.observationsCompleted : observationsCompleted // ignore: cast_nullable_to_non_nullable
as int,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as AuditPermissions?,auditCategories: null == auditCategories ? _self._auditCategories : auditCategories // ignore: cast_nullable_to_non_nullable
as List<AuditCategory>,
  ));
}

/// Create a copy of AuditDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuditCategoryInfoCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $AuditCategoryInfoCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of AuditDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuditClientCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $AuditClientCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of AuditDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuditPermissionsCopyWith<$Res>? get permissions {
    if (_self.permissions == null) {
    return null;
  }

  return $AuditPermissionsCopyWith<$Res>(_self.permissions!, (value) {
    return _then(_self.copyWith(permissions: value));
  });
}
}


/// @nodoc
mixin _$AuditCategoryInfo {

 int get id; String get name;
/// Create a copy of AuditCategoryInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditCategoryInfoCopyWith<AuditCategoryInfo> get copyWith => _$AuditCategoryInfoCopyWithImpl<AuditCategoryInfo>(this as AuditCategoryInfo, _$identity);

  /// Serializes this AuditCategoryInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditCategoryInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'AuditCategoryInfo(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $AuditCategoryInfoCopyWith<$Res>  {
  factory $AuditCategoryInfoCopyWith(AuditCategoryInfo value, $Res Function(AuditCategoryInfo) _then) = _$AuditCategoryInfoCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$AuditCategoryInfoCopyWithImpl<$Res>
    implements $AuditCategoryInfoCopyWith<$Res> {
  _$AuditCategoryInfoCopyWithImpl(this._self, this._then);

  final AuditCategoryInfo _self;
  final $Res Function(AuditCategoryInfo) _then;

/// Create a copy of AuditCategoryInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditCategoryInfo].
extension AuditCategoryInfoPatterns on AuditCategoryInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditCategoryInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditCategoryInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditCategoryInfo value)  $default,){
final _that = this;
switch (_that) {
case _AuditCategoryInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditCategoryInfo value)?  $default,){
final _that = this;
switch (_that) {
case _AuditCategoryInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditCategoryInfo() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _AuditCategoryInfo():
return $default(_that.id,_that.name);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _AuditCategoryInfo() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditCategoryInfo implements AuditCategoryInfo {
  const _AuditCategoryInfo({required this.id, required this.name});
  factory _AuditCategoryInfo.fromJson(Map<String, dynamic> json) => _$AuditCategoryInfoFromJson(json);

@override final  int id;
@override final  String name;

/// Create a copy of AuditCategoryInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditCategoryInfoCopyWith<_AuditCategoryInfo> get copyWith => __$AuditCategoryInfoCopyWithImpl<_AuditCategoryInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditCategoryInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditCategoryInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'AuditCategoryInfo(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$AuditCategoryInfoCopyWith<$Res> implements $AuditCategoryInfoCopyWith<$Res> {
  factory _$AuditCategoryInfoCopyWith(_AuditCategoryInfo value, $Res Function(_AuditCategoryInfo) _then) = __$AuditCategoryInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$AuditCategoryInfoCopyWithImpl<$Res>
    implements _$AuditCategoryInfoCopyWith<$Res> {
  __$AuditCategoryInfoCopyWithImpl(this._self, this._then);

  final _AuditCategoryInfo _self;
  final $Res Function(_AuditCategoryInfo) _then;

/// Create a copy of AuditCategoryInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_AuditCategoryInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AuditPermissions {

@JsonKey(name: 'is_participant') bool get isParticipant;@JsonKey(name: 'can_submit') bool get canSubmit;@JsonKey(name: 'can_complete') bool get canComplete;@JsonKey(name: 'can_see_drafts') bool get canSeeDrafts;
/// Create a copy of AuditPermissions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditPermissionsCopyWith<AuditPermissions> get copyWith => _$AuditPermissionsCopyWithImpl<AuditPermissions>(this as AuditPermissions, _$identity);

  /// Serializes this AuditPermissions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditPermissions&&(identical(other.isParticipant, isParticipant) || other.isParticipant == isParticipant)&&(identical(other.canSubmit, canSubmit) || other.canSubmit == canSubmit)&&(identical(other.canComplete, canComplete) || other.canComplete == canComplete)&&(identical(other.canSeeDrafts, canSeeDrafts) || other.canSeeDrafts == canSeeDrafts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isParticipant,canSubmit,canComplete,canSeeDrafts);

@override
String toString() {
  return 'AuditPermissions(isParticipant: $isParticipant, canSubmit: $canSubmit, canComplete: $canComplete, canSeeDrafts: $canSeeDrafts)';
}


}

/// @nodoc
abstract mixin class $AuditPermissionsCopyWith<$Res>  {
  factory $AuditPermissionsCopyWith(AuditPermissions value, $Res Function(AuditPermissions) _then) = _$AuditPermissionsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'is_participant') bool isParticipant,@JsonKey(name: 'can_submit') bool canSubmit,@JsonKey(name: 'can_complete') bool canComplete,@JsonKey(name: 'can_see_drafts') bool canSeeDrafts
});




}
/// @nodoc
class _$AuditPermissionsCopyWithImpl<$Res>
    implements $AuditPermissionsCopyWith<$Res> {
  _$AuditPermissionsCopyWithImpl(this._self, this._then);

  final AuditPermissions _self;
  final $Res Function(AuditPermissions) _then;

/// Create a copy of AuditPermissions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isParticipant = null,Object? canSubmit = null,Object? canComplete = null,Object? canSeeDrafts = null,}) {
  return _then(_self.copyWith(
isParticipant: null == isParticipant ? _self.isParticipant : isParticipant // ignore: cast_nullable_to_non_nullable
as bool,canSubmit: null == canSubmit ? _self.canSubmit : canSubmit // ignore: cast_nullable_to_non_nullable
as bool,canComplete: null == canComplete ? _self.canComplete : canComplete // ignore: cast_nullable_to_non_nullable
as bool,canSeeDrafts: null == canSeeDrafts ? _self.canSeeDrafts : canSeeDrafts // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditPermissions].
extension AuditPermissionsPatterns on AuditPermissions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditPermissions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditPermissions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditPermissions value)  $default,){
final _that = this;
switch (_that) {
case _AuditPermissions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditPermissions value)?  $default,){
final _that = this;
switch (_that) {
case _AuditPermissions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_participant')  bool isParticipant, @JsonKey(name: 'can_submit')  bool canSubmit, @JsonKey(name: 'can_complete')  bool canComplete, @JsonKey(name: 'can_see_drafts')  bool canSeeDrafts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditPermissions() when $default != null:
return $default(_that.isParticipant,_that.canSubmit,_that.canComplete,_that.canSeeDrafts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_participant')  bool isParticipant, @JsonKey(name: 'can_submit')  bool canSubmit, @JsonKey(name: 'can_complete')  bool canComplete, @JsonKey(name: 'can_see_drafts')  bool canSeeDrafts)  $default,) {final _that = this;
switch (_that) {
case _AuditPermissions():
return $default(_that.isParticipant,_that.canSubmit,_that.canComplete,_that.canSeeDrafts);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'is_participant')  bool isParticipant, @JsonKey(name: 'can_submit')  bool canSubmit, @JsonKey(name: 'can_complete')  bool canComplete, @JsonKey(name: 'can_see_drafts')  bool canSeeDrafts)?  $default,) {final _that = this;
switch (_that) {
case _AuditPermissions() when $default != null:
return $default(_that.isParticipant,_that.canSubmit,_that.canComplete,_that.canSeeDrafts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditPermissions implements AuditPermissions {
  const _AuditPermissions({@JsonKey(name: 'is_participant') this.isParticipant = false, @JsonKey(name: 'can_submit') this.canSubmit = false, @JsonKey(name: 'can_complete') this.canComplete = false, @JsonKey(name: 'can_see_drafts') this.canSeeDrafts = false});
  factory _AuditPermissions.fromJson(Map<String, dynamic> json) => _$AuditPermissionsFromJson(json);

@override@JsonKey(name: 'is_participant') final  bool isParticipant;
@override@JsonKey(name: 'can_submit') final  bool canSubmit;
@override@JsonKey(name: 'can_complete') final  bool canComplete;
@override@JsonKey(name: 'can_see_drafts') final  bool canSeeDrafts;

/// Create a copy of AuditPermissions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditPermissionsCopyWith<_AuditPermissions> get copyWith => __$AuditPermissionsCopyWithImpl<_AuditPermissions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditPermissionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditPermissions&&(identical(other.isParticipant, isParticipant) || other.isParticipant == isParticipant)&&(identical(other.canSubmit, canSubmit) || other.canSubmit == canSubmit)&&(identical(other.canComplete, canComplete) || other.canComplete == canComplete)&&(identical(other.canSeeDrafts, canSeeDrafts) || other.canSeeDrafts == canSeeDrafts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isParticipant,canSubmit,canComplete,canSeeDrafts);

@override
String toString() {
  return 'AuditPermissions(isParticipant: $isParticipant, canSubmit: $canSubmit, canComplete: $canComplete, canSeeDrafts: $canSeeDrafts)';
}


}

/// @nodoc
abstract mixin class _$AuditPermissionsCopyWith<$Res> implements $AuditPermissionsCopyWith<$Res> {
  factory _$AuditPermissionsCopyWith(_AuditPermissions value, $Res Function(_AuditPermissions) _then) = __$AuditPermissionsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'is_participant') bool isParticipant,@JsonKey(name: 'can_submit') bool canSubmit,@JsonKey(name: 'can_complete') bool canComplete,@JsonKey(name: 'can_see_drafts') bool canSeeDrafts
});




}
/// @nodoc
class __$AuditPermissionsCopyWithImpl<$Res>
    implements _$AuditPermissionsCopyWith<$Res> {
  __$AuditPermissionsCopyWithImpl(this._self, this._then);

  final _AuditPermissions _self;
  final $Res Function(_AuditPermissions) _then;

/// Create a copy of AuditPermissions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isParticipant = null,Object? canSubmit = null,Object? canComplete = null,Object? canSeeDrafts = null,}) {
  return _then(_AuditPermissions(
isParticipant: null == isParticipant ? _self.isParticipant : isParticipant // ignore: cast_nullable_to_non_nullable
as bool,canSubmit: null == canSubmit ? _self.canSubmit : canSubmit // ignore: cast_nullable_to_non_nullable
as bool,canComplete: null == canComplete ? _self.canComplete : canComplete // ignore: cast_nullable_to_non_nullable
as bool,canSeeDrafts: null == canSeeDrafts ? _self.canSeeDrafts : canSeeDrafts // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AuditCategory {

@JsonKey(name: 'audit_category_id') int get auditCategoryId; String get title;@JsonKey(name: 'event_id') int? get eventId;@JsonKey(name: 'icon_url') String? get iconUrl;@JsonKey(name: 'observations_total') int get observationsTotal;@JsonKey(name: 'observations_completed') int get observationsCompleted;@JsonKey(name: 'progress_percent') int get progressPercent; List<AuditObservation> get observations;
/// Create a copy of AuditCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditCategoryCopyWith<AuditCategory> get copyWith => _$AuditCategoryCopyWithImpl<AuditCategory>(this as AuditCategory, _$identity);

  /// Serializes this AuditCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditCategory&&(identical(other.auditCategoryId, auditCategoryId) || other.auditCategoryId == auditCategoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.observationsTotal, observationsTotal) || other.observationsTotal == observationsTotal)&&(identical(other.observationsCompleted, observationsCompleted) || other.observationsCompleted == observationsCompleted)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&const DeepCollectionEquality().equals(other.observations, observations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,auditCategoryId,title,eventId,iconUrl,observationsTotal,observationsCompleted,progressPercent,const DeepCollectionEquality().hash(observations));

@override
String toString() {
  return 'AuditCategory(auditCategoryId: $auditCategoryId, title: $title, eventId: $eventId, iconUrl: $iconUrl, observationsTotal: $observationsTotal, observationsCompleted: $observationsCompleted, progressPercent: $progressPercent, observations: $observations)';
}


}

/// @nodoc
abstract mixin class $AuditCategoryCopyWith<$Res>  {
  factory $AuditCategoryCopyWith(AuditCategory value, $Res Function(AuditCategory) _then) = _$AuditCategoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'audit_category_id') int auditCategoryId, String title,@JsonKey(name: 'event_id') int? eventId,@JsonKey(name: 'icon_url') String? iconUrl,@JsonKey(name: 'observations_total') int observationsTotal,@JsonKey(name: 'observations_completed') int observationsCompleted,@JsonKey(name: 'progress_percent') int progressPercent, List<AuditObservation> observations
});




}
/// @nodoc
class _$AuditCategoryCopyWithImpl<$Res>
    implements $AuditCategoryCopyWith<$Res> {
  _$AuditCategoryCopyWithImpl(this._self, this._then);

  final AuditCategory _self;
  final $Res Function(AuditCategory) _then;

/// Create a copy of AuditCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? auditCategoryId = null,Object? title = null,Object? eventId = freezed,Object? iconUrl = freezed,Object? observationsTotal = null,Object? observationsCompleted = null,Object? progressPercent = null,Object? observations = null,}) {
  return _then(_self.copyWith(
auditCategoryId: null == auditCategoryId ? _self.auditCategoryId : auditCategoryId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,eventId: freezed == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as int?,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,observationsTotal: null == observationsTotal ? _self.observationsTotal : observationsTotal // ignore: cast_nullable_to_non_nullable
as int,observationsCompleted: null == observationsCompleted ? _self.observationsCompleted : observationsCompleted // ignore: cast_nullable_to_non_nullable
as int,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,observations: null == observations ? _self.observations : observations // ignore: cast_nullable_to_non_nullable
as List<AuditObservation>,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditCategory].
extension AuditCategoryPatterns on AuditCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditCategory value)  $default,){
final _that = this;
switch (_that) {
case _AuditCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditCategory value)?  $default,){
final _that = this;
switch (_that) {
case _AuditCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'audit_category_id')  int auditCategoryId,  String title, @JsonKey(name: 'event_id')  int? eventId, @JsonKey(name: 'icon_url')  String? iconUrl, @JsonKey(name: 'observations_total')  int observationsTotal, @JsonKey(name: 'observations_completed')  int observationsCompleted, @JsonKey(name: 'progress_percent')  int progressPercent,  List<AuditObservation> observations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditCategory() when $default != null:
return $default(_that.auditCategoryId,_that.title,_that.eventId,_that.iconUrl,_that.observationsTotal,_that.observationsCompleted,_that.progressPercent,_that.observations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'audit_category_id')  int auditCategoryId,  String title, @JsonKey(name: 'event_id')  int? eventId, @JsonKey(name: 'icon_url')  String? iconUrl, @JsonKey(name: 'observations_total')  int observationsTotal, @JsonKey(name: 'observations_completed')  int observationsCompleted, @JsonKey(name: 'progress_percent')  int progressPercent,  List<AuditObservation> observations)  $default,) {final _that = this;
switch (_that) {
case _AuditCategory():
return $default(_that.auditCategoryId,_that.title,_that.eventId,_that.iconUrl,_that.observationsTotal,_that.observationsCompleted,_that.progressPercent,_that.observations);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'audit_category_id')  int auditCategoryId,  String title, @JsonKey(name: 'event_id')  int? eventId, @JsonKey(name: 'icon_url')  String? iconUrl, @JsonKey(name: 'observations_total')  int observationsTotal, @JsonKey(name: 'observations_completed')  int observationsCompleted, @JsonKey(name: 'progress_percent')  int progressPercent,  List<AuditObservation> observations)?  $default,) {final _that = this;
switch (_that) {
case _AuditCategory() when $default != null:
return $default(_that.auditCategoryId,_that.title,_that.eventId,_that.iconUrl,_that.observationsTotal,_that.observationsCompleted,_that.progressPercent,_that.observations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditCategory implements AuditCategory {
  const _AuditCategory({@JsonKey(name: 'audit_category_id') required this.auditCategoryId, required this.title, @JsonKey(name: 'event_id') this.eventId, @JsonKey(name: 'icon_url') this.iconUrl, @JsonKey(name: 'observations_total') this.observationsTotal = 0, @JsonKey(name: 'observations_completed') this.observationsCompleted = 0, @JsonKey(name: 'progress_percent') this.progressPercent = 0, final  List<AuditObservation> observations = const <AuditObservation>[]}): _observations = observations;
  factory _AuditCategory.fromJson(Map<String, dynamic> json) => _$AuditCategoryFromJson(json);

@override@JsonKey(name: 'audit_category_id') final  int auditCategoryId;
@override final  String title;
@override@JsonKey(name: 'event_id') final  int? eventId;
@override@JsonKey(name: 'icon_url') final  String? iconUrl;
@override@JsonKey(name: 'observations_total') final  int observationsTotal;
@override@JsonKey(name: 'observations_completed') final  int observationsCompleted;
@override@JsonKey(name: 'progress_percent') final  int progressPercent;
 final  List<AuditObservation> _observations;
@override@JsonKey() List<AuditObservation> get observations {
  if (_observations is EqualUnmodifiableListView) return _observations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_observations);
}


/// Create a copy of AuditCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditCategoryCopyWith<_AuditCategory> get copyWith => __$AuditCategoryCopyWithImpl<_AuditCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditCategory&&(identical(other.auditCategoryId, auditCategoryId) || other.auditCategoryId == auditCategoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.observationsTotal, observationsTotal) || other.observationsTotal == observationsTotal)&&(identical(other.observationsCompleted, observationsCompleted) || other.observationsCompleted == observationsCompleted)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&const DeepCollectionEquality().equals(other._observations, _observations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,auditCategoryId,title,eventId,iconUrl,observationsTotal,observationsCompleted,progressPercent,const DeepCollectionEquality().hash(_observations));

@override
String toString() {
  return 'AuditCategory(auditCategoryId: $auditCategoryId, title: $title, eventId: $eventId, iconUrl: $iconUrl, observationsTotal: $observationsTotal, observationsCompleted: $observationsCompleted, progressPercent: $progressPercent, observations: $observations)';
}


}

/// @nodoc
abstract mixin class _$AuditCategoryCopyWith<$Res> implements $AuditCategoryCopyWith<$Res> {
  factory _$AuditCategoryCopyWith(_AuditCategory value, $Res Function(_AuditCategory) _then) = __$AuditCategoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'audit_category_id') int auditCategoryId, String title,@JsonKey(name: 'event_id') int? eventId,@JsonKey(name: 'icon_url') String? iconUrl,@JsonKey(name: 'observations_total') int observationsTotal,@JsonKey(name: 'observations_completed') int observationsCompleted,@JsonKey(name: 'progress_percent') int progressPercent, List<AuditObservation> observations
});




}
/// @nodoc
class __$AuditCategoryCopyWithImpl<$Res>
    implements _$AuditCategoryCopyWith<$Res> {
  __$AuditCategoryCopyWithImpl(this._self, this._then);

  final _AuditCategory _self;
  final $Res Function(_AuditCategory) _then;

/// Create a copy of AuditCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? auditCategoryId = null,Object? title = null,Object? eventId = freezed,Object? iconUrl = freezed,Object? observationsTotal = null,Object? observationsCompleted = null,Object? progressPercent = null,Object? observations = null,}) {
  return _then(_AuditCategory(
auditCategoryId: null == auditCategoryId ? _self.auditCategoryId : auditCategoryId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,eventId: freezed == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as int?,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,observationsTotal: null == observationsTotal ? _self.observationsTotal : observationsTotal // ignore: cast_nullable_to_non_nullable
as int,observationsCompleted: null == observationsCompleted ? _self.observationsCompleted : observationsCompleted // ignore: cast_nullable_to_non_nullable
as int,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,observations: null == observations ? _self._observations : observations // ignore: cast_nullable_to_non_nullable
as List<AuditObservation>,
  ));
}


}


/// @nodoc
mixin _$AuditObservation {

@JsonKey(name: 'audit_observation_id') int get auditObservationId; String get name;@JsonKey(name: 'result_id') int? get resultId;@JsonKey(name: 'audit_category_id') int? get auditCategoryId;@JsonKey(name: 'is_draft') bool? get isDraft;@JsonKey(name: 'is_completed') bool get isCompleted;/// `compliant` / `non_compliant` / `na` — null until submitted.
 String? get finding; String? get note;@JsonKey(name: 'has_note') bool get hasNote;@JsonKey(name: 'submitted_at') DateTime? get submittedAt;@JsonKey(name: 'submitted_by') AuditClient? get submittedBy;@JsonKey(name: 'files_count') int get filesCount;@JsonKey(name: 'photos_count') int get photosCount;@JsonKey(name: 'videos_count') int get videosCount;@JsonKey(name: 'documents_count') int get documentsCount; List<AuditFile> get files;
/// Create a copy of AuditObservation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditObservationCopyWith<AuditObservation> get copyWith => _$AuditObservationCopyWithImpl<AuditObservation>(this as AuditObservation, _$identity);

  /// Serializes this AuditObservation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditObservation&&(identical(other.auditObservationId, auditObservationId) || other.auditObservationId == auditObservationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.resultId, resultId) || other.resultId == resultId)&&(identical(other.auditCategoryId, auditCategoryId) || other.auditCategoryId == auditCategoryId)&&(identical(other.isDraft, isDraft) || other.isDraft == isDraft)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.finding, finding) || other.finding == finding)&&(identical(other.note, note) || other.note == note)&&(identical(other.hasNote, hasNote) || other.hasNote == hasNote)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.submittedBy, submittedBy) || other.submittedBy == submittedBy)&&(identical(other.filesCount, filesCount) || other.filesCount == filesCount)&&(identical(other.photosCount, photosCount) || other.photosCount == photosCount)&&(identical(other.videosCount, videosCount) || other.videosCount == videosCount)&&(identical(other.documentsCount, documentsCount) || other.documentsCount == documentsCount)&&const DeepCollectionEquality().equals(other.files, files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,auditObservationId,name,resultId,auditCategoryId,isDraft,isCompleted,finding,note,hasNote,submittedAt,submittedBy,filesCount,photosCount,videosCount,documentsCount,const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'AuditObservation(auditObservationId: $auditObservationId, name: $name, resultId: $resultId, auditCategoryId: $auditCategoryId, isDraft: $isDraft, isCompleted: $isCompleted, finding: $finding, note: $note, hasNote: $hasNote, submittedAt: $submittedAt, submittedBy: $submittedBy, filesCount: $filesCount, photosCount: $photosCount, videosCount: $videosCount, documentsCount: $documentsCount, files: $files)';
}


}

/// @nodoc
abstract mixin class $AuditObservationCopyWith<$Res>  {
  factory $AuditObservationCopyWith(AuditObservation value, $Res Function(AuditObservation) _then) = _$AuditObservationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'audit_observation_id') int auditObservationId, String name,@JsonKey(name: 'result_id') int? resultId,@JsonKey(name: 'audit_category_id') int? auditCategoryId,@JsonKey(name: 'is_draft') bool? isDraft,@JsonKey(name: 'is_completed') bool isCompleted, String? finding, String? note,@JsonKey(name: 'has_note') bool hasNote,@JsonKey(name: 'submitted_at') DateTime? submittedAt,@JsonKey(name: 'submitted_by') AuditClient? submittedBy,@JsonKey(name: 'files_count') int filesCount,@JsonKey(name: 'photos_count') int photosCount,@JsonKey(name: 'videos_count') int videosCount,@JsonKey(name: 'documents_count') int documentsCount, List<AuditFile> files
});


$AuditClientCopyWith<$Res>? get submittedBy;

}
/// @nodoc
class _$AuditObservationCopyWithImpl<$Res>
    implements $AuditObservationCopyWith<$Res> {
  _$AuditObservationCopyWithImpl(this._self, this._then);

  final AuditObservation _self;
  final $Res Function(AuditObservation) _then;

/// Create a copy of AuditObservation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? auditObservationId = null,Object? name = null,Object? resultId = freezed,Object? auditCategoryId = freezed,Object? isDraft = freezed,Object? isCompleted = null,Object? finding = freezed,Object? note = freezed,Object? hasNote = null,Object? submittedAt = freezed,Object? submittedBy = freezed,Object? filesCount = null,Object? photosCount = null,Object? videosCount = null,Object? documentsCount = null,Object? files = null,}) {
  return _then(_self.copyWith(
auditObservationId: null == auditObservationId ? _self.auditObservationId : auditObservationId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,resultId: freezed == resultId ? _self.resultId : resultId // ignore: cast_nullable_to_non_nullable
as int?,auditCategoryId: freezed == auditCategoryId ? _self.auditCategoryId : auditCategoryId // ignore: cast_nullable_to_non_nullable
as int?,isDraft: freezed == isDraft ? _self.isDraft : isDraft // ignore: cast_nullable_to_non_nullable
as bool?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,finding: freezed == finding ? _self.finding : finding // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,hasNote: null == hasNote ? _self.hasNote : hasNote // ignore: cast_nullable_to_non_nullable
as bool,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedBy: freezed == submittedBy ? _self.submittedBy : submittedBy // ignore: cast_nullable_to_non_nullable
as AuditClient?,filesCount: null == filesCount ? _self.filesCount : filesCount // ignore: cast_nullable_to_non_nullable
as int,photosCount: null == photosCount ? _self.photosCount : photosCount // ignore: cast_nullable_to_non_nullable
as int,videosCount: null == videosCount ? _self.videosCount : videosCount // ignore: cast_nullable_to_non_nullable
as int,documentsCount: null == documentsCount ? _self.documentsCount : documentsCount // ignore: cast_nullable_to_non_nullable
as int,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<AuditFile>,
  ));
}
/// Create a copy of AuditObservation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuditClientCopyWith<$Res>? get submittedBy {
    if (_self.submittedBy == null) {
    return null;
  }

  return $AuditClientCopyWith<$Res>(_self.submittedBy!, (value) {
    return _then(_self.copyWith(submittedBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuditObservation].
extension AuditObservationPatterns on AuditObservation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditObservation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditObservation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditObservation value)  $default,){
final _that = this;
switch (_that) {
case _AuditObservation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditObservation value)?  $default,){
final _that = this;
switch (_that) {
case _AuditObservation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'audit_observation_id')  int auditObservationId,  String name, @JsonKey(name: 'result_id')  int? resultId, @JsonKey(name: 'audit_category_id')  int? auditCategoryId, @JsonKey(name: 'is_draft')  bool? isDraft, @JsonKey(name: 'is_completed')  bool isCompleted,  String? finding,  String? note, @JsonKey(name: 'has_note')  bool hasNote, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'submitted_by')  AuditClient? submittedBy, @JsonKey(name: 'files_count')  int filesCount, @JsonKey(name: 'photos_count')  int photosCount, @JsonKey(name: 'videos_count')  int videosCount, @JsonKey(name: 'documents_count')  int documentsCount,  List<AuditFile> files)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditObservation() when $default != null:
return $default(_that.auditObservationId,_that.name,_that.resultId,_that.auditCategoryId,_that.isDraft,_that.isCompleted,_that.finding,_that.note,_that.hasNote,_that.submittedAt,_that.submittedBy,_that.filesCount,_that.photosCount,_that.videosCount,_that.documentsCount,_that.files);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'audit_observation_id')  int auditObservationId,  String name, @JsonKey(name: 'result_id')  int? resultId, @JsonKey(name: 'audit_category_id')  int? auditCategoryId, @JsonKey(name: 'is_draft')  bool? isDraft, @JsonKey(name: 'is_completed')  bool isCompleted,  String? finding,  String? note, @JsonKey(name: 'has_note')  bool hasNote, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'submitted_by')  AuditClient? submittedBy, @JsonKey(name: 'files_count')  int filesCount, @JsonKey(name: 'photos_count')  int photosCount, @JsonKey(name: 'videos_count')  int videosCount, @JsonKey(name: 'documents_count')  int documentsCount,  List<AuditFile> files)  $default,) {final _that = this;
switch (_that) {
case _AuditObservation():
return $default(_that.auditObservationId,_that.name,_that.resultId,_that.auditCategoryId,_that.isDraft,_that.isCompleted,_that.finding,_that.note,_that.hasNote,_that.submittedAt,_that.submittedBy,_that.filesCount,_that.photosCount,_that.videosCount,_that.documentsCount,_that.files);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'audit_observation_id')  int auditObservationId,  String name, @JsonKey(name: 'result_id')  int? resultId, @JsonKey(name: 'audit_category_id')  int? auditCategoryId, @JsonKey(name: 'is_draft')  bool? isDraft, @JsonKey(name: 'is_completed')  bool isCompleted,  String? finding,  String? note, @JsonKey(name: 'has_note')  bool hasNote, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'submitted_by')  AuditClient? submittedBy, @JsonKey(name: 'files_count')  int filesCount, @JsonKey(name: 'photos_count')  int photosCount, @JsonKey(name: 'videos_count')  int videosCount, @JsonKey(name: 'documents_count')  int documentsCount,  List<AuditFile> files)?  $default,) {final _that = this;
switch (_that) {
case _AuditObservation() when $default != null:
return $default(_that.auditObservationId,_that.name,_that.resultId,_that.auditCategoryId,_that.isDraft,_that.isCompleted,_that.finding,_that.note,_that.hasNote,_that.submittedAt,_that.submittedBy,_that.filesCount,_that.photosCount,_that.videosCount,_that.documentsCount,_that.files);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditObservation extends AuditObservation {
  const _AuditObservation({@JsonKey(name: 'audit_observation_id') required this.auditObservationId, required this.name, @JsonKey(name: 'result_id') this.resultId, @JsonKey(name: 'audit_category_id') this.auditCategoryId, @JsonKey(name: 'is_draft') this.isDraft, @JsonKey(name: 'is_completed') this.isCompleted = false, this.finding, this.note, @JsonKey(name: 'has_note') this.hasNote = false, @JsonKey(name: 'submitted_at') this.submittedAt, @JsonKey(name: 'submitted_by') this.submittedBy, @JsonKey(name: 'files_count') this.filesCount = 0, @JsonKey(name: 'photos_count') this.photosCount = 0, @JsonKey(name: 'videos_count') this.videosCount = 0, @JsonKey(name: 'documents_count') this.documentsCount = 0, final  List<AuditFile> files = const <AuditFile>[]}): _files = files,super._();
  factory _AuditObservation.fromJson(Map<String, dynamic> json) => _$AuditObservationFromJson(json);

@override@JsonKey(name: 'audit_observation_id') final  int auditObservationId;
@override final  String name;
@override@JsonKey(name: 'result_id') final  int? resultId;
@override@JsonKey(name: 'audit_category_id') final  int? auditCategoryId;
@override@JsonKey(name: 'is_draft') final  bool? isDraft;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;
/// `compliant` / `non_compliant` / `na` — null until submitted.
@override final  String? finding;
@override final  String? note;
@override@JsonKey(name: 'has_note') final  bool hasNote;
@override@JsonKey(name: 'submitted_at') final  DateTime? submittedAt;
@override@JsonKey(name: 'submitted_by') final  AuditClient? submittedBy;
@override@JsonKey(name: 'files_count') final  int filesCount;
@override@JsonKey(name: 'photos_count') final  int photosCount;
@override@JsonKey(name: 'videos_count') final  int videosCount;
@override@JsonKey(name: 'documents_count') final  int documentsCount;
 final  List<AuditFile> _files;
@override@JsonKey() List<AuditFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of AuditObservation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditObservationCopyWith<_AuditObservation> get copyWith => __$AuditObservationCopyWithImpl<_AuditObservation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditObservationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditObservation&&(identical(other.auditObservationId, auditObservationId) || other.auditObservationId == auditObservationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.resultId, resultId) || other.resultId == resultId)&&(identical(other.auditCategoryId, auditCategoryId) || other.auditCategoryId == auditCategoryId)&&(identical(other.isDraft, isDraft) || other.isDraft == isDraft)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.finding, finding) || other.finding == finding)&&(identical(other.note, note) || other.note == note)&&(identical(other.hasNote, hasNote) || other.hasNote == hasNote)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.submittedBy, submittedBy) || other.submittedBy == submittedBy)&&(identical(other.filesCount, filesCount) || other.filesCount == filesCount)&&(identical(other.photosCount, photosCount) || other.photosCount == photosCount)&&(identical(other.videosCount, videosCount) || other.videosCount == videosCount)&&(identical(other.documentsCount, documentsCount) || other.documentsCount == documentsCount)&&const DeepCollectionEquality().equals(other._files, _files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,auditObservationId,name,resultId,auditCategoryId,isDraft,isCompleted,finding,note,hasNote,submittedAt,submittedBy,filesCount,photosCount,videosCount,documentsCount,const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'AuditObservation(auditObservationId: $auditObservationId, name: $name, resultId: $resultId, auditCategoryId: $auditCategoryId, isDraft: $isDraft, isCompleted: $isCompleted, finding: $finding, note: $note, hasNote: $hasNote, submittedAt: $submittedAt, submittedBy: $submittedBy, filesCount: $filesCount, photosCount: $photosCount, videosCount: $videosCount, documentsCount: $documentsCount, files: $files)';
}


}

/// @nodoc
abstract mixin class _$AuditObservationCopyWith<$Res> implements $AuditObservationCopyWith<$Res> {
  factory _$AuditObservationCopyWith(_AuditObservation value, $Res Function(_AuditObservation) _then) = __$AuditObservationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'audit_observation_id') int auditObservationId, String name,@JsonKey(name: 'result_id') int? resultId,@JsonKey(name: 'audit_category_id') int? auditCategoryId,@JsonKey(name: 'is_draft') bool? isDraft,@JsonKey(name: 'is_completed') bool isCompleted, String? finding, String? note,@JsonKey(name: 'has_note') bool hasNote,@JsonKey(name: 'submitted_at') DateTime? submittedAt,@JsonKey(name: 'submitted_by') AuditClient? submittedBy,@JsonKey(name: 'files_count') int filesCount,@JsonKey(name: 'photos_count') int photosCount,@JsonKey(name: 'videos_count') int videosCount,@JsonKey(name: 'documents_count') int documentsCount, List<AuditFile> files
});


@override $AuditClientCopyWith<$Res>? get submittedBy;

}
/// @nodoc
class __$AuditObservationCopyWithImpl<$Res>
    implements _$AuditObservationCopyWith<$Res> {
  __$AuditObservationCopyWithImpl(this._self, this._then);

  final _AuditObservation _self;
  final $Res Function(_AuditObservation) _then;

/// Create a copy of AuditObservation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? auditObservationId = null,Object? name = null,Object? resultId = freezed,Object? auditCategoryId = freezed,Object? isDraft = freezed,Object? isCompleted = null,Object? finding = freezed,Object? note = freezed,Object? hasNote = null,Object? submittedAt = freezed,Object? submittedBy = freezed,Object? filesCount = null,Object? photosCount = null,Object? videosCount = null,Object? documentsCount = null,Object? files = null,}) {
  return _then(_AuditObservation(
auditObservationId: null == auditObservationId ? _self.auditObservationId : auditObservationId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,resultId: freezed == resultId ? _self.resultId : resultId // ignore: cast_nullable_to_non_nullable
as int?,auditCategoryId: freezed == auditCategoryId ? _self.auditCategoryId : auditCategoryId // ignore: cast_nullable_to_non_nullable
as int?,isDraft: freezed == isDraft ? _self.isDraft : isDraft // ignore: cast_nullable_to_non_nullable
as bool?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,finding: freezed == finding ? _self.finding : finding // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,hasNote: null == hasNote ? _self.hasNote : hasNote // ignore: cast_nullable_to_non_nullable
as bool,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedBy: freezed == submittedBy ? _self.submittedBy : submittedBy // ignore: cast_nullable_to_non_nullable
as AuditClient?,filesCount: null == filesCount ? _self.filesCount : filesCount // ignore: cast_nullable_to_non_nullable
as int,photosCount: null == photosCount ? _self.photosCount : photosCount // ignore: cast_nullable_to_non_nullable
as int,videosCount: null == videosCount ? _self.videosCount : videosCount // ignore: cast_nullable_to_non_nullable
as int,documentsCount: null == documentsCount ? _self.documentsCount : documentsCount // ignore: cast_nullable_to_non_nullable
as int,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<AuditFile>,
  ));
}

/// Create a copy of AuditObservation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuditClientCopyWith<$Res>? get submittedBy {
    if (_self.submittedBy == null) {
    return null;
  }

  return $AuditClientCopyWith<$Res>(_self.submittedBy!, (value) {
    return _then(_self.copyWith(submittedBy: value));
  });
}
}


/// @nodoc
mixin _$AuditFile {

 int get id; String get url;/// `photo` / `video` / `document`.
 String get type; String get name; String? get extension;@JsonKey(name: 'mime_type') String? get mimeType; int? get size;
/// Create a copy of AuditFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditFileCopyWith<AuditFile> get copyWith => _$AuditFileCopyWithImpl<AuditFile>(this as AuditFile, _$identity);

  /// Serializes this AuditFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditFile&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,type,name,extension,mimeType,size);

@override
String toString() {
  return 'AuditFile(id: $id, url: $url, type: $type, name: $name, extension: $extension, mimeType: $mimeType, size: $size)';
}


}

/// @nodoc
abstract mixin class $AuditFileCopyWith<$Res>  {
  factory $AuditFileCopyWith(AuditFile value, $Res Function(AuditFile) _then) = _$AuditFileCopyWithImpl;
@useResult
$Res call({
 int id, String url, String type, String name, String? extension,@JsonKey(name: 'mime_type') String? mimeType, int? size
});




}
/// @nodoc
class _$AuditFileCopyWithImpl<$Res>
    implements $AuditFileCopyWith<$Res> {
  _$AuditFileCopyWithImpl(this._self, this._then);

  final AuditFile _self;
  final $Res Function(AuditFile) _then;

/// Create a copy of AuditFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? type = null,Object? name = null,Object? extension = freezed,Object? mimeType = freezed,Object? size = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,extension: freezed == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditFile].
extension AuditFilePatterns on AuditFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditFile value)  $default,){
final _that = this;
switch (_that) {
case _AuditFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditFile value)?  $default,){
final _that = this;
switch (_that) {
case _AuditFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String url,  String type,  String name,  String? extension, @JsonKey(name: 'mime_type')  String? mimeType,  int? size)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditFile() when $default != null:
return $default(_that.id,_that.url,_that.type,_that.name,_that.extension,_that.mimeType,_that.size);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String url,  String type,  String name,  String? extension, @JsonKey(name: 'mime_type')  String? mimeType,  int? size)  $default,) {final _that = this;
switch (_that) {
case _AuditFile():
return $default(_that.id,_that.url,_that.type,_that.name,_that.extension,_that.mimeType,_that.size);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String url,  String type,  String name,  String? extension, @JsonKey(name: 'mime_type')  String? mimeType,  int? size)?  $default,) {final _that = this;
switch (_that) {
case _AuditFile() when $default != null:
return $default(_that.id,_that.url,_that.type,_that.name,_that.extension,_that.mimeType,_that.size);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditFile extends AuditFile {
  const _AuditFile({required this.id, required this.url, required this.type, required this.name, this.extension, @JsonKey(name: 'mime_type') this.mimeType, this.size}): super._();
  factory _AuditFile.fromJson(Map<String, dynamic> json) => _$AuditFileFromJson(json);

@override final  int id;
@override final  String url;
/// `photo` / `video` / `document`.
@override final  String type;
@override final  String name;
@override final  String? extension;
@override@JsonKey(name: 'mime_type') final  String? mimeType;
@override final  int? size;

/// Create a copy of AuditFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditFileCopyWith<_AuditFile> get copyWith => __$AuditFileCopyWithImpl<_AuditFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditFile&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,type,name,extension,mimeType,size);

@override
String toString() {
  return 'AuditFile(id: $id, url: $url, type: $type, name: $name, extension: $extension, mimeType: $mimeType, size: $size)';
}


}

/// @nodoc
abstract mixin class _$AuditFileCopyWith<$Res> implements $AuditFileCopyWith<$Res> {
  factory _$AuditFileCopyWith(_AuditFile value, $Res Function(_AuditFile) _then) = __$AuditFileCopyWithImpl;
@override @useResult
$Res call({
 int id, String url, String type, String name, String? extension,@JsonKey(name: 'mime_type') String? mimeType, int? size
});




}
/// @nodoc
class __$AuditFileCopyWithImpl<$Res>
    implements _$AuditFileCopyWith<$Res> {
  __$AuditFileCopyWithImpl(this._self, this._then);

  final _AuditFile _self;
  final $Res Function(_AuditFile) _then;

/// Create a copy of AuditFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? type = null,Object? name = null,Object? extension = freezed,Object? mimeType = freezed,Object? size = freezed,}) {
  return _then(_AuditFile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,extension: freezed == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
