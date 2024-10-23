class Customer {
  final int customerId;
  final String name;
  final String phoneNumber1;
  final String? email;
  Customer(
      {required this.customerId,
      required this.name,
      required this.phoneNumber1,
      this.email});
  int? age;
  int? agee;
  @override
  String toString() {
    return 'Customer ID: $customerId, Name: $name, Phone Number: $phoneNumber1, Email: $email';
  }
}
