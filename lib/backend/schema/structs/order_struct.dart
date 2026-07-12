// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrderStruct extends FFFirebaseStruct {
  OrderStruct({
    List<DocumentReference>? coursesRef,
    double? price,
    int? discount,
    double? totalPrice,
    int? quantity,
    double? yearPrice,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _coursesRef = coursesRef,
        _price = price,
        _discount = discount,
        _totalPrice = totalPrice,
        _quantity = quantity,
        _yearPrice = yearPrice,
        super(firestoreUtilData);

  // "courses_ref" field.
  List<DocumentReference>? _coursesRef;
  List<DocumentReference> get coursesRef => _coursesRef ?? const [];
  set coursesRef(List<DocumentReference>? val) => _coursesRef = val;

  void updateCoursesRef(Function(List<DocumentReference>) updateFn) {
    updateFn(_coursesRef ??= []);
  }

  bool hasCoursesRef() => _coursesRef != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "discount" field.
  int? _discount;
  int get discount => _discount ?? 0;
  set discount(int? val) => _discount = val;

  void incrementDiscount(int amount) => discount = discount + amount;

  bool hasDiscount() => _discount != null;

  // "total_price" field.
  double? _totalPrice;
  double get totalPrice => _totalPrice ?? 0.0;
  set totalPrice(double? val) => _totalPrice = val;

  void incrementTotalPrice(double amount) => totalPrice = totalPrice + amount;

  bool hasTotalPrice() => _totalPrice != null;

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  set quantity(int? val) => _quantity = val;

  void incrementQuantity(int amount) => quantity = quantity + amount;

  bool hasQuantity() => _quantity != null;

  // "year_price" field.
  double? _yearPrice;
  double get yearPrice => _yearPrice ?? 0.0;
  set yearPrice(double? val) => _yearPrice = val;

  void incrementYearPrice(double amount) => yearPrice = yearPrice + amount;

  bool hasYearPrice() => _yearPrice != null;

  static OrderStruct fromMap(Map<String, dynamic> data) => OrderStruct(
        coursesRef: getDataList(data['courses_ref']),
        price: castToType<double>(data['price']),
        discount: castToType<int>(data['discount']),
        totalPrice: castToType<double>(data['total_price']),
        quantity: castToType<int>(data['quantity']),
        yearPrice: castToType<double>(data['year_price']),
      );

  static OrderStruct? maybeFromMap(dynamic data) =>
      data is Map ? OrderStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'courses_ref': _coursesRef,
        'price': _price,
        'discount': _discount,
        'total_price': _totalPrice,
        'quantity': _quantity,
        'year_price': _yearPrice,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'courses_ref': serializeParam(
          _coursesRef,
          ParamType.DocumentReference,
          isList: true,
        ),
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
        'discount': serializeParam(
          _discount,
          ParamType.int,
        ),
        'total_price': serializeParam(
          _totalPrice,
          ParamType.double,
        ),
        'quantity': serializeParam(
          _quantity,
          ParamType.int,
        ),
        'year_price': serializeParam(
          _yearPrice,
          ParamType.double,
        ),
      }.withoutNulls;

  static OrderStruct fromSerializableMap(Map<String, dynamic> data) =>
      OrderStruct(
        coursesRef: deserializeParam<DocumentReference>(
          data['courses_ref'],
          ParamType.DocumentReference,
          true,
          collectionNamePath: ['courses'],
        ),
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
        discount: deserializeParam(
          data['discount'],
          ParamType.int,
          false,
        ),
        totalPrice: deserializeParam(
          data['total_price'],
          ParamType.double,
          false,
        ),
        quantity: deserializeParam(
          data['quantity'],
          ParamType.int,
          false,
        ),
        yearPrice: deserializeParam(
          data['year_price'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'OrderStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is OrderStruct &&
        listEquality.equals(coursesRef, other.coursesRef) &&
        price == other.price &&
        discount == other.discount &&
        totalPrice == other.totalPrice &&
        quantity == other.quantity &&
        yearPrice == other.yearPrice;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([coursesRef, price, discount, totalPrice, quantity, yearPrice]);
}

OrderStruct createOrderStruct({
  double? price,
  int? discount,
  double? totalPrice,
  int? quantity,
  double? yearPrice,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    OrderStruct(
      price: price,
      discount: discount,
      totalPrice: totalPrice,
      quantity: quantity,
      yearPrice: yearPrice,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

OrderStruct? updateOrderStruct(
  OrderStruct? order, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    order
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addOrderStructData(
  Map<String, dynamic> firestoreData,
  OrderStruct? order,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (order == null) {
    return;
  }
  if (order.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && order.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final orderData = getOrderFirestoreData(order, forFieldValue);
  final nestedData = orderData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = order.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getOrderFirestoreData(
  OrderStruct? order, [
  bool forFieldValue = false,
]) {
  if (order == null) {
    return {};
  }
  final firestoreData = mapToFirestore(order.toMap());

  // Add any Firestore field values
  mapToFirestore(order.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getOrderListFirestoreData(
  List<OrderStruct>? orders,
) =>
    orders?.map((e) => getOrderFirestoreData(e, true)).toList() ?? [];
