import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:assignment1/models/stud_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const _tableName = 'students';
  static late stud user;
  static late File? profileImage = null;

  static Future<void> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'students_database.db');

    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        _database = db;
        if (kDebugMode) {
          print('Database created');
        }
        return _createDatabase(db); // create table
      },
      onOpen: (db) {
        _database = db;
      },
    );
  }

  static Future<void> _createDatabase(Database db) async {
    db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        gender TEXT,
        email TEXT NOT NULL,
        studentId TEXT NOT NULL,
        level INTEGER,
        password TEXT NOT NULL
      )
    ''').then((_) {
      if (kDebugMode) {
        print('Table created');
      }
    });
  }

  static Future<int> insertUser(stud user) async {
    int rowId = 0;
    try {
      await _database!.transaction(
        (txn) async {
          String sql =
              'INSERT INTO students(name, gender, email, studentId, level, password) '
              'VALUES("${user.name}", "${user.gender}", "${user.email}", "${user.studentId}", "${user.level}", "${user.password}")';
          txn.rawInsert(sql).then((id) {
            rowId = id;
            if (kDebugMode) {
              print('User $id inserted');
            }
          });
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    getUserByEmail(user.email);
    return rowId;
  }

  static Future<List<stud>> getStudents() async {
    String sql = 'SELECT * FROM students';
    List<stud> students = [];
    _database!.rawQuery(sql).then((allStudents) {
      for (var element in allStudents) {
        students.add(stud.fromMap(element));
      }

      if (kDebugMode) {
        print('Students fetched');
        print('\nStudents: $students');
      }
    });
    return students;
  }

  static Future<stud?> getUserByEmail(String email) async {
    String sql = 'SELECT * FROM students WHERE email = ?';
    var result = await _database!.rawQuery(sql, [email]);
    if (result.isNotEmpty) {
      user = stud.fromMap(result[0]);
      return stud.fromMap(result[0]);
    } else {
      return null;
    }
  }

  // static Future<void> updateUser(stud newUser) async {
  //   String sql = 'DELETE FROM students WHERE email = ?';
  //   int rowsAffected = await _database!.rawDelete(sql, [newUser.email]);

  //   if (rowsAffected > 0) {
  //     print('User has been deleted successfully.');
  //     insertUser(newUser);
  //     getUserByEmail(newUser.email);
  //   } else {
  //     print('No user found');
  //   }
  // }

  // update record
  static Future<void> updateUser(stud newUser) async {
    _database!.rawUpdate(
      // replace all ? with value from the list
      'UPDATE students SET name = ?, gender = ?,  email = ?, studentId = ?, level = ?, password = ? WHERE id = ?',
      [
        newUser.name,
        newUser.gender,
        newUser.email,
        newUser.studentId,
        newUser.level,
        newUser.password,
        user.id,
      ],
    ).then((value) {
      getUserByEmail(newUser.email);
    });
  }
}
