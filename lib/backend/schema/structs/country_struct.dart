// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class CountryStruct extends FFFirebaseStruct {
  CountryStruct({
    String? country,
    String? flag,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _country = country,
        _flag = flag,
        super(firestoreUtilData);

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  set country(String? val) => _country = val;

  bool hasCountry() => _country != null;

  // "flag" field.
  String? _flag;
  String get flag => _flag ?? '';
  set flag(String? val) => _flag = val;

  bool hasFlag() => _flag != null;

  static CountryStruct fromMap(Map<String, dynamic> data) => CountryStruct(
        country: data['country'] as String?,
        flag: data['flag'] as String?,
      );

  static CountryStruct? maybeFromMap(dynamic data) =>
      data is Map ? CountryStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'country': _country,
        'flag': _flag,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'country': serializeParam(
          _country,
          ParamType.String,
        ),
        'flag': serializeParam(
          _flag,
          ParamType.String,
        ),
      }.withoutNulls;

  static CountryStruct fromSerializableMap(Map<String, dynamic> data) =>
      CountryStruct(
        country: deserializeParam(
          data['country'],
          ParamType.String,
          false,
        ),
        flag: deserializeParam(
          data['flag'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CountryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CountryStruct &&
        country == other.country &&
        flag == other.flag;
  }

  @override
  int get hashCode => const ListEquality().hash([country, flag]);
}

CountryStruct createCountryStruct({
  String? country,
  String? flag,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CountryStruct(
      country: country,
      flag: flag,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CountryStruct? updateCountryStruct(
  CountryStruct? countryStruct, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    countryStruct
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCountryStructData(
  Map<String, dynamic> firestoreData,
  CountryStruct? countryStruct,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (countryStruct == null) {
    return;
  }
  if (countryStruct.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && countryStruct.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final countryStructData =
      getCountryFirestoreData(countryStruct, forFieldValue);
  final nestedData =
      countryStructData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = countryStruct.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCountryFirestoreData(
  CountryStruct? countryStruct, [
  bool forFieldValue = false,
]) {
  if (countryStruct == null) {
    return {};
  }
  final firestoreData = mapToFirestore(countryStruct.toMap());

  // Add any Firestore field values
  mapToFirestore(countryStruct.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCountryListFirestoreData(
  List<CountryStruct>? countryStructs,
) =>
    countryStructs?.map((e) => getCountryFirestoreData(e, true)).toList() ?? [];
