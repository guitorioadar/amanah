// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditClient {

 int get id; String get name; String? get email;
/// Create a copy of AuditClient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditClientCopyWith<AuditClient> get copyWith => _$AuditClientCopyWithImpl<AuditClient>(this as AuditClient, _$identity);

  /// Serializes this AuditClient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditClient&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email);

@override
String toString() {
  return 'AuditClient(id: $id, name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class $AuditClientCopyWith<$Res>  {
  factory $AuditClientCopyWith(AuditClient value, $Res Function(AuditClient) _then) = _$AuditClientCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? email
});




}
/// @nodoc
class _$AuditClientCopyWithImpl<$Res>
    implements $AuditClientCopyWith<$Res> {
  _$AuditClientCopyWithImpl(this._self, this._then);

  final AuditClient _self;
  final $Res Function(AuditClient) _then;

/// Create a copy of AuditClient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditClient].
extension AuditClientPatterns on AuditClient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditClient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditClient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditClient value)  $default,){
final _that = this;
switch (_that) {
case _AuditClient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditClient value)?  $default,){
final _that = this;
switch (_that) {
case _AuditClient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditClient() when $default != null:
return $default(_that.id,_that.name,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? email)  $default,) {final _that = this;
switch (_that) {
case _AuditClient():
return $default(_that.id,_that.name,_that.email);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? email)?  $default,) {final _that = this;
switch (_that) {
case _AuditClient() when $default != null:
return $default(_that.id,_that.name,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditClient implements AuditClient {
  const _AuditClient({required this.id, required this.name, this.email});
  factory _AuditClient.fromJson(Map<String, dynamic> json) => _$AuditClientFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? email;

/// Create a copy of AuditClient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditClientCopyWith<_AuditClient> get copyWith => __$AuditClientCopyWithImpl<_AuditClient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditClientToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditClient&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email);

@override
String toString() {
  return 'AuditClient(id: $id, name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class _$AuditClientCopyWith<$Res> implements $AuditClientCopyWith<$Res> {
  factory _$AuditClientCopyWith(_AuditClient value, $Res Function(_AuditClient) _then) = __$AuditClientCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? email
});




}
/// @nodoc
class __$AuditClientCopyWithImpl<$Res>
    implements _$AuditClientCopyWith<$Res> {
  __$AuditClientCopyWithImpl(this._self, this._then);

  final _AuditClient _self;
  final $Res Function(_AuditClient) _then;

/// Create a copy of AuditClient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = freezed,}) {
  return _then(_AuditClient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Audit {

 int get id; String get title;@JsonKey(name: 'audit_no') String? get auditNo;/// Per-item outcome flag (e.g. "missed"). Not the section — kept for detail.
 String? get status;@JsonKey(name: 'audit_type') String? get auditType;/// Industry / category tag chip (e.g. "Agricultural & Meat Processing").
@JsonKey(name: 'category_name') String? get categoryName; AuditClient? get client; String? get location;@JsonKey(name: 'event_date') DateTime? get eventDate;@JsonKey(name: 'is_completed') bool get isCompleted;@JsonKey(name: 'observations_total') int get observationsTotal;@JsonKey(name: 'observations_completed') int get observationsCompleted;@JsonKey(name: 'progress_percent') int get progressPercent;@JsonKey(includeFromJson: false, includeToJson: false) AuditSection get section;
/// Create a copy of Audit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditCopyWith<Audit> get copyWith => _$AuditCopyWithImpl<Audit>(this as Audit, _$identity);

  /// Serializes this Audit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Audit&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.auditNo, auditNo) || other.auditNo == auditNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.auditType, auditType) || other.auditType == auditType)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.client, client) || other.client == client)&&(identical(other.location, location) || other.location == location)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.observationsTotal, observationsTotal) || other.observationsTotal == observationsTotal)&&(identical(other.observationsCompleted, observationsCompleted) || other.observationsCompleted == observationsCompleted)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.section, section) || other.section == section));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,auditNo,status,auditType,categoryName,client,location,eventDate,isCompleted,observationsTotal,observationsCompleted,progressPercent,section);

@override
String toString() {
  return 'Audit(id: $id, title: $title, auditNo: $auditNo, status: $status, auditType: $auditType, categoryName: $categoryName, client: $client, location: $location, eventDate: $eventDate, isCompleted: $isCompleted, observationsTotal: $observationsTotal, observationsCompleted: $observationsCompleted, progressPercent: $progressPercent, section: $section)';
}


}

/// @nodoc
abstract mixin class $AuditCopyWith<$Res>  {
  factory $AuditCopyWith(Audit value, $Res Function(Audit) _then) = _$AuditCopyWithImpl;
@useResult
$Res call({
 int id, String title,@JsonKey(name: 'audit_no') String? auditNo, String? status,@JsonKey(name: 'audit_type') String? auditType,@JsonKey(name: 'category_name') String? categoryName, AuditClient? client, String? location,@JsonKey(name: 'event_date') DateTime? eventDate,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'observations_total') int observationsTotal,@JsonKey(name: 'observations_completed') int observationsCompleted,@JsonKey(name: 'progress_percent') int progressPercent,@JsonKey(includeFromJson: false, includeToJson: false) AuditSection section
});


$AuditClientCopyWith<$Res>? get client;

}
/// @nodoc
class _$AuditCopyWithImpl<$Res>
    implements $AuditCopyWith<$Res> {
  _$AuditCopyWithImpl(this._self, this._then);

  final Audit _self;
  final $Res Function(Audit) _then;

/// Create a copy of Audit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? auditNo = freezed,Object? status = freezed,Object? auditType = freezed,Object? categoryName = freezed,Object? client = freezed,Object? location = freezed,Object? eventDate = freezed,Object? isCompleted = null,Object? observationsTotal = null,Object? observationsCompleted = null,Object? progressPercent = null,Object? section = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,auditNo: freezed == auditNo ? _self.auditNo : auditNo // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,auditType: freezed == auditType ? _self.auditType : auditType // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as AuditClient?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,eventDate: freezed == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,observationsTotal: null == observationsTotal ? _self.observationsTotal : observationsTotal // ignore: cast_nullable_to_non_nullable
as int,observationsCompleted: null == observationsCompleted ? _self.observationsCompleted : observationsCompleted // ignore: cast_nullable_to_non_nullable
as int,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as AuditSection,
  ));
}
/// Create a copy of Audit
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
}
}


