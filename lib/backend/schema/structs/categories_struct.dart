// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class CategoriesStruct extends FFFirebaseStruct {
  CategoriesStruct({
    String? category,
    String? image,
    int? item,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _category = category,
        _image = image,
        _item = item,
        super(firestoreUtilData);

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

  // "item" field.
  int? _item;
  int get item => _item ?? 0;
  set item(int? val) => _item = val;

  void incrementItem(int amount) => item = item + amount;

  bool hasItem() => _item != null;

  static CategoriesStruct fromMap(Map<String, dynamic> data) =>
      CategoriesStruct(
        category: data['category'] as String?,
        image: data['image'] as String?,
        item: castToType<int>(data['item']),
      );

  static CategoriesStruct? maybeFromMap(dynamic data) => data is Map
      ? CategoriesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'category': _category,
        'image': _image,
        'item': _item,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'image': serializeParam(
          _image,
          ParamType.String,
        ),
        'item': serializeParam(
          _item,
          ParamType.int,
        ),
      }.withoutNulls;

  static CategoriesStruct fromSerializableMap(Map<String, dynamic> data) =>
      CategoriesStruct(
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        image: deserializeParam(
          data['image'],
          ParamType.String,
          false,
        ),
        item: deserializeParam(
          data['item'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'CategoriesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CategoriesStruct &&
        category == other.category &&
        image == other.image &&
        item == other.item;
  }

  @override
  int get hashCode => const ListEquality().hash([category, image, item]);
}

CategoriesStruct createCategoriesStruct({
  String? category,
  String? image,
  int? item,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CategoriesStruct(
      category: category,
      image: image,
      item: item,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CategoriesStruct? updateCategoriesStruct(
  CategoriesStruct? categories, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    categories
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCategoriesStructData(
  Map<String, dynamic> firestoreData,
  CategoriesStruct? categories,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (categories == null) {
    return;
  }
  if (categories.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && categories.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final categoriesData = getCategoriesFirestoreData(categories, forFieldValue);
  final nestedData = categoriesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = categories.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCategoriesFirestoreData(
  CategoriesStruct? categories, [
  bool forFieldValue = false,
]) {
  if (categories == null) {
    return {};
  }
  final firestoreData = mapToFirestore(categories.toMap());

  // Add any Firestore field values
  mapToFirestore(categories.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCategoriesListFirestoreData(
  List<CategoriesStruct>? categoriess,
) =>
    categoriess?.map((e) => getCategoriesFirestoreData(e, true)).toList() ?? [];
