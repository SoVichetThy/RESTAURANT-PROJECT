class Reservation {
  int reservationId;
  int customerId;
  DateTime reservationTime;
  int tableNumber;
  int numberOfGuests;

  Reservation({
    required this.reservationId,
    required this.customerId,
    required this.reservationTime,
    required this.tableNumber,
    required this.numberOfGuests,
  });
  @override
  String toString() {
    return 'Reservation{reservationId: $reservationId, customerId: $customerId, reservationTime: $reservationTime, tableNumber: $tableNumber, numberOfGuests: $numberOfGuests}';
  }
}
