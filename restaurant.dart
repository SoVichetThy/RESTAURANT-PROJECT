import 'dart:async';
import 'dart:io';

import 'customer.dart';
import 'foodItem.dart';
import 'manager.dart';
import 'menu.dart';
import 'options.dart';
import 'order.dart';
import 'reservation.dart';
import 'table.dart';

part 'extender.dart';

class Kiosk {
  final List<String> availableOptions = [];
  final double taxRate = 0.08;
  final List<Table> table = [];
  final List<Reservation> reservation = [];
  final List<Order> order = [];
  final List<Manager> manager = [];
  final List<Customer> customer = [];
  final List<Menu> menu = [];

  bool isDineIn = true;

  late Order currentOrder;
  late Customer currentCustomer;
  late Reservation currentReservation;

  Kiosk() {
    _loadTable(table);
    _loadOptions(availableOptions);
    _welcomeMessage();
    _userInput();
  }

  void _CreateUser() {
    bool isValid = false;
    String name;
    String phoneNumber;
    String email;
    try {
      do {
        print("Enter your name:");
        name = stdin.readLineSync().toString();
        print("Enter your phone number:");
        phoneNumber = stdin.readLineSync().toString();
        print("Enter your email (Optional):");
        email = stdin.readLineSync().toString();
        name != '' && phoneNumber != ''
            ? isValid = true
            : print(
                '---------------------\nPlease enter your info again\n---------------------');
      } while (!isValid);
      bool isSuccess;

      print("are you sure you want the info is correct");
      print("1. Yes\n2. No");
      isSuccess =
          int.parse(stdin.readLineSync().toString()) == 1 ? true : false;
      isSuccess
          ? {
              currentCustomer = Customer(
                  customerId: this.customer.length + 1,
                  name: name,
                  phoneNumber: phoneNumber,
                  email: email),
              customer.add(currentCustomer),
              print(
                  "User created successfully. Customer ID: ${customer[customer.length - 1]}")
            }
          : print("canceled");
    } catch (e) {
      print("invalide choice");
    }
  }

  void _userInput() async {
    int option;
    bool isStopProgramming = true;

    // loop to get the right option from customer
    //|
    do {
      for (int i = 0; i < availableOptions.length; i++) {
        print("${i + 1}. ${availableOptions[i]}");
      }
      try {
        print("Please select an option:");
        option = int.parse(stdin.readLineSync().toString());

        switch (option) {
          case 1:
            isDineIn = true;
            _CreateUser();
            displayTable();
            displayMenu();

            break;
          case 2:
            isDineIn = false;
            _CreateUser();
            print('success');
            displayMenu();
            break;
          case 3:
            print("Enter Username: ");
            String username = stdin.readLineSync().toString();
            print("Enter Password:");
            String password = stdin.readLineSync().toString();
            username == "vichet" && password == "123"
                ? {
                    print("[---Welcome Manager---]"),
                    await managerMode(table, reservation, order, customer),
                  }
                : print('Invalid username or password');
            break;
          case 4:
            print("Thank you! Have a great day!");
            isStopProgramming = false;
            break;
          default:
            print("$option is Invalid option. Please enter 1 or 2.");
            break;
        }
      } catch (e) {
        _printErrorMessage();
      }
    } while (isStopProgramming);
    //|
  }

  void displayMenu() {
    List<Menu> cart = [];
    late int choice;
    menu.addAll(foodItems);
    // create new empty order

    isDineIn
        ? currentOrder = Order(
            orderId: order.length + 1,
            customerId: currentCustomer.customerId,
            orderTime: DateTime.now(),
            reservation: currentReservation,
            isPaid: false)
        : currentOrder = Order(
            orderId: order.length + 1,
            customerId: currentCustomer.customerId,
            orderTime: DateTime.now(),
            isPaid: false);

    // display
    displayMenuItem(menu);

    do {
      try {
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
      } catch (e) {
        _printErrorMessage();
      }
    } while (choice != 0);
    currentOrder.addItem(cart);
    currentOrder.calculateAmount();
    currentOrder.orderStatus = true;

    String specialInstruction = '';
    print('Do you have any special instructions? (please press y)');
    try {
      if (stdin.readLineSync().toString() == "y") {
        print('Please enter your special instructions:');
        specialInstruction = stdin.readLineSync().toString();
        currentOrder.specialInstructions = specialInstruction;
      } else {
        currentOrder.specialInstructions = "No special instructions";
      }
    } catch (e) {
      _printErrorMessage();
    }
    // add order to history
    order.add(currentOrder);
    print(currentOrder);

    pay();
  }

