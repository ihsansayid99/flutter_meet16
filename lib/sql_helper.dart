import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE db_mahasiswa(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nim TEXT,
      name TEXT,
      tugas DOUBLE,
      uts DOUBLE,
      uas DOUBLE,
      nilaiAkhir DOUBLE
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('db_mahasiswa.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> createMahasiswa(String nim, String name, double tugas,
      double uts, double uas, double nilaiAkhir) async {
    final db = await SQLHelper.db();

    final data = {
      'nim': nim,
      'name': name,
      'tugas': tugas,
      'uts': uts,
      'uas': uas,
      'nilaiAkhir': nilaiAkhir
    };
    final id = await db.insert('db_mahasiswa', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('db_mahasiswa', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('db_mahasiswa', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String nim, String name, double tugas,
      double uts, double uas, double nilaiAkhir) async {
    final db = await SQLHelper.db();

    final data = {
      'nim': nim,
      'name': name,
      'tugas': tugas,
      'uts': uts,
      'uas': uas,
      'nilaiAkhir': nilaiAkhir,
    };

    final result =
        await db.update('db_mahasiswa', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete('db_mahasiswa', where: "id = ?", whereArgs: [id]);
    } catch (e) {
      debugPrint("Something went wrong when deleting an data : $e");
    }
  }
}
