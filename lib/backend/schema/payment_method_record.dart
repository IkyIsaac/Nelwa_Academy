import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PaymentMethodRecord extends FirestoreRecord {
  PaymentMethodRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "provider_name" field.
  String? _providerName;
  String get providerName => _providerName ?? '';
  bool hasProviderName() => _providerName != null;

  // "expiry_date" field.
  DateTime? _expiryDate;
  DateTime? get expiryDate => _expiryDate;
  bool hasExpiryDate() => _expiryDate != null;

  // "currency" field.
  String? _currency;
  String get currency => _currency ?? '';
  bool hasCurrency() => _currency != null;

  // "is_default" field.
  bool? _isDefault;
  bool get isDefault => _isDefault ?? false;
  bool hasIsDefault() => _isDefault != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "card_number" field.
  String? _cardNumber;
  String get cardNumber => _cardNumber ?? '';
  bool hasCardNumber() => _cardNumber != null;

  // "card_holder" field.
  String? _cardHolder;
  String get cardHolder => _cardHolder ?? '';
  bool hasCardHolder() => _cardHolder != null;

  // "expire_date" field.
  String? _expireDate;
  String get expireDate => _expireDate ?? '';
  bool hasExpireDate() => _expireDate != null;

  // "cvc" field.
  int? _cvc;
  int get cvc => _cvc ?? 0;
  bool hasCvc() => _cvc != null;

  // "card_nickname" field.
  String? _cardNickname;
  String get cardNickname => _cardNickname ?? '';
  bool hasCardNickname() => _cardNickname != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _providerName = snapshotData['provider_name'] as String?;
    _expiryDate = snapshotData['expiry_date'] as DateTime?;
    _currency = snapshotData['currency'] as String?;
    _isDefault = snapshotData['is_default'] as bool?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _cardNumber = snapshotData['card_number'] as String?;
    _cardHolder = snapshotData['card_holder'] as String?;
    _expireDate = snapshotData['expire_date'] as String?;
    _cvc = castToType<int>(snapshotData['cvc']);
    _cardNickname = snapshotData['card_nickname'] as String?;
    _type = snapshotData['type'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('payment_method')
          : FirebaseFirestore.instance.collectionGroup('payment_method');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('payment_method').doc(id);

  static Stream<PaymentMethodRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PaymentMethodRecord.fromSnapshot(s));

  static Future<PaymentMethodRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PaymentMethodRecord.fromSnapshot(s));

  static PaymentMethodRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PaymentMethodRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PaymentMethodRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PaymentMethodRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PaymentMethodRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PaymentMethodRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPaymentMethodRecordData({
  String? providerName,
  DateTime? expiryDate,
  String? currency,
  bool? isDefault,
  DateTime? createdAt,
  String? cardNumber,
  String? cardHolder,
  String? expireDate,
  int? cvc,
  String? cardNickname,
  String? type,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'provider_name': providerName,
      'expiry_date': expiryDate,
      'currency': currency,
      'is_default': isDefault,
      'created_at': createdAt,
      'card_number': cardNumber,
      'card_holder': cardHolder,
      'expire_date': expireDate,
      'cvc': cvc,
      'card_nickname': cardNickname,
      'type': type,
    }.withoutNulls,
  );

  return firestoreData;
}

class PaymentMethodRecordDocumentEquality
    implements Equality<PaymentMethodRecord> {
  const PaymentMethodRecordDocumentEquality();

  @override
  bool equals(PaymentMethodRecord? e1, PaymentMethodRecord? e2) {
    return e1?.providerName == e2?.providerName &&
        e1?.expiryDate == e2?.expiryDate &&
        e1?.currency == e2?.currency &&
        e1?.isDefault == e2?.isDefault &&
        e1?.createdAt == e2?.createdAt &&
        e1?.cardNumber == e2?.cardNumber &&
        e1?.cardHolder == e2?.cardHolder &&
        e1?.expireDate == e2?.expireDate &&
        e1?.cvc == e2?.cvc &&
        e1?.cardNickname == e2?.cardNickname &&
        e1?.type == e2?.type;
  }

  @override
  int hash(PaymentMethodRecord? e) => const ListEquality().hash([
        e?.providerName,
        e?.expiryDate,
        e?.currency,
        e?.isDefault,
        e?.createdAt,
        e?.cardNumber,
        e?.cardHolder,
        e?.expireDate,
        e?.cvc,
        e?.cardNickname,
        e?.type
      ]);

  @override
  bool isValidKey(Object? o) => o is PaymentMethodRecord;
}
