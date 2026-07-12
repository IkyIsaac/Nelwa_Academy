import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RequestaRefundRecord extends FirestoreRecord {
  RequestaRefundRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  bool hasAmount() => _amount != null;

  // "coureses_ref" field.
  DocumentReference? _couresesRef;
  DocumentReference? get couresesRef => _couresesRef;
  bool hasCouresesRef() => _couresesRef != null;

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "reason" field.
  String? _reason;
  String get reason => _reason ?? '';
  bool hasReason() => _reason != null;

  // "screenshot_url" field.
  String? _screenshotUrl;
  String get screenshotUrl => _screenshotUrl ?? '';
  bool hasScreenshotUrl() => _screenshotUrl != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  void _initializeFields() {
    _amount = castToType<double>(snapshotData['amount']);
    _couresesRef = snapshotData['coureses_ref'] as DocumentReference?;
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _reason = snapshotData['reason'] as String?;
    _screenshotUrl = snapshotData['screenshot_url'] as String?;
    _status = snapshotData['status'] as String?;
    _createdAt = snapshotData['created_at'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('requesta_refund');

  static Stream<RequestaRefundRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RequestaRefundRecord.fromSnapshot(s));

  static Future<RequestaRefundRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RequestaRefundRecord.fromSnapshot(s));

  static RequestaRefundRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RequestaRefundRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RequestaRefundRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RequestaRefundRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RequestaRefundRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RequestaRefundRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRequestaRefundRecordData({
  double? amount,
  DocumentReference? couresesRef,
  DocumentReference? userRef,
  String? reason,
  String? screenshotUrl,
  String? status,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'amount': amount,
      'coureses_ref': couresesRef,
      'user_ref': userRef,
      'reason': reason,
      'screenshot_url': screenshotUrl,
      'status': status,
      'created_at': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class RequestaRefundRecordDocumentEquality
    implements Equality<RequestaRefundRecord> {
  const RequestaRefundRecordDocumentEquality();

  @override
  bool equals(RequestaRefundRecord? e1, RequestaRefundRecord? e2) {
    return e1?.amount == e2?.amount &&
        e1?.couresesRef == e2?.couresesRef &&
        e1?.userRef == e2?.userRef &&
        e1?.reason == e2?.reason &&
        e1?.screenshotUrl == e2?.screenshotUrl &&
        e1?.status == e2?.status &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(RequestaRefundRecord? e) => const ListEquality().hash([
        e?.amount,
        e?.couresesRef,
        e?.userRef,
        e?.reason,
        e?.screenshotUrl,
        e?.status,
        e?.createdAt
      ]);

  @override
  bool isValidKey(Object? o) => o is RequestaRefundRecord;
}
