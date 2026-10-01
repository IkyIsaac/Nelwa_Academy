import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Mirrors the `orders` collection written by `createOrder`/`snippeWebhook`
/// in firebase/functions/payments.js. Read-only from the client — nothing
/// in the app ever writes here, only the Cloud Functions' Admin SDK does.
class OrdersRecord extends FirestoreRecord {
  OrdersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "userId" field.
  String? _userId;
  String get userId => _userId ?? '';
  bool hasUserId() => _userId != null;

  // "userRef" field.
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
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "lineItems" field — left as raw maps (courseRef, title, price, ...);
  // this collection is backend-written only, so a full typed struct isn't
  // worth it for a read-only admin view.
  List<Map<String, dynamic>>? _lineItems;
  List<Map<String, dynamic>> get lineItems => _lineItems ?? const [];
  bool hasLineItems() => _lineItems != null && _lineItems!.isNotEmpty;

  // "snippeReference" field.
  String? _snippeReference;
  String get snippeReference => _snippeReference ?? '';
  bool hasSnippeReference() => _snippeReference != null;

  // "checkoutUrl" field.
  String? _checkoutUrl;
  String get checkoutUrl => _checkoutUrl ?? '';
  bool hasCheckoutUrl() => _checkoutUrl != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  // "completedAt" field.
  DateTime? _completedAt;
  DateTime? get completedAt => _completedAt;
  bool hasCompletedAt() => _completedAt != null;

  void _initializeFields() {
    _userId = snapshotData['userId'] as String?;
    _userRef = snapshotData['userRef'] as DocumentReference?;
    _amount = castToType<double>(snapshotData['amount']);
    _currency = snapshotData['currency'] as String?;
    _status = snapshotData['status'] as String?;
    final rawLineItems = snapshotData['lineItems'];
    _lineItems = rawLineItems is List
        ? rawLineItems.whereType<Map<String, dynamic>>().toList()
        : null;
    _snippeReference = snapshotData['snippeReference'] as String?;
    _checkoutUrl = snapshotData['checkoutUrl'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _updatedAt = snapshotData['updatedAt'] as DateTime?;
    _completedAt = snapshotData['completedAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('orders');

  static Stream<OrdersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrdersRecord.fromSnapshot(s));

  static Future<OrdersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrdersRecord.fromSnapshot(s));

  static OrdersRecord fromSnapshot(DocumentSnapshot snapshot) => OrdersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrdersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrdersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrdersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrdersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

class OrdersRecordDocumentEquality implements Equality<OrdersRecord> {
  const OrdersRecordDocumentEquality();

  @override
  bool equals(OrdersRecord? e1, OrdersRecord? e2) {
    return e1?.userId == e2?.userId &&
        e1?.userRef == e2?.userRef &&
        e1?.amount == e2?.amount &&
        e1?.currency == e2?.currency &&
        e1?.status == e2?.status &&
        e1?.snippeReference == e2?.snippeReference &&
        e1?.checkoutUrl == e2?.checkoutUrl &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt &&
        e1?.completedAt == e2?.completedAt;
  }

  @override
  int hash(OrdersRecord? e) => const ListEquality().hash([
        e?.userId,
        e?.userRef,
        e?.amount,
        e?.currency,
        e?.status,
        e?.snippeReference,
        e?.checkoutUrl,
        e?.createdAt,
        e?.updatedAt,
        e?.completedAt,
      ]);

  @override
  bool isValidKey(Object? o) => o is OrdersRecord;
}
