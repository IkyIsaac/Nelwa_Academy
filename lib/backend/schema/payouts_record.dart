import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Mirrors the `payouts` collection written by `createPayout` and the
/// payout.* branch of `snippeWebhook` in firebase/functions/payouts.js.
/// Read-only from the client — only the Cloud Functions' Admin SDK writes
/// here.
class PayoutsRecord extends FirestoreRecord {
  PayoutsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "instructorUserId" field.
  String? _instructorUserId;
  String get instructorUserId => _instructorUserId ?? '';
  bool hasInstructorUserId() => _instructorUserId != null;

  // "instructorRef" field.
  DocumentReference? _instructorRef;
  DocumentReference? get instructorRef => _instructorRef;
  bool hasInstructorRef() => _instructorRef != null;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  bool hasAmount() => _amount != null;

  // "currency" field.
  String? _currency;
  String get currency => _currency ?? '';
  bool hasCurrency() => _currency != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "snippeReference" field.
  String? _snippeReference;
  String get snippeReference => _snippeReference ?? '';
  bool hasSnippeReference() => _snippeReference != null;

  // "error" field.
  String? _error;
  String get error => _error ?? '';
  bool hasError() => _error != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "completedAt" field.
  DateTime? _completedAt;
  DateTime? get completedAt => _completedAt;
  bool hasCompletedAt() => _completedAt != null;

  void _initializeFields() {
    _instructorUserId = snapshotData['instructorUserId'] as String?;
    _instructorRef = snapshotData['instructorRef'] as DocumentReference?;
    _amount = castToType<double>(snapshotData['amount']);
    _currency = snapshotData['currency'] as String?;
    _status = snapshotData['status'] as String?;
    _snippeReference = snapshotData['snippeReference'] as String?;
    _error = snapshotData['error'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _completedAt = snapshotData['completedAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('payouts');

  static Stream<PayoutsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PayoutsRecord.fromSnapshot(s));

  static Future<PayoutsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PayoutsRecord.fromSnapshot(s));

  static PayoutsRecord fromSnapshot(DocumentSnapshot snapshot) => PayoutsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PayoutsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PayoutsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PayoutsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PayoutsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

class PayoutsRecordDocumentEquality implements Equality<PayoutsRecord> {
  const PayoutsRecordDocumentEquality();

  @override
  bool equals(PayoutsRecord? e1, PayoutsRecord? e2) {
    return e1?.instructorUserId == e2?.instructorUserId &&
        e1?.instructorRef == e2?.instructorRef &&
        e1?.amount == e2?.amount &&
        e1?.currency == e2?.currency &&
        e1?.status == e2?.status &&
        e1?.snippeReference == e2?.snippeReference &&
        e1?.error == e2?.error &&
        e1?.createdAt == e2?.createdAt &&
        e1?.completedAt == e2?.completedAt;
  }

  @override
  int hash(PayoutsRecord? e) => const ListEquality().hash([
        e?.instructorUserId,
        e?.instructorRef,
        e?.amount,
        e?.currency,
        e?.status,
        e?.snippeReference,
        e?.error,
        e?.createdAt,
        e?.completedAt,
      ]);

  @override
  bool isValidKey(Object? o) => o is PayoutsRecord;
}
