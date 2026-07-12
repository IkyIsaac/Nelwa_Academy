// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReminderStruct extends FFFirebaseStruct {
  ReminderStruct({
    List<String>? days,
    bool? active,
    DocumentReference? purchasedCoursesRef,
    String? hour,
    String? minut,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _days = days,
        _active = active,
        _purchasedCoursesRef = purchasedCoursesRef,
        _hour = hour,
        _minut = minut,
        super(firestoreUtilData);

  // "days" field.
  List<String>? _days;
  List<String> get days => _days ?? const [];
  set days(List<String>? val) => _days = val;

  void updateDays(Function(List<String>) updateFn) {
    updateFn(_days ??= []);
  }

  bool hasDays() => _days != null;

  // "active" field.
  bool? _active;
  bool get active => _active ?? false;
  set active(bool? val) => _active = val;

  bool hasActive() => _active != null;

  // "purchased_courses_ref" field.
  DocumentReference? _purchasedCoursesRef;
  DocumentReference? get purchasedCoursesRef => _purchasedCoursesRef;
  set purchasedCoursesRef(DocumentReference? val) => _purchasedCoursesRef = val;

  bool hasPurchasedCoursesRef() => _purchasedCoursesRef != null;

  // "hour" field.
  String? _hour;
  String get hour => _hour ?? '';
  set hour(String? val) => _hour = val;

  bool hasHour() => _hour != null;

  // "minut" field.
  String? _minut;
  String get minut => _minut ?? '';
  set minut(String? val) => _minut = val;

  bool hasMinut() => _minut != null;

  static ReminderStruct fromMap(Map<String, dynamic> data) => ReminderStruct(
        days: getDataList(data['days']),
        active: data['active'] as bool?,
        purchasedCoursesRef:
            data['purchased_courses_ref'] as DocumentReference?,
        hour: data['hour'] as String?,
        minut: data['minut'] as String?,
      );

  static ReminderStruct? maybeFromMap(dynamic data) =>
      data is Map ? ReminderStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'days': _days,
        'active': _active,
        'purchased_courses_ref': _purchasedCoursesRef,
        'hour': _hour,
        'minut': _minut,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'days': serializeParam(
          _days,
          ParamType.String,
          isList: true,
        ),
        'active': serializeParam(
          _active,
          ParamType.bool,
        ),
        'purchased_courses_ref': serializeParam(
          _purchasedCoursesRef,
          ParamType.DocumentReference,
        ),
        'hour': serializeParam(
          _hour,
          ParamType.String,
        ),
        'minut': serializeParam(
          _minut,
          ParamType.String,
        ),
      }.withoutNulls;

  static ReminderStruct fromSerializableMap(Map<String, dynamic> data) =>
      ReminderStruct(
        days: deserializeParam<String>(
          data['days'],
          ParamType.String,
          true,
        ),
        active: deserializeParam(
          data['active'],
          ParamType.bool,
          false,
        ),
        purchasedCoursesRef: deserializeParam(
          data['purchased_courses_ref'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['users', 'purchased_courses'],
        ),
        hour: deserializeParam(
          data['hour'],
          ParamType.String,
          false,
        ),
        minut: deserializeParam(
          data['minut'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ReminderStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ReminderStruct &&
        listEquality.equals(days, other.days) &&
        active == other.active &&
        purchasedCoursesRef == other.purchasedCoursesRef &&
        hour == other.hour &&
        minut == other.minut;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([days, active, purchasedCoursesRef, hour, minut]);
}

ReminderStruct createReminderStruct({
  bool? active,
  DocumentReference? purchasedCoursesRef,
  String? hour,
  String? minut,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ReminderStruct(
      active: active,
      purchasedCoursesRef: purchasedCoursesRef,
      hour: hour,
      minut: minut,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ReminderStruct? updateReminderStruct(
  ReminderStruct? reminder, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    reminder
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addReminderStructData(
  Map<String, dynamic> firestoreData,
  ReminderStruct? reminder,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (reminder == null) {
    return;
  }
  if (reminder.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && reminder.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final reminderData = getReminderFirestoreData(reminder, forFieldValue);
  final nestedData = reminderData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = reminder.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getReminderFirestoreData(
  ReminderStruct? reminder, [
  bool forFieldValue = false,
]) {
  if (reminder == null) {
    return {};
  }
  final firestoreData = mapToFirestore(reminder.toMap());

  // Add any Firestore field values
  mapToFirestore(reminder.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getReminderListFirestoreData(
  List<ReminderStruct>? reminders,
) =>
    reminders?.map((e) => getReminderFirestoreData(e, true)).toList() ?? [];
