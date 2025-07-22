import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:land_asset_valuation/data/models/inspection_report_model.dart';

class InspectionReportLocalDatabase {
  static const String _databaseName = 'inspection_reports.db';
  static const int _databaseVersion = 1;
  static const String _tableName = 'inspection_reports';

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        inspectionReportId INTEGER,
        reportId INTEGER,
        masterFileId TEXT,
        masterFileRefNo TEXT,
        inspectionDate TEXT,
        dsDivision TEXT,
        district TEXT,
        province TEXT,
        gnDivision TEXT,
        village TEXT,
        buildings TEXT,
        otherInformation TEXT,
        otherConstructionDetails TEXT,
        detailsOfAssestsInventoryItems TEXT,
        detailsOfBusiness TEXT,
        remark TEXT,
        syncStatus TEXT DEFAULT 'pending',
        createdAt TEXT,
        syncedAt TEXT,
        errorMessage TEXT
      )
    ''');
  }

  Future<int> insertInspectionReport(InspectionReportModel report) async {
    final db = await database;

    Map<String, dynamic> reportMap = report.toJson();
    reportMap['buildings'] =
        report.buildings.map((b) => b.toJson()).toList().toString();
    reportMap['syncStatus'] = 'pending';
    reportMap['createdAt'] = DateTime.now().toIso8601String();

    return await db.insert(_tableName, reportMap);
  }

  Future<List<InspectionReportModel>> getPendingReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'syncStatus = ?',
      whereArgs: ['pending'],
      orderBy: 'createdAt ASC',
    );

    return maps.map((map) => _mapToInspectionReport(map)).toList();
  }

  Future<int> getPendingReportsCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName WHERE syncStatus = ?',
      ['pending'],
    );
    return result.first['count'] as int;
  }

  Future<List<InspectionReportModel>> getAllReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => _mapToInspectionReport(map)).toList();
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

  Future<void> clearSyncedReports() async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'syncStatus = ?',
      whereArgs: ['synced'],
    );
  }

  Future<List<InspectionReportModel>> getFailedReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'syncStatus = ?',
      whereArgs: ['failed'],
      orderBy: 'createdAt ASC',
    );

    return maps.map((map) => InspectionReportModel.fromJson(map)).toList();
  }

  InspectionReportModel _mapToInspectionReport(Map<String, dynamic> map) {
    // Note: This is a simplified mapping. In a real implementation,
    // you would need to properly parse the buildings JSON string back to objects
    return InspectionReportModel(
      inspectionReportId: map['inspectionReportId'],
      reportId: map['reportId'],
      masterFileId: map['masterFileId'] ?? '',
      masterFileRefNo: map['masterFileRefNo'] ?? '',
      inspectionDate: DateTime.parse(map['inspectionDate']),
      dsDivision: map['dsDivision'] ?? '',
      district: map['district'] ?? '',
      province: map['province'] ?? '',
      gnDivision: map['gnDivision'] ?? '',
      village: map['village'] ?? '',
      buildings: [], // TODO: Parse buildings JSON properly
      otherInformation: map['otherInformation'] ?? '',
      otherConstructionDetails: map['otherConstructionDetails'] ?? '',
      detailsOfAssestsInventoryItems:
          map['detailsOfAssestsInventoryItems'] ?? '',
      detailsOfBusiness: map['detailsOfBusiness'] ?? '',
      remark: map['remark'] ?? '',
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }
}