/// Adds pattern-matching-related methods to [Audit].
extension AuditPatterns on Audit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Audit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Audit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Audit value)  $default,){
final _that = this;
switch (_that) {
case _Audit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Audit value)?  $default,){
final _that = this;
switch (_that) {
case _Audit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title, @JsonKey(name: 'audit_no')  String? auditNo,  String? status, @JsonKey(name: 'audit_type')  String? auditType, @JsonKey(name: 'category_name')  String? categoryName,  AuditClient? client,  String? location, @JsonKey(name: 'event_date')  DateTime? eventDate, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'observations_total')  int observationsTotal, @JsonKey(name: 'observations_completed')  int observationsCompleted, @JsonKey(name: 'progress_percent')  int progressPercent, @JsonKey(includeFromJson: false, includeToJson: false)  AuditSection section)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Audit() when $default != null:
return $default(_that.id,_that.title,_that.auditNo,_that.status,_that.auditType,_that.categoryName,_that.client,_that.location,_that.eventDate,_that.isCompleted,_that.observationsTotal,_that.observationsCompleted,_that.progressPercent,_that.section);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title, @JsonKey(name: 'audit_no')  String? auditNo,  String? status, @JsonKey(name: 'audit_type')  String? auditType, @JsonKey(name: 'category_name')  String? categoryName,  AuditClient? client,  String? location, @JsonKey(name: 'event_date')  DateTime? eventDate, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'observations_total')  int observationsTotal, @JsonKey(name: 'observations_completed')  int observationsCompleted, @JsonKey(name: 'progress_percent')  int progressPercent, @JsonKey(includeFromJson: false, includeToJson: false)  AuditSection section)  $default,) {final _that = this;
switch (_that) {
case _Audit():
return $default(_that.id,_that.title,_that.auditNo,_that.status,_that.auditType,_that.categoryName,_that.client,_that.location,_that.eventDate,_that.isCompleted,_that.observationsTotal,_that.observationsCompleted,_that.progressPercent,_that.section);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title, @JsonKey(name: 'audit_no')  String? auditNo,  String? status, @JsonKey(name: 'audit_type')  String? auditType, @JsonKey(name: 'category_name')  String? categoryName,  AuditClient? client,  String? location, @JsonKey(name: 'event_date')  DateTime? eventDate, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'observations_total')  int observationsTotal, @JsonKey(name: 'observations_completed')  int observationsCompleted, @JsonKey(name: 'progress_percent')  int progressPercent, @JsonKey(includeFromJson: false, includeToJson: false)  AuditSection section)?  $default,) {final _that = this;
switch (_that) {
case _Audit() when $default != null:
return $default(_that.id,_that.title,_that.auditNo,_that.status,_that.auditType,_that.categoryName,_that.client,_that.location,_that.eventDate,_that.isCompleted,_that.observationsTotal,_that.observationsCompleted,_that.progressPercent,_that.section);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Audit implements Audit {
  const _Audit({required this.id, required this.title, @JsonKey(name: 'audit_no') this.auditNo, this.status, @JsonKey(name: 'audit_type') this.auditType, @JsonKey(name: 'category_name') this.categoryName, this.client, this.location, @JsonKey(name: 'event_date') this.eventDate, @JsonKey(name: 'is_completed') this.isCompleted = false, @JsonKey(name: 'observations_total') this.observationsTotal = 0, @JsonKey(name: 'observations_completed') this.observationsCompleted = 0, @JsonKey(name: 'progress_percent') this.progressPercent = 0, @JsonKey(includeFromJson: false, includeToJson: false) this.section = AuditSection.running});
  factory _Audit.fromJson(Map<String, dynamic> json) => _$AuditFromJson(json);

@override final  int id;
@override final  String title;
@override@JsonKey(name: 'audit_no') final  String? auditNo;
/// Per-item outcome flag (e.g. "missed"). Not the section — kept for detail.
@override final  String? status;
@override@JsonKey(name: 'audit_type') final  String? auditType;
/// Industry / category tag chip (e.g. "Agricultural & Meat Processing").
@override@JsonKey(name: 'category_name') final  String? categoryName;
@override final  AuditClient? client;
@override final  String? location;
@override@JsonKey(name: 'event_date') final  DateTime? eventDate;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;
@override@JsonKey(name: 'observations_total') final  int observationsTotal;
@override@JsonKey(name: 'observations_completed') final  int observationsCompleted;
@override@JsonKey(name: 'progress_percent') final  int progressPercent;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  AuditSection section;

/// Create a copy of Audit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditCopyWith<_Audit> get copyWith => __$AuditCopyWithImpl<_Audit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Audit&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.auditNo, auditNo) || other.auditNo == auditNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.auditType, auditType) || other.auditType == auditType)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.client, client) || other.client == client)&&(identical(other.location, location) || other.location == location)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.observationsTotal, observationsTotal) || other.observationsTotal == observationsTotal)&&(identical(other.observationsCompleted, observationsCompleted) || other.observationsCompleted == observationsCompleted)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.section, section) || other.section == section));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,auditNo,status,auditType,categoryName,client,location,eventDate,isCompleted,observationsTotal,observationsCompleted,progressPercent,section);

@override
String toString() {
  return 'Audit(id: $id, title: $title, auditNo: $auditNo, status: $status, auditType: $auditType, categoryName: $categoryName, client: $client, location: $location, eventDate: $eventDate, isCompleted: $isCompleted, observationsTotal: $observationsTotal, observationsCompleted: $observationsCompleted, progressPercent: $progressPercent, section: $section)';
}


}

/// @nodoc
abstract mixin class _$AuditCopyWith<$Res> implements $AuditCopyWith<$Res> {
  factory _$AuditCopyWith(_Audit value, $Res Function(_Audit) _then) = __$AuditCopyWithImpl;
@override @useResult
$Res call({
 int id, String title,@JsonKey(name: 'audit_no') String? auditNo, String? status,@JsonKey(name: 'audit_type') String? auditType,@JsonKey(name: 'category_name') String? categoryName, AuditClient? client, String? location,@JsonKey(name: 'event_date') DateTime? eventDate,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'observations_total') int observationsTotal,@JsonKey(name: 'observations_completed') int observationsCompleted,@JsonKey(name: 'progress_percent') int progressPercent,@JsonKey(includeFromJson: false, includeToJson: false) AuditSection section
});


@override $AuditClientCopyWith<$Res>? get client;

}
/// @nodoc
class __$AuditCopyWithImpl<$Res>
    implements _$AuditCopyWith<$Res> {
  __$AuditCopyWithImpl(this._self, this._then);

  final _Audit _self;
  final $Res Function(_Audit) _then;

/// Create a copy of Audit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? auditNo = freezed,Object? status = freezed,Object? auditType = freezed,Object? categoryName = freezed,Object? client = freezed,Object? location = freezed,Object? eventDate = freezed,Object? isCompleted = null,Object? observationsTotal = null,Object? observationsCompleted = null,Object? progressPercent = null,Object? section = null,}) {
  return _then(_Audit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,auditNo: freezed == auditNo ? _self.auditNo : auditNo // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,auditType: freezed == auditType ? _self.auditType : auditType // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as AuditClient?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,eventDate: freezed == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,observationsTotal: null == observationsTotal ? _self.observationsTotal : observationsTotal // ignore: cast_nullable_to_non_nullable
as int,observationsCompleted: null == observationsCompleted ? _self.observationsCompleted : observationsCompleted // ignore: cast_nullable_to_non_nullable
as int,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as AuditSection,
  ));
}

/// Create a copy of Audit
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
}
}

// dart format on
