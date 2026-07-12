import 'package:collection/collection.dart';

enum Status {
  Paid,
  Pending,
  Refunded,
}

enum MethodType {
  CreditCard,
  PayPal,
  BankTransfer,
}

enum PaymentMethods {
  PayPal,
  GooglePay,
  ApplePay,
  Visa,
  Mastercard,
  Discover,
  AmericanExpress,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (Status):
      return Status.values.deserialize(value) as T?;
    case (MethodType):
      return MethodType.values.deserialize(value) as T?;
    case (PaymentMethods):
      return PaymentMethods.values.deserialize(value) as T?;
    default:
      return null;
  }
}
