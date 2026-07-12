import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OptionsRecord extends FirestoreRecord {
  OptionsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "tags" field.
  List<String>? _tags;
  List<String> get tags => _tags ?? const [];
  bool hasTags() => _tags != null;

  // "course_audience" field.
  List<String>? _courseAudience;
  List<String> get courseAudience => _courseAudience ?? const [];
  bool hasCourseAudience() => _courseAudience != null;

  // "specialty" field.
  List<String>? _specialty;
  List<String> get specialty => _specialty ?? const [];
  bool hasSpecialty() => _specialty != null;

  // "trending_now" field.
  List<String>? _trendingNow;
  List<String> get trendingNow => _trendingNow ?? const [];
  bool hasTrendingNow() => _trendingNow != null;

  // "categories" field.
  List<CategoriesStruct>? _categories;
  List<CategoriesStruct> get categories => _categories ?? const [];
  bool hasCategories() => _categories != null;

  void _initializeFields() {
    _tags = getDataList(snapshotData['tags']);
    _courseAudience = getDataList(snapshotData['course_audience']);
    _specialty = getDataList(snapshotData['specialty']);
    _trendingNow = getDataList(snapshotData['trending_now']);
    _categories = getStructList(
      snapshotData['categories'],
      CategoriesStruct.fromMap,
    );
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('options');

  static Stream<OptionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OptionsRecord.fromSnapshot(s));

  static Future<OptionsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OptionsRecord.fromSnapshot(s));

  static OptionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      OptionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OptionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OptionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OptionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OptionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOptionsRecordData() {
  final firestoreData = mapToFirestore(
    <String, dynamic>{}.withoutNulls,
  );

  return firestoreData;
}

class OptionsRecordDocumentEquality implements Equality<OptionsRecord> {
  const OptionsRecordDocumentEquality();

  @override
  bool equals(OptionsRecord? e1, OptionsRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.tags, e2?.tags) &&
        listEquality.equals(e1?.courseAudience, e2?.courseAudience) &&
        listEquality.equals(e1?.specialty, e2?.specialty) &&
        listEquality.equals(e1?.trendingNow, e2?.trendingNow) &&
        listEquality.equals(e1?.categories, e2?.categories);
  }

  @override
  int hash(OptionsRecord? e) => const ListEquality().hash([
        e?.tags,
        e?.courseAudience,
        e?.specialty,
        e?.trendingNow,
        e?.categories
      ]);

  @override
  bool isValidKey(Object? o) => o is OptionsRecord;
}
