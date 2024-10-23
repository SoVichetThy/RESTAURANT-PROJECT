import 'dart:io';

import 'customer.dart';
import 'foodItem.dart';
import 'manager.dart';
import 'menu.dart';
import 'options.dart';
import 'order.dart';
import 'reservation.dart';
import 'table.dart';

class Kiosk {
  final List<String> availableOptions = [];
  final double taxRate = 0.08;
  final List<Table> table = [];
  final List<Reservation> reservation = [];
  final List<Order> order = [];
  final List<Manager> manager = [];
  final List<Customer> customer = [];
  final List<Menu> menu = [];
  late Order currentOrder;
  Customer? currentCustomer =
      Customer(customerId: 1, name: 'Mengthong', phoneNumber: '0898989');
  late Reservation currentReservation = Reservation(
      reservationId: 1,
      customerId: 1,
      reservationTime: DateTime.now(),
      tableNumber: 1,
      numberOfGuests: 4);

  Kiosk() {
    displayMenu();
    // _loadTable();
    // _loadOptions();
    // _welcomeMessage();
    // displayOptions();
  }

  void _CreateUser() {
    print("Enter your name:");
    String name = stdin.readLineSync().toString();
    print("Enter your phone number:");
    String phoneNumber = stdin.readLineSync().toString();
    print("Enter your email (Optional):");
    String email = stdin.readLineSync().toString();

    bool isSuccess;

    print("are you sure you want the info is correct");
    print("1. Yes\n2. No");
    isSuccess = int.parse(stdin.readLineSync().toString()) == 1 ? true : false;
    isSuccess
        ? {
            currentCustomer = Customer(
                customerId: this.customer.length + 1,
                name: name,
                phoneNumber: phoneNumber,
                email: email),
            customer.add(currentCustomer!),
            print(
                "User created successfully. Customer ID: ${customer[customer.length - 1]}")
          }
        : print("canceled");
  }

  void _userInput() {
    int option;
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
          _CreateUser();
          currentCustomer == null
              ? print("[---Please try again--]")
              : {
                  displayTable(),
                  displayMenu(),
                };
          // isValid = _CreateUser();

          break;
        case 2:
          break;
        case 0:
          print("Thank you! Have a great day!");
          isStopProgramming = false;
          break;
        default:
          print("$option is Invalid option. Please enter 1 or 2.");
          break;
      }
    } while (isStopProgramming);
    //|
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

  void displayMenu() {
    List<Menu> cart = [];
    int choice;
    menu.addAll(foodItems);
    // create new empty order
    currentOrder = Order(
        orderId: order.length + 1,
        customerId: currentCustomer!.customerId,
        orderTime: DateTime.now(),
        tableNumber: currentReservation.tableNumber,
        isPaid: false);

    // display
    print('[---Display Menu---]\n');
    menu.asMap().forEach((key, value) {
      print("[${key + 1}] ${value.name} - ${value.price.toString()}\$");
    });

    do {
      print("Choose Any Item");
      choice = int.parse(stdin.readLineSync().toString());
      if (choice >= menu.length) {
        print('please enter a right number!');
      } else if (choice != 0) {
        cart.add(foodItems[choice - 1]);
        cart.forEach((element) {
          print(element);
        });
      }
    } while (choice != 0);
    currentOrder.addItem(cart);
    currentOrder.calculateAmount();
    currentOrder.orderStatus = true;

    String specialInstruction = '';
    print('Do you have any special instructions? (please press y)');
    if (stdin.readLineSync().toString() == "y") {
      print('Please enter your special instructions:');
      specialInstruction = stdin.readLineSync().toString();
      currentOrder.specialInstructions = specialInstruction;
    } else {
      currentOrder.specialInstructions = "No special instructions";
    }

    print(currentOrder);

    pay();
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

    currentReservation = Reservation(
      reservationId: generateReservationId,
      customerId: currentCustomer!.customerId,
      reservationTime: DateTime.now(),
      tableNumber: choice + 1,
      numberOfGuests: numberofGuest + 1,
    );
    reservation.add(currentReservation);

    print(reservation.last);
  }

  void pay() {
    bool isSuccess = false;
    print('[---Pay to complete the order---]');
    paymentMethod.values.asMap().forEach((key, value) {
      print("[${key + 1}] - ${value}");
    });

    do {
      print("Select one payment to continue: ");
      int paymentChoice = int.parse(stdin.readLineSync().toString());

      switch (paymentChoice) {
        case 1:
          print("Payment with cash: 50.00");
          print("insert your money down below");
          print('Thank you');
          isSuccess = true;
          currentOrder.isPaid = true;
          currentOrder.paymentDate = DateTime.now();

          break;
        case 2:
          print("Pay with ABA");
          print("scan QR down below");
          print("thank you");
          currentOrder.isPaid = true;
          currentOrder.paymentDate = DateTime.now();
          currentReservation.order = currentOrder;
          isSuccess = true;
          break;
        case 3:
          print("Pay with ACELIDA");
          print("scan QR down below");
          print("thank you");
          currentOrder.isPaid = true;
          currentOrder.paymentDate = DateTime.now();
          currentReservation.order = currentOrder;
          isSuccess = true;
          break;
        case 4:
          print("Payment with credit card");
          print("insert your card");
          print("thank you");
          currentOrder.isPaid = true;
          currentOrder.paymentDate = DateTime.now();
          currentReservation.order = currentOrder;
          isSuccess = true;
          break;
        case 0:
          print("canceled");
          isSuccess = true;
          break;
        default:
          print("Invalid payment method");
          break;
      }
    } while (!isSuccess);
  }
}
