import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:land_asset_valuation/data/models/building.dart';

class BuildingService {
  static const String _buildingsKey = 'saved_buildings';

  /// Get all buildings for a specific lot and master file
  Future<List<Building>> getBuildingsForLot(
      String lotId, String masterFileNo) async {
    try {
      print(
          '🔍 Looking for buildings - Lot ID: $lotId, Master File: $masterFileNo');

      final prefs = await SharedPreferences.getInstance();
      final buildingsJson = prefs.getString(_buildingsKey) ?? '[]';
      final List<dynamic> buildingsList = json.decode(buildingsJson);

      print('   Total buildings in storage: ${buildingsList.length}');

      for (int i = 0; i < buildingsList.length; i++) {
        final building = Building.fromJson(buildingsList[i]);
        print(
            '   Building $i: ${building.name} (Lot: ${building.lotId}, Master: ${building.masterFileNo})');
      }

      final matchingBuildings = buildingsList
          .map((json) => Building.fromJson(json))
          .where((building) =>
              building.lotId == lotId && building.masterFileNo == masterFileNo)
          .toList();

      print('   Found ${matchingBuildings.length} matching buildings');

      return matchingBuildings;
    } catch (e) {
      print('❌ Error getting buildings for lot: $e');
      return [];
    }
  }

  /// Save a new building to SharedPreferences
  Future<bool> saveBuilding(Building building) async {
    try {
      print('🏗️ SaveBuilding called with: ${building.name}');
      print('   Building ID: ${building.id}');
      print('   Lot ID: ${building.lotId}');
      print('   Master File: ${building.masterFileNo}');
      print('   Coordinates count: ${building.coordinates.length}');

      final prefs = await SharedPreferences.getInstance();
      final buildingsJson = prefs.getString(_buildingsKey) ?? '[]';
      final List<dynamic> buildingsList = json.decode(buildingsJson);

      print('   Existing buildings count: ${buildingsList.length}');

      // Add the new building
      buildingsList.add(building.toJson());

      // Save back to SharedPreferences
      await prefs.setString(_buildingsKey, json.encode(buildingsList));

      print('✅ Building saved successfully: ${building.name}');
      print('   Total buildings in storage: ${buildingsList.length}');
      return true;
    } catch (e) {
      print('❌ Error saving building: $e');
      return false;
    }
  }

  /// Delete a building by ID
  Future<bool> deleteBuilding(String buildingId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final buildingsJson = prefs.getString(_buildingsKey) ?? '[]';
      final List<dynamic> buildingsList = json.decode(buildingsJson);

      // Remove the building with matching ID
      buildingsList.removeWhere((json) => json['id'] == buildingId);

      // Save back to SharedPreferences
      await prefs.setString(_buildingsKey, json.encode(buildingsList));

      print('Building deleted successfully: $buildingId');
      return true;
    } catch (e) {
      print('Error deleting building: $e');
      return false;
    }
  }

  /// Get all buildings (for debugging)
  Future<List<Building>> getAllBuildings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final buildingsJson = prefs.getString(_buildingsKey) ?? '[]';
      final List<dynamic> buildingsList = json.decode(buildingsJson);

      return buildingsList.map((json) => Building.fromJson(json)).toList();
    } catch (e) {
      print('Error getting all buildings: $e');
      return [];
    }
  }

  /// Clear all buildings (for debugging)
  Future<bool> clearAllBuildings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_buildingsKey);
      print('All buildings cleared');
      return true;
    } catch (e) {
      print('Error clearing buildings: $e');
      return false;
    }
  }

  /// Clear buildings for a specific master file
  Future<bool> clearBuildingsForMasterFile(String masterFileNo) async {
    try {
      print('🗑️ Clearing buildings for master file: $masterFileNo');

      final prefs = await SharedPreferences.getInstance();
      final buildingsJson = prefs.getString(_buildingsKey) ?? '[]';
      final List<dynamic> buildingsList = json.decode(buildingsJson);

      print('   Buildings before clearing: ${buildingsList.length}');

      // Remove buildings that match the master file number
      buildingsList.removeWhere((json) => json['masterFileNo'] == masterFileNo);

      print('   Buildings after clearing: ${buildingsList.length}');

      // Save back to SharedPreferences
      await prefs.setString(_buildingsKey, json.encode(buildingsList));

      print('✅ Buildings cleared for master file: $masterFileNo');
      return true;
    } catch (e) {
      print('❌ Error clearing buildings for master file: $e');
      return false;
    }
  }
}
