import 'package:sqflite/sqflite.dart';

// provides absttraction for user settings ect
class UserModel {
  Database? db;

  UserModel();

  Future connect() async {
    // user auth? switch on admin?
    String databasesPath = await getDatabasesPath();
    String path = '$databasesPath/events.db';

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE Event (title TEXT, host TEXT, location TEXT)');

        // await db.execute(
        //     'INSERT INTO Event () VALUES ()');
      },
    );
  }

  Future getEvents() async {}

  Future addEvent(String title, String location) async {}

  Future editEvent() async {}
}
