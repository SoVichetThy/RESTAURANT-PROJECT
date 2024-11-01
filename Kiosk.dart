import 'dart:async';

import 'dart:io';

import 'model/customer.dart';
import 'foodItem.dart';
import 'model/manager.dart';
import 'model/menu.dart';
import 'enum/options.dart';
import 'model/order.dart';
import 'model/reservation.dart';
import 'model/table.dart';

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
    loader();
  }

  void loader() async {
    await showProgress("Loading...");
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
    String userAgree;
    try {
      do {
        print("Enter your name:");
        name = stdin.readLineSync().toString();
        print("Enter your phone number:");
        phoneNumber = stdin.readLineSync().toString();
        print("Enter your email (Optional):");
        email = stdin.readLineSync().toString();
        name != '' && phoneNumber != ''
            ? {
                print("are you sure you want the info is correct"),
                print("1. Yes\n2. press any thing"),
                userAgree = stdin.readLineSync().toString(),
                userAgree == 'yes' || userAgree == 'Yes' || userAgree == '1'
                    ? {
                        currentCustomer = Customer(
                            customerId: this.customer.length + 1,
                            name: name,
                            phoneNumber: phoneNumber,
                            email: email),
                        customer.add(currentCustomer),
                        print(
                            "User created successfully. Customer ID: ${customer[customer.length - 1]}"),
                        isValid = true
                      }
                    : {print("canceled"), isValid = false}
              }
            : print(
                '---------------------\nPlease enter your info again\n---------------------');
      } while (!isValid);
    } catch (e) {
      print('Error');
    }
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
                    // _welcomeMessage(),
                    print("----Option----\n"),
                    // stdout.close(),
                    managerMode(table, reservation, order, customer),
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
    bool isValidChoice = false;
    do {
      displayMenuItem(menu);
      try {
        print("Choose Any Item");
        choice = int.parse(stdin.readLineSync().toString());
        isValidChoice = (choice <= menu.length && choice >= 0);
        if (!isValidChoice) {
          print('please enter a right number!');
        } else if (choice != 0) {
          cart.add(foodItems[choice - 1]);
          stdout.writeln("your have: ${cart.length} items");
          // cart.forEach((element) {
          //   print(element);
          // });
        }
      } catch (e) {
        _printErrorMessage();
        print(e);
      }
    } while (cart.isEmpty || choice != 0);
    currentOrder.addItem(cart);
    cart.clear();
    currentOrder.calculateAmount();
    currentOrder.orderStatus = true;

    late String specialInstruction;
    print(
        '📝 Do you have any special instructions? (please press y or press anything to continue)');
    try {
      if (stdin.readLineSync().toString() == "y") {
        print('🟢 Please enter your special instructions:');
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

    pay();
  }

  void pay() {
    bool isSuccess = true;
    bool _recordPayment({required bool isSuccess, required int paymentChoice}) {
      isSuccess = true;
      currentOrder.isPaid = true;
      currentOrder.method = paymentMethod.values[paymentChoice - 1];
      currentOrder.paymentDate = DateTime.now();
      isDineIn ? currentReservation.order = currentOrder : null;
      isDineIn ? currentOrder.reservation = currentReservation : null;
      return isSuccess;
    }

    displayPaymentMethod();
    do {
      try {
        print("🟢 Select one payment to continue: ");
        int paymentChoice = int.parse(stdin.readLineSync().toString());

        switch (paymentChoice) {
          case 1:
            print("Payment with cash");
            print('Total Amount: ${currentOrder.totalAmount}\$');
            print("💰 Insert your money down below");
            print('Thank You ✨');
            isSuccess = _recordPayment(
                isSuccess: isSuccess, paymentChoice: paymentChoice);
            print(currentOrder);
            break;
          case 2:
            print("Pay with ABA");
            print('💰 Total Amount: ${currentOrder.totalAmount}\$');
            print(" Scan QR down below");
            print("Thank You ✨");
            isSuccess = _recordPayment(
                isSuccess: isSuccess, paymentChoice: paymentChoice);
            print(currentOrder);
            break;
          case 3:
            print("Pay with ACELIDA");
            print('💰 Total Amount: ${currentOrder.totalAmount}\$');
            print("scan QR down below");
            print("Thank You ✨");
            isSuccess = _recordPayment(
                isSuccess: isSuccess, paymentChoice: paymentChoice);
            print(currentOrder);
            break;
          case 4:
            print("Payment with credit card");
            print('💰 Total Amount: ${currentOrder.totalAmount}\$');
            print("insert your card");
            print("Thank You ✨");
            isSuccess = _recordPayment(
                isSuccess: isSuccess, paymentChoice: paymentChoice);
            print(currentOrder);
            break;
          case 0:
            print("❗️ Canceled ❗️");
            isSuccess = false;
            break;
          default:
            print("🚫 Invalid payment method");
            break;
        }
      } catch (e) {
        _printErrorMessage();
      }
    } while (!isSuccess);
  }

  void displayTable() {
    late int choice;
    int numberofGuest = 0;
    bool isSuccess = false;
    print('---Table display---\n');

    do {
      try {
        table.forEach((table) {
          if (table.isReady == true && table.isReserve == false)
            print(
                "Table [${table.tableNumber}] - Capacity: ${table.capacity.toString().padRight(3)}, Reserve: ${table.isReserve.toString().padRight(3)}, Ready: ${table.isReady.toString().padRight(3)}");
        });

        choice = int.parse(stdin.readLineSync().toString());
        if (!(choice < table.length &&
            choice >= 0 &&
            table[choice - 1].isReserve == false &&
            table[choice - 1].isReady == true)) {
          print('⚠️ Please enter a right number!');
        } else {
          isSuccess = true;
          do {
            print(" How many member do you have?!");
            try {
              numberofGuest = int.parse(stdin.readLineSync().toString());
            } catch (e) {
              print('\x1B[2J\x1B[0;0H');
              print("❌ Invalid number, please try AGAIN!!");
            }
          } while (!(numberofGuest >= 1));
          print("You have choose: Table [${choice}]\n");
          reserveTable(table, tableNumber: choice - 1);
          int generateReservationId = reservation.length + 1;

          currentReservation = Reservation(
            reservationId: generateReservationId,
            customerId: currentCustomer.customerId,
            reservationTime: DateTime.now(),
            tableNumber: choice,
            numberOfGuests: numberofGuest,
          );
          reservation.add(currentReservation);

          print('\x1B[2J\x1B[0;0H');
          print(currentReservation);
          stdout.write('Press enter to continue choosing your food...');
          stdin.readLineSync();
        }
      } catch (e) {
        _printErrorMessage();
      }
    } while (!isSuccess);
  }

  Future<void> showProgress(String message) async {
    const List<String> spinner = ['|', '/', '-', '\\'];
    const String cyan = '\x1B[36m'; // Cyan color for the spinner
    const String reset = '\x1B[0m'; // Reset color
    int i = 0;

    await Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
      if (i >= 15) {
        timer.cancel();
        stdout.write('\r\n✅ Done!\n'); // Move to new line when done
      } else {
        stdout.write('\r ${cyan}${spinner[i % spinner.length]} $message$reset');
        i++;
      }
    });
    await Future.delayed(Duration(milliseconds: 200) * 20);
  }
}
