import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final int completed;
  final int pending;

  const ActivityCard({
    super.key,
    required this.title,
    required this.completed,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.blue), // Icon for the activity
                const SizedBox(width: 8),
                Text(
                  '$title ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Column 1
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('$completed', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff394050))),
                        // const SizedBox(width: 4),
                        // Text('Completed', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Completed', style: TextStyle(fontSize: 14,fontFamily: 'roboto', fontWeight: FontWeight.normal, color: Color(0xff388E3C))),
                        // const SizedBox(width: 4),
                        // Text('Pending', style: TextStyle(color: Colors.orange)),
                      ],
                    ),
                  ],
                ),
                // Column 2 - You can add more details here if needed
              SizedBox(width: 24,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('$pending', style: TextStyle(fontSize: 22,fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Color(0xff394050))),
                        // const SizedBox(width: 4),
                        // Text('Pending', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Pending', style: TextStyle(fontSize: 14,fontFamily: 'Roboto', fontWeight: FontWeight.normal, color: Color(0xffA38505))),
                        // const SizedBox(width: 4),
                        // Text('Pending', style: TextStyle(color: Colors.orange)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
