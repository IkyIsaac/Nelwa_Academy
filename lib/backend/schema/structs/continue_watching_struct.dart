// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ContinueWatchingStruct extends FFFirebaseStruct {
  ContinueWatchingStruct({
    DocumentReference? courses,
    List<DocumentReference>? completedLessons,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _courses = courses,
        _completedLessons = completedLessons,
        super(firestoreUtilData);

  // "courses" field.
  DocumentReference? _courses;
  DocumentReference? get courses => _courses;
  set courses(DocumentReference? val) => _courses = val;

  bool hasCourses() => _courses != null;

  // "completed_lessons" field.
  List<DocumentReference>? _completedLessons;
  List<DocumentReference> get completedLessons => _completedLessons ?? const [];
  set completedLessons(List<DocumentReference>? val) => _completedLessons = val;

  void updateCompletedLessons(Function(List<DocumentReference>) updateFn) {
    updateFn(_completedLessons ??= []);
  }

  bool hasCompletedLessons() => _completedLessons != null;

  static ContinueWatchingStruct fromMap(Map<String, dynamic> data) =>
      ContinueWatchingStruct(
        courses: data['courses'] as DocumentReference?,
        completedLessons: getDataList(data['completed_lessons']),
      );

  static ContinueWatchingStruct? maybeFromMap(dynamic data) => data is Map
      ? ContinueWatchingStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'courses': _courses,
        'completed_lessons': _completedLessons,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'courses': serializeParam(
          _courses,
          ParamType.DocumentReference,
        ),
        'completed_lessons': serializeParam(
          _completedLessons,
          ParamType.DocumentReference,
          isList: true,
        ),
      }.withoutNulls;

  static ContinueWatchingStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ContinueWatchingStruct(
        courses: deserializeParam(
          data['courses'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['courses'],
        ),
        completedLessons: deserializeParam<DocumentReference>(
          data['completed_lessons'],
          ParamType.DocumentReference,
          true,
          collectionNamePath: ['courses', 'lessons'],
        ),
      );

  @override
  String toString() => 'ContinueWatchingStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ContinueWatchingStruct &&
        courses == other.courses &&
        listEquality.equals(completedLessons, other.completedLessons);
  }

  @override
  int get hashCode => const ListEquality().hash([courses, completedLessons]);
}

ContinueWatchingStruct createContinueWatchingStruct({
  DocumentReference? courses,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ContinueWatchingStruct(
      courses: courses,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ContinueWatchingStruct? updateContinueWatchingStruct(
  ContinueWatchingStruct? continueWatching, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    continueWatching
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addContinueWatchingStructData(
  Map<String, dynamic> firestoreData,
  ContinueWatchingStruct? continueWatching,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (continueWatching == null) {
    return;
  }
  if (continueWatching.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && continueWatching.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final continueWatchingData =
      getContinueWatchingFirestoreData(continueWatching, forFieldValue);
  final nestedData =
      continueWatchingData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = continueWatching.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getContinueWatchingFirestoreData(
  ContinueWatchingStruct? continueWatching, [
  bool forFieldValue = false,
]) {
  if (continueWatching == null) {
    return {};
  }
  final firestoreData = mapToFirestore(continueWatching.toMap());

  // Add any Firestore field values
  mapToFirestore(continueWatching.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getContinueWatchingListFirestoreData(
  List<ContinueWatchingStruct>? continueWatchings,
) =>
    continueWatchings
        ?.map((e) => getContinueWatchingFirestoreData(e, true))
        .toList() ??
    [];
