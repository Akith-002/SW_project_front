import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class OverviewChart extends StatelessWidget {
  final double landAcquisition;
  final double massRating;
  final double miscAcquisition;
  final double tasksDone;

  const OverviewChart({
    super.key,
    required this.landAcquisition,
    required this.massRating,
    required this.miscAcquisition,
    required this.tasksDone,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center, // Aligns items to the top
      children: [
        SizedBox(
          height: 128,
          width: 128,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 50, // Adjust if needed
              sections: [
                PieChartSectionData(
                    value: landAcquisition,
                    color: Colors.green,
                    radius: 15,
                    title: ''),
                PieChartSectionData(
                    value: massRating,
                    color: Colors.red,
                    radius: 15,
                    title: ''),
                PieChartSectionData(
                    value: miscAcquisition,
                    color: Colors.blue,
                    radius: 15,
                    title: ''),
                PieChartSectionData(
                    value: tasksDone,
                    color: Colors.grey,
                    radius: 15,
                    title: ''),
              ],
            ),
          ),
        ),
        const SizedBox(width: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Land Acquisition', Colors.green),
            _buildLabel('Mass Rating', Colors.red),
            _buildLabel('Miscellaneous Acquisition', Colors.blue),
            _buildLabel('Tasks Done', Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 6), // Reduced vertical padding
      child: Row(
        children: [
          Container(
            width: 12,
            height: 15,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
