import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:land_asset_valuation/data/models/building.dart';
import 'package:land_asset_valuation/data/services/building_service.dart';

void main() {
  group('BuildingService Tests', () {
    late BuildingService buildingService;

    setUp(() async {
      // Set up mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      buildingService = BuildingService();
    });

    test('should save and retrieve building successfully', () async {
      // Create test building
      final building = Building(
        id: 'test-123',
        name: 'Test Building',
        constructionType: 'Concrete',
        lotId: 'lot-456',
        masterFileNo: 'MF-789',
        coordinates: [
          Position(80.0, 6.0),
          Position(80.1, 6.0),
          Position(80.1, 6.1),
          Position(80.0, 6.1),
        ],
        createdAt: DateTime.now(),
      );

      // Save building
      final saveResult = await buildingService.saveBuilding(building);
      expect(saveResult, true);

      // Retrieve buildings for lot
      final buildings =
          await buildingService.getBuildingsForLot('lot-456', 'MF-789');
      expect(buildings.length, 1);
      expect(buildings.first.name, 'Test Building');
      expect(buildings.first.constructionType, 'Concrete');
      expect(buildings.first.masterFileNo, 'MF-789');
    });

    test('should handle multiple buildings for same lot', () async {
      // Create multiple buildings for same lot
      final building1 = Building(
        id: 'test-1',
        name: 'Building One',
        constructionType: 'Concrete',
        lotId: 'lot-123',
        masterFileNo: 'MF-001',
        coordinates: [Position(80.0, 6.0), Position(80.1, 6.0)],
        createdAt: DateTime.now(),
      );

      final building2 = Building(
        id: 'test-2',
        name: 'Building Two',
        constructionType: 'Wood',
        lotId: 'lot-123',
        masterFileNo: 'MF-001',
        coordinates: [Position(80.2, 6.0), Position(80.3, 6.0)],
        createdAt: DateTime.now(),
      );

      // Save both buildings
      await buildingService.saveBuilding(building1);
      await buildingService.saveBuilding(building2);

      // Retrieve buildings for lot
      final buildings =
          await buildingService.getBuildingsForLot('lot-123', 'MF-001');
      expect(buildings.length, 2);

      final names = buildings.map((b) => b.name).toList();
      expect(names, containsAll(['Building One', 'Building Two']));
    });

    test('should delete building successfully', () async {
      // Create and save building
      final building = Building(
        id: 'test-delete',
        name: 'Building to Delete',
        constructionType: 'Brick',
        lotId: 'lot-999',
        masterFileNo: 'MF-999',
        coordinates: [Position(80.0, 6.0)],
        createdAt: DateTime.now(),
      );

      await buildingService.saveBuilding(building);

      // Verify building exists
      var buildings =
          await buildingService.getBuildingsForLot('lot-999', 'MF-999');
      expect(buildings.length, 1);

      // Delete building
      final deleteResult = await buildingService.deleteBuilding('test-delete');
      expect(deleteResult, true);

      // Verify building is deleted
      buildings = await buildingService.getBuildingsForLot('lot-999', 'MF-999');
      expect(buildings.length, 0);
    });

    test('should handle empty lot gracefully', () async {
      final buildings = await buildingService.getBuildingsForLot(
          'nonexistent-lot', 'nonexistent-master');
      expect(buildings, isEmpty);
    });
  });
}
