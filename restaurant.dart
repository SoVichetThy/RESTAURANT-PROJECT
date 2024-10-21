import 'dart:io';

import 'customer.dart';
import 'manager.dart';
import 'options.dart';
import 'order.dart';
import 'reservation.dart';
import 'table.dart';

class Kiosk {
  final List<String> availableOptions = [];
  final Map<String, double> menuItems = {};
  final double taxRate = 0.08;
  final List<Table> table = [];
  final List<Reservation> reservation = [];
  final List<Order> order = [];
  final List<Manager> manager = [];
  final List<Customer> customer = [];
  Customer? currentCustomer;

  Kiosk() {
    _loadTable();
    _loadOptions();
    _welcomeMessage();
    displayOptions();
    displayMenu();
  }

  bool _CreateUser() {
    print("Enter your name:");
    String name = stdin.readLineSync().toString();
    print("Enter your phone number:");
    String phoneNumber = stdin.readLineSync().toString();
    print("Enter your email (Optional):");
    String email = stdin.readLineSync().toString();

    print("are you sure you want the info is correct");
    print("1. Yes\n2. No");

    bool isSuccess =
        int.parse(stdin.readLineSync().toString()) == 1 ? true : false;
    currentCustomer = Customer(
        customerId: this.customer.length + 1,
        name: name,
        phoneNumber: phoneNumber,
        email: email);

    isSuccess
        ? {
            customer.add(currentCustomer!),
            print(
                "User created successfully. Customer ID: ${customer[customer.length - 1]}")
          }
        : print("canceled");

    return isSuccess;
  }

  void _userInput() {
    int option;
    bool isValid = true;
    bool isStopProgramming = true;

    // loop to get the right option from customer
    //|
    do {
      for (int i = 0; i < availableOptions.length; i++) {
        print("${i + 1}. ${availableOptions[i]}");
      }
      print("Please select an option:");
      option = int.parse(stdin.readLineSync().toString());
      switch (option) {
        case 1:
          isValid = !_CreateUser();
          isValid == true ? print("again") : displayTable();
          break;
        case 2:
          isValid = false;
          break;
        case 0:
          print("Thank you! Have a great day!");
          break;
        default:
          print("$option is Invalid option. Please enter 1 or 2.");
          isValid = true;
          break;
      }
    } while (isStopProgramming);
    //|
  }

  void display() {
    print('Menu:');
    menuItems.forEach((key, value) => print('$key: $value'));
  }

  void _welcomeMessage() {
    // ANSI escape codes for formatting
    String bold = '\x1B[1m';
    String reset = '\x1B[0m';
    String yellow = '\x1B[33m';
    String underline = '\x1B[4m';

    print(
        "${bold}${yellow}${underline}Hello! Welcome to our JoJoba Restaurants${reset}");
  }

  void _loadOptions() {
    List<String> temp = options.values.map((e) => e.toString()).toList();
    availableOptions.addAll(temp);
    print('done loading options');
  }

  void displayOptions() {
    _userInput();
  }

  void displayMenu() {}

  void _loadTable() {
    print('menu fetch');
    List<Table> tables = [];

    for (int i = 1; i <= 20; i++) {
      tables.add(Table(
          tableNumber: i,
          capacity: (i % 4) + 2, // Example: varying capacity between 2 and 5
          isReserve: i % 2 == 0, // Example: alternate tables are reserved
          isReady: i % 3 != 0 // Example: every third table is not ready
          ));
    }
    table.addAll(tables);
  }

  void _reserveTable({required int tableNumber}) {
    print('-- table reserve -- ');
    table.elementAt(tableNumber).isReserve = true;
    table.elementAt(tableNumber).isReady = false;
  }

  void displayTable() {
    int choice;
    int numberofGuest;
    print('---Table display---\n');
    table.forEach((table) {
      print(
          "Table [${table.tableNumber}] - Capacity: ${table.capacity.toString().padRight(3)}, Reserve: ${table.isReserve.toString().padRight(3)}, Ready: ${table.isReady.toString().padRight(3)}");
    });

    do {
      choice = int.parse(stdin.readLineSync().toString()) - 1;
      if (choice >= table.length) {
        print('please enter a right number!');
      }
    } while (choice >= table.length);

    print("please enter your customer number!");
    numberofGuest = int.parse(stdin.readLineSync().toString()) - 1;
    print("You have choose: Table [${choice + 1}]\n");
    _reserveTable(tableNumber: choice);

    int generateReservationId = reservation.length + 1;


    reservation.add(Reservation(
        reservationId: generateReservationId,
        customerId: currentCustomer!.customerId,
        reservationTime: DateTime.now(),
        tableNumber: choice,
        numberOfGuests: numberofGuest+1));

    print(reservation);
    print(table.elementAt(choice).toString() + '\n');
  }
}
