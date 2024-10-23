class Order {
  int orderId;
  int customerId;
  List<String> items;
  DateTime orderTime;
  double totalAmount;
  String orderStatus;
  int tableNumber;
  String paymentMethod;
  bool isPaid;
  String specialInstructions;
  List<int> reservationId;

  Order({
    required this.orderId,
    required this.customerId,
    required this.items,
    required this.orderTime,
    required this.totalAmount,
    required this.orderStatus,
    required this.tableNumber,
    required this.paymentMethod,
    required this.isPaid,
    this.specialInstructions = '',
    this.reservationId = const [],
  });
}
