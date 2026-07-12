// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class FilterStruct extends FFFirebaseStruct {
  FilterStruct({
    double? rating,
    double? start,
    double? end,
    String? skillLevel,
    String? dateAdded,
    int? durationFrom,
    int? durationTo,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _rating = rating,
        _start = start,
        _end = end,
        _skillLevel = skillLevel,
        _dateAdded = dateAdded,
        _durationFrom = durationFrom,
        _durationTo = durationTo,
        super(firestoreUtilData);

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  set rating(double? val) => _rating = val;

  void incrementRating(double amount) => rating = rating + amount;

  bool hasRating() => _rating != null;

  // "start" field.
  double? _start;
  double get start => _start ?? 0.0;
  set start(double? val) => _start = val;

  void incrementStart(double amount) => start = start + amount;

  bool hasStart() => _start != null;

  // "end" field.
  double? _end;
  double get end => _end ?? 0.0;
  set end(double? val) => _end = val;

  void incrementEnd(double amount) => end = end + amount;

  bool hasEnd() => _end != null;

  // "skillLevel" field.
  String? _skillLevel;
  String get skillLevel => _skillLevel ?? '';
  set skillLevel(String? val) => _skillLevel = val;

  bool hasSkillLevel() => _skillLevel != null;

  // "dateAdded" field.
  String? _dateAdded;
  String get dateAdded => _dateAdded ?? '';
  set dateAdded(String? val) => _dateAdded = val;

  bool hasDateAdded() => _dateAdded != null;

  // "durationFrom" field.
  int? _durationFrom;
  int get durationFrom => _durationFrom ?? 0;
  set durationFrom(int? val) => _durationFrom = val;

  void incrementDurationFrom(int amount) =>
      durationFrom = durationFrom + amount;

  bool hasDurationFrom() => _durationFrom != null;

  // "durationTo" field.
  int? _durationTo;
  int get durationTo => _durationTo ?? 0;
  set durationTo(int? val) => _durationTo = val;

  void incrementDurationTo(int amount) => durationTo = durationTo + amount;

  bool hasDurationTo() => _durationTo != null;

  static FilterStruct fromMap(Map<String, dynamic> data) => FilterStruct(
        rating: castToType<double>(data['rating']),
        start: castToType<double>(data['start']),
        end: castToType<double>(data['end']),
        skillLevel: data['skillLevel'] as String?,
        dateAdded: data['dateAdded'] as String?,
        durationFrom: castToType<int>(data['durationFrom']),
        durationTo: castToType<int>(data['durationTo']),
      );

  static FilterStruct? maybeFromMap(dynamic data) =>
      data is Map ? FilterStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'rating': _rating,
        'start': _start,
        'end': _end,
        'skillLevel': _skillLevel,
        'dateAdded': _dateAdded,
        'durationFrom': _durationFrom,
        'durationTo': _durationTo,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'rating': serializeParam(
          _rating,
          ParamType.double,
        ),
        'start': serializeParam(
          _start,
          ParamType.double,
        ),
        'end': serializeParam(
          _end,
          ParamType.double,
        ),
        'skillLevel': serializeParam(
          _skillLevel,
          ParamType.String,
        ),
        'dateAdded': serializeParam(
          _dateAdded,
          ParamType.String,
        ),
        'durationFrom': serializeParam(
          _durationFrom,
          ParamType.int,
        ),
        'durationTo': serializeParam(
          _durationTo,
          ParamType.int,
        ),
      }.withoutNulls;

  static FilterStruct fromSerializableMap(Map<String, dynamic> data) =>
      FilterStruct(
        rating: deserializeParam(
          data['rating'],
          ParamType.double,
          false,
        ),
        start: deserializeParam(
          data['start'],
          ParamType.double,
          false,
        ),
        end: deserializeParam(
          data['end'],
          ParamType.double,
          false,
        ),
        skillLevel: deserializeParam(
          data['skillLevel'],
          ParamType.String,
          false,
        ),
        dateAdded: deserializeParam(
          data['dateAdded'],
          ParamType.String,
          false,
        ),
        durationFrom: deserializeParam(
          data['durationFrom'],
          ParamType.int,
          false,
        ),
        durationTo: deserializeParam(
          data['durationTo'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'FilterStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FilterStruct &&
        rating == other.rating &&
        start == other.start &&
        end == other.end &&
        skillLevel == other.skillLevel &&
        dateAdded == other.dateAdded &&
        durationFrom == other.durationFrom &&
        durationTo == other.durationTo;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [rating, start, end, skillLevel, dateAdded, durationFrom, durationTo]);
}

FilterStruct createFilterStruct({
  double? rating,
  double? start,
  double? end,
  String? skillLevel,
  String? dateAdded,
  int? durationFrom,
  int? durationTo,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    FilterStruct(
      rating: rating,
      start: start,
      end: end,
      skillLevel: skillLevel,
      dateAdded: dateAdded,
      durationFrom: durationFrom,
      durationTo: durationTo,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

FilterStruct? updateFilterStruct(
  FilterStruct? filter, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    filter
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addFilterStructData(
  Map<String, dynamic> firestoreData,
  FilterStruct? filter,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (filter == null) {
    return;
  }
  if (filter.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && filter.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final filterData = getFilterFirestoreData(filter, forFieldValue);
  final nestedData = filterData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = filter.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getFilterFirestoreData(
  FilterStruct? filter, [
  bool forFieldValue = false,
]) {
  if (filter == null) {
    return {};
  }
  final firestoreData = mapToFirestore(filter.toMap());

  // Add any Firestore field values
  mapToFirestore(filter.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getFilterListFirestoreData(
  List<FilterStruct>? filters,
) =>
    filters?.map((e) => getFilterFirestoreData(e, true)).toList() ?? [];
