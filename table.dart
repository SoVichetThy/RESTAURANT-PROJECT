class Table {
  final int tableNumber;
  final int capacity;
  bool isReserve;
  bool isReady;

  Table(
      {required this.tableNumber,
      required this.capacity,
      required this.isReserve,
      required this.isReady});

  @override
  String toString() {
    return 'Table Number: ${tableNumber}, Capacity: $capacity, Is Reserve: $isReserve, Is Ready: $isReady';
  }
}
