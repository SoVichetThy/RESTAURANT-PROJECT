class Table {
  final int tableNumber;
  int capacity;
  bool isReserve;
  bool isReady;

  Table(
      {required this.tableNumber,
      required this.capacity,
      required this.isReserve,
      required this.isReady});
  void setRerserve() {
    isReserve = !isReserve;
    isReady = false;
  }

  void setReady() {
    isReady = !isReady;
    isReserve = false;

  }

  @override
  String toString() {
    return 'Table Number: ${tableNumber}, Capacity: $capacity, Is Reserve: $isReserve, Is Ready: $isReady';
  }
}
