import 'package:flutter/material.dart';

class MeasurementInfoBox extends StatelessWidget {
  final String? distance;
  final String? bearing;
  final String? area;

  const MeasurementInfoBox({
    super.key,
    this.distance,
    this.bearing,
    this.area,
  });

  @override
  Widget build(BuildContext context) {
    if (distance == null && bearing == null && area == null) return SizedBox();

    return Container(
      width: 201,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (distance != null)
            _buildText("Distance", distance!),
          if (bearing != null)
            _buildText("Bearing", bearing!),
          if (area != null)
            _buildText("Lot Area", area!),
        ],
      ),
    );
  }

  Widget _buildText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(text: "$label: ", style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