  void pay() {
    bool isSuccess = false;
    displayPaymentMethod();
    do {
      try {
        print("Select one payment to continue: ");
        int paymentChoice = int.parse(stdin.readLineSync().toString());

        switch (paymentChoice) {
          case 1:
            print("Payment with cash: 50.00");
            print("insert your money down below");
            print('Thank you');
            isSuccess = true;
            currentOrder.isPaid = true;
            currentOrder.method = paymentMethod.values[paymentChoice];
            currentOrder.paymentDate = DateTime.now();
            isDineIn ? currentReservation.order = currentOrder : null;
            isDineIn ? currentOrder.reservation = currentReservation : null;
            break;
          case 2:
            print("Pay with ABA");
            print("scan QR down below");
            print("thank you");
            currentOrder.isPaid = true;
            currentOrder.paymentDate = DateTime.now();
            isDineIn ? currentReservation.order = currentOrder : null;
            isDineIn ? currentOrder.reservation = currentReservation : null;
            isSuccess = true;
            break;
          case 3:
            print("Pay with ACELIDA");
            print("scan QR down below");
            print("thank you");
            currentOrder.isPaid = true;
            currentOrder.paymentDate = DateTime.now();
            isDineIn ? currentReservation.order = currentOrder : null;
            isDineIn ? currentOrder.reservation = currentReservation : null;
            isSuccess = true;
            break;
          case 4:
            print("Payment with credit card");
            print("insert your card");
            print("thank you");
            currentOrder.isPaid = true;
            currentOrder.paymentDate = DateTime.now();
            isDineIn ? currentReservation.order = currentOrder : null;
            isDineIn ? currentOrder.reservation = currentReservation : null;
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
      } catch (e) {
        _printErrorMessage();
      }
    } while (!isSuccess);
  }

  void displayTable() {
    late int choice;
    int numberofGuest;
    bool isSuccess = false;
    print('---Table display---\n');

    do {
      try {
        table.forEach((table) {
          print(
              "Table [${table.tableNumber}] - Capacity: ${table.capacity.toString().padRight(3)}, Reserve: ${table.isReserve.toString().padRight(3)}, Ready: ${table.isReady.toString().padRight(3)}");
        });
        choice = int.parse(stdin.readLineSync().toString()) - 1;
        if (choice >= table.length && choice >= 0) {
          print('please enter a right number!');
        } else {
          isSuccess = true;
        }
      } catch (e) {
        _printErrorMessage();
      }
    } while (!isSuccess);

    print("please enter your customer number!");
    numberofGuest = int.parse(stdin.readLineSync().toString()) - 1;
    print("You have choose: Table [${choice + 1}]\n");
    reserveTable(table, tableNumber: choice);

    if (isSuccess) {
      int generateReservationId = reservation.length + 1;

      currentReservation = Reservation(
        reservationId: generateReservationId,
        customerId: currentCustomer.customerId,
        reservationTime: DateTime.now(),
        tableNumber: choice + 1,
        numberOfGuests: numberofGuest + 1,
      );
      reservation.add(currentReservation);

      print(reservation.last);
    }
  }

  Future<void> showProgress(String message) async {
    const List<String> spinner = ['|', '/', '-', '\\'];
    const String cyan = '\x1B[36m'; // Cyan color for the spinner
    const String reset = '\x1B[0m'; // Reset color
    int i = 0;

    Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
      if (i >= 15) {
        timer.cancel();
        stdout.write('\r\n done!\n'); // Move to new line when done
      } else {
        // Print the icon in cyan color
        stdout.write(
            '\r ${cyan}${spinner[i % spinner.length]} $message$reset'); // Clear line and rewrite
        i++;
      }
    });
    await Future.delayed(Duration(milliseconds: 200) * 20);
  }
}
