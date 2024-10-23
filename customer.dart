class Customer {
  final int customerId;
  final String name;
  final String phoneNumber;
  final String? email;
  Customer(
      {required this.customerId,
      required this.name,
      required this.phoneNumber,
      this.email});
  int? agee;
  @override
  String toString() {
    return 'Customer ID: $customerId, Name: $name, Phone Number: $phoneNumber, Email: $email';
  }
}
