part of 'restaurant.dart';

void _loadOptions(availableOptions) {
  List<String> temp = options.values.map((e) => e.toString()).toList();
  availableOptions.addAll(temp);
  print('done loading options');
}

void _loadTable(List<Table> table) {
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

void _printErrorMessage() {
  print('------------');
  print("⚠️ invalid choice");
  print('------------');
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

void manageTable(List<Table> table) {
  print("Manage Table");
  late int choice;
  do {
    try {
      table.asMap().forEach((key, value) {
        print('[${key + 1} $value]');
      });
      print('''
[1] ➕ Add Table
[2] ➖ Delete Table
[3] ✏️  Update Table
[0] 🚪 Exit Table Management
      ''');
      stdout.write('Enter your choice: ');

      choice = int.parse(stdin.readLineSync().toString());
      switch (choice) {
        case 1:
          stdout.write("Enter Table Capacity (2-10): ");
          int capacity = int.parse(stdin.readLineSync().toString());

          if (capacity >= 2 && capacity <= 10) {
            Table newTable = Table(
                capacity: capacity,
                isReady: true,
                isReserve: false,
                tableNumber: table.length + 1);
            table.add(newTable);
            print("✅ Table added successfully!");
          } else {
            print("⚠️ Capacity must be between 2 and 10.");
          }
          break;
        case 2:
          stdout.write("Enter Table Number to delete: ");
          int deleteTableNumber =
              int.parse(stdin.readLineSync().toString()) - 1;

          if (deleteTableNumber >= 0 && deleteTableNumber < table.length) {
            print('Table ${table[deleteTableNumber]} will be deleted.');
            table.removeAt(deleteTableNumber);
            print("✅ Table deleted successfully!");
          } else {
            _printErrorMessage();
          }
        case 3:
          int updateOption = 0;
          int updateTableNumber = 0;
          bool isValid = true;
          do {
            try {
              stdout.write("Enter tableNumber to Update: ");
              updateTableNumber =
                  int.parse(stdin.readLineSync().toString()) - 1;
              isValid =
                  (updateTableNumber > 0 && updateTableNumber <= table.length);
              if (!(updateTableNumber > 0 &&
                  updateTableNumber <= table.length)) {
                throw Exception('');
              }
            } catch (e) {
              _printErrorMessage();
            }
          } while (!isValid);
          _updateTableOption(
              updateOption: updateOption,
              table: table,
              updateTableNumber: updateTableNumber);
          break;
        default:
      }
    } catch (e) {
      _printErrorMessage();
    }
  } while (choice != 0);
}

void _updateTableOption(
    {required int updateOption,
    required List<Table> table,
    required int updateTableNumber}) {
  do {
    try {
      print('''
👉🏻  Update Table ${table[updateTableNumber]} 👈🏻
[1] Update Capacity
[2] Toggle Reservation Status
[3] Toggle Ready Status
[4] Exit
  ''');
      updateOption = int.parse(stdin.readLineSync().toString());
      switch (updateOption) {
        case 1:
          int newCapacity = 0;
          do {
            try {
              stdout.write("Enter new Table Capacity(2-20): ");
              newCapacity = int.parse(stdin.readLineSync().toString());
              if ((newCapacity > 0 && newCapacity <= 20)) {
                table[updateTableNumber].capacity = newCapacity;
                print("✅ Success");
              }
              else{
              }
            } catch (e) {
              _printErrorMessage();
            }
          } while (!(newCapacity > 0 && newCapacity <= 20));
          break;
        case 2:
          if (table.length >= updateTableNumber && updateTableNumber >= 0) {
            table[updateTableNumber].setRerserve();
            print("✅ Success");
          } else {
            print('Invalid table number');
          }
          break;
        case 3:
          if (table.length >= updateTableNumber && updateTableNumber >= 0) {
            table[updateTableNumber].setReady();
            print("✅ Success");
          } else {
            print('Invalid table number');
          }
          break;
        case 4:
          print('Exit');
          break;
        default:
          print('invalid');
          break;
      }
    } catch (e) {
      _printErrorMessage();
    }
  } while (updateOption != 4);
}

void displayMenuItem(List<Menu> menu) {
  print('[---Display Menu---]\n');
  menu.asMap().forEach((key, value) {
    print("[${key + 1}] ${value.name} - ${value.price.toString()}\$");
  });
}

void displayPaymentMethod() {
  print('[---Pay to complete the order---]');
  paymentMethod.values.asMap().forEach((key, value) {
    print("[${key + 1}] - ${value}");
  });
}

void reserveTable(List<Table> table, {required int tableNumber}) {
  print('-- table reserve -- ');
  table.elementAt(tableNumber).isReserve = true;
  table.elementAt(tableNumber).isReady = false;
}

void managerMode(List<Table> table, List<Reservation> reservation,
    List<Order> order, List<Customer> customer) {
  late int choice;

  do {
    try {
      print('1. manage table');
      print('2. View all reservation');
      print('3. View all order');
      print('4. View All Customer');
      print('0. Exit');
      stdout.write("Enter your chioce: ");
      choice = int.parse(stdin.readLineSync().toString());
      switch (choice) {
        case 1:
          showProgress("fetching table...");
          manageTable(table);
          break;
        case 2:
          reservation.length >= 1
              ? reservation.asMap().forEach((key, value) {
                  print('[$key]-$value');
                })
              : print('there isn\'t any reservation yet');
          break;
        case 3:
          order.length >= 1
              ? order.asMap().forEach((key, value) {
                  print('[$key]-$value');
                })
              : print('there is no order yet');
          break;
        case 4:
          customer.length >= 1
              ? customer.asMap().forEach((key, value) {
                  print('[$key]-$value');
                })
              : print('there is no customer yet');
          break;
        case 0:
          print("Log out from admin");
        default:
      }
    } catch (e) {
      _printErrorMessage();
    }
  } while (choice != 0);
}

Future<void> showProgress(String message) async {
  const List<String> spinner = ['|', '/', '-', '\\'];
  const String cyan = '\x1B[36m';
  const String reset = '\x1B[0m';
  int i = 0;

  // Create a completer to signal when the timer is done
  Completer<void> completer = Completer<void>();

  Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
    if (i >= 15) {
      timer.cancel();
      stdout.write('\r\n done!\n');
      completer.complete();
    } else {
      stdout.write('\r ${cyan}${spinner[i % spinner.length]} $message$reset');
      i++;
    }
  });
  await completer.future;
}
