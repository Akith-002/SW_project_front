import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:land_asset_valuation/data/models/condition_report_model.dart';

class ConditionReportLocalDatabase {
  static Database? _database;
  static const String _tableName = 'condition_reports';
  static const String _dbName = 'condition_reports.db';
  static const int _dbVersion = 1;

  // Singleton pattern
  static final ConditionReportLocalDatabase _instance =
      ConditionReportLocalDatabase._internal();
  factory ConditionReportLocalDatabase() => _instance;
  ConditionReportLocalDatabase._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        masterFileId TEXT NOT NULL,
        nameOfTheVillage TEXT,
        nameOfTheLand TEXT,
        atPlanNumber TEXT,
        atLotNumber TEXT,
        ppCadNumber TEXT,
        ppCadLotNumber TEXT,
        acquiredExtent TEXT,
        assessmentNumber TEXT,
        roadName TEXT,
        accessCategory TEXT,
        accessCategoryDescription TEXT,
        descriptionOfLand TEXT,
        landUseDescription TEXT,
        landUseType TEXT,
        frontage TEXT,
        depthOfLand TEXT,
        levelWithAccess TEXT,
        plantationDetails TEXT,
        detailsOfBusiness TEXT,
        acquisitionName TEXT,
        datePrepared TEXT,
        dateOfSection3BA TEXT,
        boundaryNorth TEXT,
        boundaryEast TEXT,
        boundaryWest TEXT,
        boundarySouth TEXT,
        boundaryBottom TEXT,
        buildingDescription TEXT,
        buildingInfo TEXT,
        otherConstructionsDescription TEXT,
        otherConstructionsInfo TEXT,
        acquiringOfficerSignature TEXT,
        gramasewakaSignature TEXT,
        chiefValuerRepresentativeSignature TEXT,
        syncStatus TEXT DEFAULT 'pending',
        createdAt TEXT,
        syncedAt TEXT,
        errorMessage TEXT
      )
    ''');
  }

  Future<int> insertConditionReport(ConditionReportModel report) async {
    final db = await database;

    Map<String, dynamic> reportMap = report.toJson();
    reportMap['syncStatus'] = 'pending';
    reportMap['createdAt'] = DateTime.now().toIso8601String();

    return await db.insert(_tableName, reportMap);
  }

  Future<List<ConditionReportModel>> getPendingReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'syncStatus = ?',
      whereArgs: ['pending'],
      orderBy: 'createdAt ASC',
    );

    return maps.map((map) => ConditionReportModel.fromJson(map)).toList();
  }

  Future<List<ConditionReportModel>> getAllReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => ConditionReportModel.fromJson(map)).toList();
  }

  Future<void> markReportAsSynced(int localId) async {
    final db = await database;
    await db.update(
      _tableName,
      {
        'syncStatus': 'synced',
        'syncedAt': DateTime.now().toIso8601String(),
        'errorMessage': null,
      },
      where: 'id = ?',
      whereArgs: [localId],
    );
  }

  Future<void> markReportAsFailed(int localId, String errorMessage) async {
    final db = await database;
    await db.update(
      _tableName,
      {
        'syncStatus': 'failed',
        'errorMessage': errorMessage,
      },
      where: 'id = ?',
      whereArgs: [localId],
    );
  }

  Future<void> deleteReport(int localId) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [localId],
    );
  }

  Future<int> getPendingReportsCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName WHERE syncStatus = ?',
      ['pending'],
    );
    return result.first['count'] as int;
  }

  Future<void> clearSyncedReports() async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'syncStatus = ?',
      whereArgs: ['synced'],
    );
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
