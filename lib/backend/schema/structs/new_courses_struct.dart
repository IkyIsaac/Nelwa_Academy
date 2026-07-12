// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NewCoursesStruct extends FFFirebaseStruct {
  NewCoursesStruct({
    String? coverPhoto,
    String? courseName,
    String? description,
    String? preview,
    String? category,
    List<String>? tags,
    List<String>? courseAudience,
    LanguageStruct? language,
    double? price,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _coverPhoto = coverPhoto,
        _courseName = courseName,
        _description = description,
        _preview = preview,
        _category = category,
        _tags = tags,
        _courseAudience = courseAudience,
        _language = language,
        _price = price,
        super(firestoreUtilData);

  // "cover_photo" field.
  String? _coverPhoto;
  String get coverPhoto => _coverPhoto ?? '';
  set coverPhoto(String? val) => _coverPhoto = val;

  bool hasCoverPhoto() => _coverPhoto != null;

  // "course_name" field.
  String? _courseName;
  String get courseName => _courseName ?? '';
  set courseName(String? val) => _courseName = val;

  bool hasCourseName() => _courseName != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "preview" field.
  String? _preview;
  String get preview => _preview ?? '';
  set preview(String? val) => _preview = val;

  bool hasPreview() => _preview != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "tags" field.
  List<String>? _tags;
  List<String> get tags => _tags ?? const [];
  set tags(List<String>? val) => _tags = val;

  void updateTags(Function(List<String>) updateFn) {
    updateFn(_tags ??= []);
  }

  bool hasTags() => _tags != null;

  // "course_audience" field.
  List<String>? _courseAudience;
  List<String> get courseAudience => _courseAudience ?? const [];
  set courseAudience(List<String>? val) => _courseAudience = val;

  void updateCourseAudience(Function(List<String>) updateFn) {
    updateFn(_courseAudience ??= []);
  }

  bool hasCourseAudience() => _courseAudience != null;

  // "language" field.
  LanguageStruct? _language;
  LanguageStruct get language => _language ?? LanguageStruct();
  set language(LanguageStruct? val) => _language = val;

  void updateLanguage(Function(LanguageStruct) updateFn) {
    updateFn(_language ??= LanguageStruct());
  }

  bool hasLanguage() => _language != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  static NewCoursesStruct fromMap(Map<String, dynamic> data) =>
      NewCoursesStruct(
        coverPhoto: data['cover_photo'] as String?,
        courseName: data['course_name'] as String?,
        description: data['description'] as String?,
        preview: data['preview'] as String?,
        category: data['category'] as String?,
        tags: getDataList(data['tags']),
        courseAudience: getDataList(data['course_audience']),
        language: data['language'] is LanguageStruct
            ? data['language']
            : LanguageStruct.maybeFromMap(data['language']),
        price: castToType<double>(data['price']),
      );

  static NewCoursesStruct? maybeFromMap(dynamic data) => data is Map
      ? NewCoursesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'cover_photo': _coverPhoto,
        'course_name': _courseName,
        'description': _description,
        'preview': _preview,
        'category': _category,
        'tags': _tags,
        'course_audience': _courseAudience,
        'language': _language?.toMap(),
        'price': _price,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'cover_photo': serializeParam(
          _coverPhoto,
          ParamType.String,
        ),
        'course_name': serializeParam(
          _courseName,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'preview': serializeParam(
          _preview,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'tags': serializeParam(
          _tags,
          ParamType.String,
          isList: true,
        ),
        'course_audience': serializeParam(
          _courseAudience,
          ParamType.String,
          isList: true,
        ),
        'language': serializeParam(
          _language,
          ParamType.DataStruct,
        ),
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
      }.withoutNulls;

  static NewCoursesStruct fromSerializableMap(Map<String, dynamic> data) =>
      NewCoursesStruct(
        coverPhoto: deserializeParam(
          data['cover_photo'],
          ParamType.String,
          false,
        ),
        courseName: deserializeParam(
          data['course_name'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        preview: deserializeParam(
          data['preview'],
          ParamType.String,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        tags: deserializeParam<String>(
          data['tags'],
          ParamType.String,
          true,
        ),
        courseAudience: deserializeParam<String>(
          data['course_audience'],
          ParamType.String,
          true,
        ),
        language: deserializeStructParam(
          data['language'],
          ParamType.DataStruct,
          false,
          structBuilder: LanguageStruct.fromSerializableMap,
        ),
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'NewCoursesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is NewCoursesStruct &&
        coverPhoto == other.coverPhoto &&
        courseName == other.courseName &&
        description == other.description &&
        preview == other.preview &&
        category == other.category &&
        listEquality.equals(tags, other.tags) &&
        listEquality.equals(courseAudience, other.courseAudience) &&
        language == other.language &&
        price == other.price;
  }

  @override
  int get hashCode => const ListEquality().hash([
        coverPhoto,
        courseName,
        description,
        preview,
        category,
        tags,
        courseAudience,
        language,
        price
      ]);
}

NewCoursesStruct createNewCoursesStruct({
  String? coverPhoto,
  String? courseName,
  String? description,
  String? preview,
  String? category,
  LanguageStruct? language,
  double? price,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    NewCoursesStruct(
      coverPhoto: coverPhoto,
      courseName: courseName,
      description: description,
      preview: preview,
      category: category,
      language: language ?? (clearUnsetFields ? LanguageStruct() : null),
      price: price,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

NewCoursesStruct? updateNewCoursesStruct(
  NewCoursesStruct? newCourses, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    newCourses
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addNewCoursesStructData(
  Map<String, dynamic> firestoreData,
  NewCoursesStruct? newCourses,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (newCourses == null) {
    return;
  }
  if (newCourses.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && newCourses.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final newCoursesData = getNewCoursesFirestoreData(newCourses, forFieldValue);
  final nestedData = newCoursesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = newCourses.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getNewCoursesFirestoreData(
  NewCoursesStruct? newCourses, [
  bool forFieldValue = false,
]) {
  if (newCourses == null) {
    return {};
  }
  final firestoreData = mapToFirestore(newCourses.toMap());

  // Handle nested data for "language" field.
  addLanguageStructData(
    firestoreData,
    newCourses.hasLanguage() ? newCourses.language : null,
    'language',
    forFieldValue,
  );

  // Add any Firestore field values
  mapToFirestore(newCourses.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getNewCoursesListFirestoreData(
  List<NewCoursesStruct>? newCoursess,
) =>
    newCoursess?.map((e) => getNewCoursesFirestoreData(e, true)).toList() ?? [];
