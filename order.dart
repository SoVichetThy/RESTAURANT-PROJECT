import 'menu.dart';
import 'reservation.dart';

enum paymentMethod {
  cash("cash"),
  ABA("ABA"),
  ACELIDA("ACELIDA"),
  CREDITCARD("CREDITCARD");

  final String label;

  const paymentMethod(this.label);

  String toString() {
    return switch (this) {
      paymentMethod.cash => label,
      paymentMethod.ABA => label,
      paymentMethod.ACELIDA => label,
      paymentMethod.CREDITCARD => label,
    };
  }
}

class Order {
  int orderId;
  int customerId;
  List<Menu> items = [];
  DateTime orderTime;
  double totalAmount = 0;
  bool orderStatus = false;
  paymentMethod method = paymentMethod.cash;
  bool isPaid;
  DateTime? paymentDate;
  String specialInstructions;
  Reservation? reservation;

  Order({
    required this.orderId,
    required this.customerId,
    required this.orderTime,
    required this.isPaid,
    this.specialInstructions = '',
    this.reservation,
  });

  void addItem(List<Menu> newItem) {
    items.addAll(newItem);
  }

  void setOrderStatus(bool status) {
    orderStatus = status;
  }

  void calculateAmount() {
    totalAmount = items.fold(
        0, (previousValue, element) => previousValue + element.price);
  }

  @override
  String toString() {
    String itemList = items.map((item) => item.name).join(", ");
    return '''
Order Details:
- Order ID: $orderId
- Customer ID: $customerId
- Table Number: ${reservation?.tableNumber ?? 'Take Away'}
- Order Time: ${orderTime.toString()}
- Items: $itemList
- Total Amount: \$${totalAmount.toStringAsFixed(2)}
- Payment Method: ${method.label}
- Order Status: ${orderStatus ? "Completed" : "Pending"}
- Special Instructions: ${specialInstructions.isNotEmpty ? specialInstructions : "None"}
- Reservation IDs: ${reservation?.reservationId ?? 'none'};
- Is Paid: ${isPaid ? "Yes" : "No"}
  ''';
  }
}
