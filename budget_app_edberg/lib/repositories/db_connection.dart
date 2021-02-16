import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_budgetapp_sqflite_5');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE `category` ( `category_id` INTEGER PRIMARY KEY AUTOINCREMENT, `category_name` varchar(255), `category_max_amount` INTEGER, `category_current_amount` INTEGER);");
    await database.execute(
        "CREATE TABLE `item` ( `item_id` INTEGER PRIMARY KEY AUTOINCREMENT, `item_name` varchar(255), `item_amount` INTEGER, `item_date` DATETIME, `category_id` INTEGER, FOREIGN KEY (category_id) REFERENCES category (category_id) );");
  }
}

// category

// category_id
// category_name
// category_current_amount
// category_max_amount

// item

// item_id
// item_name
// item_amount
// item_date
// category_id FK REF category_id
