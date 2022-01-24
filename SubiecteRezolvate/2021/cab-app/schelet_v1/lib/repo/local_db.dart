import 'package:schelet_v1/domain/entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDB{
  static final LocalDB instance = LocalDB._init();

  static Database? _database;

  LocalDB._init();

  Future<Database> get database async {
    if(_database!=null)
      return _database!;
    _database = await _initDB('exam.db');
    return _database!;
  }

  Future<Database> _initDB(String filename) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filename);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT';
    const intType = 'INTEGER';


    await db.execute('''
      CREATE TABLE $tableName (
      ${VehicleFields.id} $idType,
      ${VehicleFields.license} $textType,
      ${VehicleFields.status} $textType,
      ${VehicleFields.driver} $textType,
      ${VehicleFields.cargo} $intType,
      ${VehicleFields.color} $textType,
      ${VehicleFields.seats} $intType
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<Vehicle> create(Vehicle entity) async{
    final db = await instance.database;
    final id = await db.insert(tableName, entity.toJson());

    return entity.copy(id: id);
  }

  Future<Vehicle> update(Vehicle entity) async{
    final db = await instance.database;
    await db.update(tableName, entity.toJson() ,where: '$VehicleFields.id = ?', whereArgs: [entity.id]);
    return entity;
  }

  Future<void> empty() async {
    final db = await instance.database;
    await db.delete(tableName);
  }

  Future<List<Vehicle>> getAll() async {
    final db = await instance.database;
    final result = await db.query(tableName);
    return result.map((json) => Vehicle.fromJson(json)).toList();
  }

  Future<int> delete(int id) async{
    final db = await instance.database;
    return db.delete(tableName, where: "${VehicleFields.id} = ?", whereArgs: [id]);
  }


}