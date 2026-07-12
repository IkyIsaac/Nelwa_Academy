import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PurchaseHistoryRecord extends FirestoreRecord {
  PurchaseHistoryRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  bool hasAmount() => _amount != null;

  // "currency" field.
  String? _currency;
  String get currency => _currency ?? '';
  bool hasCurrency() => _currency != null;

  // "status" field.
  Status? _status;
  Status? get status => _status;
  bool hasStatus() => _status != null;

  // "transaction_type" field.
  String? _transactionType;
  String get transactionType => _transactionType ?? '';
  bool hasTransactionType() => _transactionType != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "payment_method" field.
  DocumentReference? _paymentMethod;
  DocumentReference? get paymentMethod => _paymentMethod;
  bool hasPaymentMethod() => _paymentMethod != null;

  // "courses_ref" field.
  DocumentReference? _coursesRef;
  DocumentReference? get coursesRef => _coursesRef;
  bool hasCoursesRef() => _coursesRef != null;

  // "courses_name" field.
  String? _coursesName;
  String get coursesName => _coursesName ?? '';
  bool hasCoursesName() => _coursesName != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _amount = castToType<double>(snapshotData['amount']);
    _currency = snapshotData['currency'] as String?;
    _status = snapshotData['status'] is Status
        ? snapshotData['status']
        : deserializeEnum<Status>(snapshotData['status']);
    _transactionType = snapshotData['transaction_type'] as String?;
    _date = snapshotData['date'] as DateTime?;
    _paymentMethod = snapshotData['payment_method'] as DocumentReference?;
    _coursesRef = snapshotData['courses_ref'] as DocumentReference?;
    _coursesName = snapshotData['courses_name'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('purchase_history')
          : FirebaseFirestore.instance.collectionGroup('purchase_history');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('purchase_history').doc(id);

  static Stream<PurchaseHistoryRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PurchaseHistoryRecord.fromSnapshot(s));

  static Future<PurchaseHistoryRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PurchaseHistoryRecord.fromSnapshot(s));

  static PurchaseHistoryRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PurchaseHistoryRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PurchaseHistoryRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PurchaseHistoryRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PurchaseHistoryRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PurchaseHistoryRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPurchaseHistoryRecordData({
  DocumentReference? userRef,
  double? amount,
  String? currency,
  Status? status,
  String? transactionType,
  DateTime? date,
  DocumentReference? paymentMethod,
  DocumentReference? coursesRef,
  String? coursesName,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_ref': userRef,
      'amount': amount,
      'currency': currency,
      'status': status,
      'transaction_type': transactionType,
      'date': date,
      'payment_method': paymentMethod,
      'courses_ref': coursesRef,
      'courses_name': coursesName,
    }.withoutNulls,
  );

  return firestoreData;
}

class PurchaseHistoryRecordDocumentEquality
    implements Equality<PurchaseHistoryRecord> {
  const PurchaseHistoryRecordDocumentEquality();

  @override
  bool equals(PurchaseHistoryRecord? e1, PurchaseHistoryRecord? e2) {
    return e1?.userRef == e2?.userRef &&
        e1?.amount == e2?.amount &&
        e1?.currency == e2?.currency &&
        e1?.status == e2?.status &&
        e1?.transactionType == e2?.transactionType &&
        e1?.date == e2?.date &&
        e1?.paymentMethod == e2?.paymentMethod &&
        e1?.coursesRef == e2?.coursesRef &&
        e1?.coursesName == e2?.coursesName;
  }

  @override
  int hash(PurchaseHistoryRecord? e) => const ListEquality().hash([
        e?.userRef,
        e?.amount,
        e?.currency,
        e?.status,
        e?.transactionType,
        e?.date,
        e?.paymentMethod,
        e?.coursesRef,
        e?.coursesName
      ]);

  @override
  bool isValidKey(Object? o) => o is PurchaseHistoryRecord;
}
