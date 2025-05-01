import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String number;
  final String title;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.number,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 236,
      height: 95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xffE5E7EA), width:1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // First row: Icon
            Row(
              children: [
                Icon(
                  icon,
                  size: 24.0,
                  color: Colors.blueGrey,
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Second row: Number
            Row(
              children: [
                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Third row: Title
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle overflow in case title is too long
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
