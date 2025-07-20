import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For number formatting
// For floor function

class LotAreaWidget extends StatelessWidget {
  final double area; // In square meters
  final double lastDistance; // In meters

  const LotAreaWidget({
    super.key,
    required this.area,
    required this.lastDistance,
  });

  // --- Conversion Factors ---
  static const double _metersToFeet = 3.28084;
  // static const double _sqMetersToSqFeet = 10.7639; // Keep for reference if needed

  // More precise conversions for ft²/in² calculation
  static const double _metersToInches = 39.3701;
  static const double _sqMetersToSqInches =
      1550.003; // Roughly (_metersToInches)^2
  static const int _sqInchesPerSqFoot = 144; // 12 * 12

  @override
  Widget build(BuildContext context) {
    // --- Calculations ---

    // 1. Area Calculation (m² to ft² and in²)
    final double totalSqInches = area * _sqMetersToSqInches;
    final int areaSqFeetPart = (totalSqInches / _sqInchesPerSqFoot).floor();
    // Calculate remaining square inches
    final double remainingSqInches =
        totalSqInches - (areaSqFeetPart * _sqInchesPerSqFoot);
    // Round remaining sq inches for display
    final int areaSqInchesPart = remainingSqInches.round();

    // Handle potential rollover if rounded sq inches reach 144 (unlikely but possible)
    int finalAreaSqFeet = areaSqFeetPart;
    int finalAreaSqInches = areaSqInchesPart;
    if (finalAreaSqInches >= _sqInchesPerSqFoot) {
      finalAreaSqFeet += (finalAreaSqInches / _sqInchesPerSqFoot).floor();
      finalAreaSqInches = finalAreaSqInches % _sqInchesPerSqFoot;
    }

    // 2. Distance Calculation (m to feet and inches) - Same as before
    final double totalFeet = lastDistance * _metersToFeet;
    final int feetPart = totalFeet.floor();
    final double decimalInches = (totalFeet - feetPart) * 12.0;
    int inchesPart = decimalInches.round();

    int finalDistFeet = feetPart;
    if (inchesPart == 12) {
      finalDistFeet++;
      inchesPart = 0;
    }

    // --- Formatting ---

    // Format Area: Use NumberFormat for the ft² part for large numbers
    final numberFormatFeet = NumberFormat("#,##0", "en_US");
    final formattedAreaSqFeet = numberFormatFeet.format(finalAreaSqFeet);
    // Format Area string like X ft² Y in²
    final formattedArea = "$formattedAreaSqFeet ft $finalAreaSqInches in";

    // Format distance string as X' Y" - Same as before
    final formattedDistance = "$finalDistFeet' $inchesPart\"";

    // Determine if values are meaningful (using original meter thresholds)
    bool showArea = area > 0.01;
    bool showDistance = lastDistance > 0.01;

    return Card(
      elevation: 4.0,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),

            // Display Area in ft² in²
            if (showArea)
              Text(
                'Lot Area: $formattedArea', // Updated Format
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.black87),
              ),

            if (showArea) const SizedBox(height: 4),

            // Display Distance in ft' in"
            if (showDistance)
              Text(
                'Last Segment: $formattedDistance', // Same Format
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.black87),
              ),

            // Show placeholder only if BOTH original values are negligible
            if (!showArea && !showDistance)
              Text(
                'Start drawing...',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }
}
