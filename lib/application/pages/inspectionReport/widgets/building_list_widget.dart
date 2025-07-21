import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/data/models/building.dart';

class BuildingListWidget extends StatelessWidget {
  final List<Building> buildings;
  final Function(Building) onBuildingSelected;
  final Function(String) isBuildingFormComplete;

  const BuildingListWidget({
    super.key,
    required this.buildings,
    required this.onBuildingSelected,
    required this.isBuildingFormComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Buildings (${buildings.length})",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors(context).colorBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: buildings.length,
              itemBuilder: (context, index) {
                final building = buildings[index];
                final isComplete = isBuildingFormComplete(building.id);
                return InkWell(
                  onTap: () => onBuildingSelected(building),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Completion status indicator
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isComplete
                                ? Colors.green
                                : Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            building.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: colors(context).colorBlack,
                            ),
                          ),
                        ),
                        Text(
                          building.id,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isComplete)
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: colors(context).colorBlack ?? Colors.black54,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NoBuildingsWidget extends StatelessWidget {
  final VoidCallback onGoBack;

  const NoBuildingsWidget({
    super.key,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No buildings found for this lot",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Draw buildings in the map sketch tools first",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: "Go Back to Map",
              onPressed: onGoBack,
              backgroundColor: colors(context).colorPrimary1!,
              width: 200,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
