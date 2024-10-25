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
  print("invalid choice");
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
      1. Add table
      2. Delete table
      3. Update table
      0. Exit Table managment
      ''');

      choice = int.parse(stdin.readLineSync().toString());
      switch (choice) {
        case 1:
          print("Enter Table Capacity");
          int capacity = int.parse(stdin.readLineSync().toString());
          Table newTable = Table(
              capacity: capacity,
              isReady: true,
              isReserve: false,
              tableNumber: table.length + 1);
          table.add(newTable);
          print('Table added successfully');
          break;
        case 2:
          print("Enter Table Number to delete:");
          int deleteTableNumber =
              int.parse(stdin.readLineSync().toString()) - 1;
          print('${table[deleteTableNumber]} will be deleted');
          table.removeAt(deleteTableNumber);
          break;
        case 3:
          print("Enter tableNumber to delete: ");
          int updateTableNumber =
              int.parse(stdin.readLineSync().toString()) - 1;
          print("Enter new Table Capacity: ");
          int newCapacity = int.parse(stdin.readLineSync().toString());
          table[updateTableNumber].capacity = newCapacity;
          print(table[updateTableNumber]);
          break;
        default:
      }
    } catch (e) {
      _printErrorMessage();
    }
  } while (choice != 0);
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

Future<void> managerMode(List<Table> table, List<Reservation> reservation,
    List<Order> order, List<Customer> customer) async {
  late int choice;

  do {
    try {
      print("Enter your chioce: ");
      print('1. manage table');
      print('2. View all reservation');
      print('3. View all order');
      print('4. View All Customer');
      print('0. Exit');
      choice = int.parse(stdin.readLineSync().toString());
      switch (choice) {
        case 1:
          await showProgress("fetching table...");
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
