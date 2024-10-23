import 'menu.dart';

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
  int tableNumber;
  paymentMethod method = paymentMethod.cash;
  bool isPaid;
  DateTime? paymentDate;
  String specialInstructions;
  List<int> reservationId;

  Order({
    required this.orderId,
    required this.customerId,
    required this.orderTime,
    required this.tableNumber,
    required this.isPaid,
    this.specialInstructions = '',
    this.reservationId = const [],
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
- Table Number: $tableNumber
- Order Time: ${orderTime.toString()}
- Items: $itemList
- Total Amount: \$${totalAmount.toStringAsFixed(2)}
- Payment Method: ${method.label}
- Order Status: ${orderStatus ? "Completed" : "Pending"}
- Special Instructions: ${specialInstructions.isNotEmpty ? specialInstructions : "None"}
- Reservation IDs: ${reservationId.isNotEmpty ? reservationId.join(", ") : "No Reservations"}
- Is Paid: ${isPaid ? "Yes" : "No"}
  ''';
  }
}
