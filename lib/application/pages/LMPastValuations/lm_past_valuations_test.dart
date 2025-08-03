// Simple test file to verify LM Past Valuations implementation
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/pages/LMPastValuations/lm_past_valuations_view.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';

class LmPastValuationsTestPage extends StatelessWidget {
  const LmPastValuationsTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a mock MasterDataResponse for testing
    final mockMasterData = MasterDataResponse(
      buildingCategory: [],
      buildingClass: [],
      conviences: [],
      natureOfConstruction: [],
      roofMaterial: [],
      roofFrame: [],
      roofFinisher: [],
      celing: [],
      foundationStructure: [],
      wallStructure: [],
      floorStructure: [],
      door: [],
      window: [],
      windowProtection: [],
      doorsBathroomAndToiletFittings: [],
      doorsHandRail: [],
      doorsPantryCupboard: [],
      doorsOther: [],
      wallFinisher: [],
      floorFinisher: [],
      bathroomAndToilet: [],
      services: ['Service 1', 'Service 2'],
    );

    return LmPastValuationsView(masterData: mockMasterData);
  }
}
