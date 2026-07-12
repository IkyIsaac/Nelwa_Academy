import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PurchasedCoursesRecord extends FirestoreRecord {
  PurchasedCoursesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "courses_ref" field.
  DocumentReference? _coursesRef;
  DocumentReference? get coursesRef => _coursesRef;
  bool hasCoursesRef() => _coursesRef != null;

  // "instructor_name" field.
  String? _instructorName;
  String get instructorName => _instructorName ?? '';
  bool hasInstructorName() => _instructorName != null;

  // "purchase_date" field.
  DateTime? _purchaseDate;
  DateTime? get purchaseDate => _purchaseDate;
  bool hasPurchaseDate() => _purchaseDate != null;

  // "reviwed" field.
  bool? _reviwed;
  bool get reviwed => _reviwed ?? false;
  bool hasReviwed() => _reviwed != null;

  // "watched_lessons" field.
  List<DocumentReference>? _watchedLessons;
  List<DocumentReference> get watchedLessons => _watchedLessons ?? const [];
  bool hasWatchedLessons() => _watchedLessons != null;

  // "lessons" field.
  int? _lessons;
  int get lessons => _lessons ?? 0;
  bool hasLessons() => _lessons != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _coursesRef = snapshotData['courses_ref'] as DocumentReference?;
    _instructorName = snapshotData['instructor_name'] as String?;
    _purchaseDate = snapshotData['purchase_date'] as DateTime?;
    _reviwed = snapshotData['reviwed'] as bool?;
    _watchedLessons = getDataList(snapshotData['watched_lessons']);
    _lessons = castToType<int>(snapshotData['lessons']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('purchased_courses')
          : FirebaseFirestore.instance.collectionGroup('purchased_courses');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('purchased_courses').doc(id);

  static Stream<PurchasedCoursesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PurchasedCoursesRecord.fromSnapshot(s));

  static Future<PurchasedCoursesRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => PurchasedCoursesRecord.fromSnapshot(s));

  static PurchasedCoursesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PurchasedCoursesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PurchasedCoursesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PurchasedCoursesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PurchasedCoursesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PurchasedCoursesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPurchasedCoursesRecordData({
  DocumentReference? coursesRef,
  String? instructorName,
  DateTime? purchaseDate,
  bool? reviwed,
  int? lessons,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'courses_ref': coursesRef,
      'instructor_name': instructorName,
      'purchase_date': purchaseDate,
      'reviwed': reviwed,
      'lessons': lessons,
    }.withoutNulls,
  );

  return firestoreData;
}

class PurchasedCoursesRecordDocumentEquality
    implements Equality<PurchasedCoursesRecord> {
  const PurchasedCoursesRecordDocumentEquality();

  @override
  bool equals(PurchasedCoursesRecord? e1, PurchasedCoursesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.coursesRef == e2?.coursesRef &&
        e1?.instructorName == e2?.instructorName &&
        e1?.purchaseDate == e2?.purchaseDate &&
        e1?.reviwed == e2?.reviwed &&
        listEquality.equals(e1?.watchedLessons, e2?.watchedLessons) &&
        e1?.lessons == e2?.lessons;
  }

  @override
  int hash(PurchasedCoursesRecord? e) => const ListEquality().hash([
        e?.coursesRef,
        e?.instructorName,
        e?.purchaseDate,
        e?.reviwed,
        e?.watchedLessons,
        e?.lessons
      ]);

  @override
  bool isValidKey(Object? o) => o is PurchasedCoursesRecord;
}
