// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class LanguageStruct extends FFFirebaseStruct {
  LanguageStruct({
    String? language,
    String? flag,
    String? langCode,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _language = language,
        _flag = flag,
        _langCode = langCode,
        super(firestoreUtilData);

  // "language" field.
  String? _language;
  String get language => _language ?? '';
  set language(String? val) => _language = val;

  bool hasLanguage() => _language != null;

  // "flag" field.
  String? _flag;
  String get flag => _flag ?? '';
  set flag(String? val) => _flag = val;

  bool hasFlag() => _flag != null;

  // "lang_code" field.
  String? _langCode;
  String get langCode => _langCode ?? '';
  set langCode(String? val) => _langCode = val;

  bool hasLangCode() => _langCode != null;

  static LanguageStruct fromMap(Map<String, dynamic> data) => LanguageStruct(
        language: data['language'] as String?,
        flag: data['flag'] as String?,
        langCode: data['lang_code'] as String?,
      );

  static LanguageStruct? maybeFromMap(dynamic data) =>
      data is Map ? LanguageStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'language': _language,
        'flag': _flag,
        'lang_code': _langCode,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'language': serializeParam(
          _language,
          ParamType.String,
        ),
        'flag': serializeParam(
          _flag,
          ParamType.String,
        ),
        'lang_code': serializeParam(
          _langCode,
          ParamType.String,
        ),
      }.withoutNulls;

  static LanguageStruct fromSerializableMap(Map<String, dynamic> data) =>
      LanguageStruct(
        language: deserializeParam(
          data['language'],
          ParamType.String,
          false,
        ),
        flag: deserializeParam(
          data['flag'],
          ParamType.String,
          false,
        ),
        langCode: deserializeParam(
          data['lang_code'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'LanguageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LanguageStruct &&
        language == other.language &&
        flag == other.flag &&
        langCode == other.langCode;
  }

  @override
  int get hashCode => const ListEquality().hash([language, flag, langCode]);
}

LanguageStruct createLanguageStruct({
  String? language,
  String? flag,
  String? langCode,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    LanguageStruct(
      language: language,
      flag: flag,
      langCode: langCode,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

LanguageStruct? updateLanguageStruct(
  LanguageStruct? languageStruct, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    languageStruct
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addLanguageStructData(
  Map<String, dynamic> firestoreData,
  LanguageStruct? languageStruct,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (languageStruct == null) {
    return;
  }
  if (languageStruct.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && languageStruct.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final languageStructData =
      getLanguageFirestoreData(languageStruct, forFieldValue);
  final nestedData =
      languageStructData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = languageStruct.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getLanguageFirestoreData(
  LanguageStruct? languageStruct, [
  bool forFieldValue = false,
]) {
  if (languageStruct == null) {
    return {};
  }
  final firestoreData = mapToFirestore(languageStruct.toMap());

  // Add any Firestore field values
  mapToFirestore(languageStruct.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getLanguageListFirestoreData(
  List<LanguageStruct>? languageStructs,
) =>
    languageStructs?.map((e) => getLanguageFirestoreData(e, true)).toList() ??
    [];
