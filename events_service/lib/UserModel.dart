import 'package:sqflite/sqflite.dart';

// provides absttraction for user settings ect
class UserModel {
  Database? db;

  UserModel() {
    connect();
  }

  Future connect() async {
    // user auth? switch on admin?
    String databasesPath = await getDatabasesPath();
    String path = '$databasesPath/events.db';

    db = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute('CREATE TABLE Attending (doc_id TEXT PRIMARY KEY)');

        // await db.execute(
        //     'INSERT INTO Event () VALUES ()');
      },
    );
  }

  Future<List<Map<String, Object?>>> getAttending() async {
    return (await db!.rawQuery('SELECT doc_id FROM Attending'));
  }

  Future<bool> isAttending(String evt_id) async {
    List<Map<String, Object?>> data = (await db!
        .rawQuery('SELECT doc_id FROM Attending WHERE doc_id = ?', [evt_id]));

    return data.isNotEmpty;
  }

  Future<void> attendEvent(String evt_id) async {
    await db!.execute('INSERT INTO Attending VALUES (?)', [evt_id]);
  }

  Future<void> delAttendence(String evt_id) async {
    await db!.execute('DELETE FROM Attending WHERE doc_id = ?', [evt_id]);
  }
}
