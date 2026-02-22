import'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ToDoDatabase{

  Future<Database> createDB()async{
    Database db = await openDatabase(
      join(await getDatabasesPath(),"todoDB.db"),
      version: 1,
      onCreate: (db,version){
        db.execute(
          '''
            CREATE TABLE Todo(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            date TEXT
            )
          '''
        );
      },
    );

    return db;
  }


  Future<List<Map>> getTodoItems() async {
    Database localDB = await createDB();
    List<Map>list= await localDB.query("Todo");
    return list;
  }

  void insertTodoItem(Map<String,dynamic>obj)async{
    Database localDB = await createDB();
    await localDB.insert("Todo",obj,conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateTodoItem(Map<String,dynamic>obj)async{
    Database localDB = await createDB();
    await localDB.update("Todo",obj,where:"id=?", whereArgs:[obj['id']]);
  }

  Future<void>deleteTodoItem(int index)async{
    Database db = await createDB();
    await db.delete("Todo",where: "id=?",whereArgs: [index]);
  }

}