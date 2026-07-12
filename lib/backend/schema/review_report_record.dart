import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReviewReportRecord extends FirestoreRecord {
  ReviewReportRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "message" field.
  String? _message;
  String get message => _message ?? '';
  bool hasMessage() => _message != null;

  // "report_type" field.
  String? _reportType;
  String get reportType => _reportType ?? '';
  bool hasReportType() => _reportType != null;

  // "review_ref" field.
  DocumentReference? _reviewRef;
  DocumentReference? get reviewRef => _reviewRef;
  bool hasReviewRef() => _reviewRef != null;

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _message = snapshotData['message'] as String?;
    _reportType = snapshotData['report_type'] as String?;
    _reviewRef = snapshotData['review_ref'] as DocumentReference?;
    _userRef = snapshotData['user_ref'] as DocumentReference?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('review_report')
          : FirebaseFirestore.instance.collectionGroup('review_report');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('review_report').doc(id);

  static Stream<ReviewReportRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ReviewReportRecord.fromSnapshot(s));

  static Future<ReviewReportRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ReviewReportRecord.fromSnapshot(s));

  static ReviewReportRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ReviewReportRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ReviewReportRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ReviewReportRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ReviewReportRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ReviewReportRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createReviewReportRecordData({
  String? message,
  String? reportType,
  DocumentReference? reviewRef,
  DocumentReference? userRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'message': message,
      'report_type': reportType,
      'review_ref': reviewRef,
      'user_ref': userRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class ReviewReportRecordDocumentEquality
    implements Equality<ReviewReportRecord> {
  const ReviewReportRecordDocumentEquality();

  @override
  bool equals(ReviewReportRecord? e1, ReviewReportRecord? e2) {
    return e1?.message == e2?.message &&
        e1?.reportType == e2?.reportType &&
        e1?.reviewRef == e2?.reviewRef &&
        e1?.userRef == e2?.userRef;
  }

  @override
  int hash(ReviewReportRecord? e) => const ListEquality()
      .hash([e?.message, e?.reportType, e?.reviewRef, e?.userRef]);

  @override
  bool isValidKey(Object? o) => o is ReviewReportRecord;
}
