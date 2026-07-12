import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PaymentAccountRecord extends FirestoreRecord {
  PaymentAccountRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "account_type" field.
  String? _accountType;
  String get accountType => _accountType ?? '';
  bool hasAccountType() => _accountType != null;

  // "currency" field.
  String? _currency;
  String get currency => _currency ?? '';
  bool hasCurrency() => _currency != null;

  // "balance" field.
  double? _balance;
  double get balance => _balance ?? 0.0;
  bool hasBalance() => _balance != null;

  // "is_default" field.
  bool? _isDefault;
  bool get isDefault => _isDefault ?? false;
  bool hasIsDefault() => _isDefault != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "sales_reports" field.
  List<SalesReportsStruct>? _salesReports;
  List<SalesReportsStruct> get salesReports => _salesReports ?? const [];
  bool hasSalesReports() => _salesReports != null;

  // "account" field.
  int? _account;
  int get account => _account ?? 0;
  bool hasAccount() => _account != null;

  // "account_holder" field.
  String? _accountHolder;
  String get accountHolder => _accountHolder ?? '';
  bool hasAccountHolder() => _accountHolder != null;

  // "bank_code" field.
  String? _bankCode;
  String get bankCode => _bankCode ?? '';
  bool hasBankCode() => _bankCode != null;

  // "branch_code" field.
  int? _branchCode;
  int get branchCode => _branchCode ?? 0;
  bool hasBranchCode() => _branchCode != null;

  // "paypal_email" field.
  String? _paypalEmail;
  String get paypalEmail => _paypalEmail ?? '';
  bool hasPaypalEmail() => _paypalEmail != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _accountType = snapshotData['account_type'] as String?;
    _currency = snapshotData['currency'] as String?;
    _balance = castToType<double>(snapshotData['balance']);
    _isDefault = snapshotData['is_default'] as bool?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _salesReports = getStructList(
      snapshotData['sales_reports'],
      SalesReportsStruct.fromMap,
    );
    _account = castToType<int>(snapshotData['account']);
    _accountHolder = snapshotData['account_holder'] as String?;
    _bankCode = snapshotData['bank_code'] as String?;
    _branchCode = castToType<int>(snapshotData['branch_code']);
    _paypalEmail = snapshotData['paypal_email'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('payment_account')
          : FirebaseFirestore.instance.collectionGroup('payment_account');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('payment_account').doc(id);

  static Stream<PaymentAccountRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PaymentAccountRecord.fromSnapshot(s));

  static Future<PaymentAccountRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PaymentAccountRecord.fromSnapshot(s));

  static PaymentAccountRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PaymentAccountRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PaymentAccountRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PaymentAccountRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PaymentAccountRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PaymentAccountRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPaymentAccountRecordData({
  String? accountType,
  String? currency,
  double? balance,
  bool? isDefault,
  DateTime? createdAt,
  int? account,
  String? accountHolder,
  String? bankCode,
  int? branchCode,
  String? paypalEmail,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'account_type': accountType,
      'currency': currency,
      'balance': balance,
      'is_default': isDefault,
      'created_at': createdAt,
      'account': account,
      'account_holder': accountHolder,
      'bank_code': bankCode,
      'branch_code': branchCode,
      'paypal_email': paypalEmail,
    }.withoutNulls,
  );

  return firestoreData;
}

class PaymentAccountRecordDocumentEquality
    implements Equality<PaymentAccountRecord> {
  const PaymentAccountRecordDocumentEquality();

  @override
  bool equals(PaymentAccountRecord? e1, PaymentAccountRecord? e2) {
    const listEquality = ListEquality();
    return e1?.accountType == e2?.accountType &&
        e1?.currency == e2?.currency &&
        e1?.balance == e2?.balance &&
        e1?.isDefault == e2?.isDefault &&
        e1?.createdAt == e2?.createdAt &&
        listEquality.equals(e1?.salesReports, e2?.salesReports) &&
        e1?.account == e2?.account &&
        e1?.accountHolder == e2?.accountHolder &&
        e1?.bankCode == e2?.bankCode &&
        e1?.branchCode == e2?.branchCode &&
        e1?.paypalEmail == e2?.paypalEmail;
  }

  @override
  int hash(PaymentAccountRecord? e) => const ListEquality().hash([
        e?.accountType,
        e?.currency,
        e?.balance,
        e?.isDefault,
        e?.createdAt,
        e?.salesReports,
        e?.account,
        e?.accountHolder,
        e?.bankCode,
        e?.branchCode,
        e?.paypalEmail
      ]);

  @override
  bool isValidKey(Object? o) => o is PaymentAccountRecord;
}
