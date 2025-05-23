import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';

class Breadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const Breadcrumb({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 41,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors(context).colorGrey9 ?? Color(0xFFF3F4F6),
        // borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'images/pngs/home-simple-door.png',
            width: 16,
            height: 16,
          ),
          SizedBox(width: 8),
          ...items.expand((item) {
            int index = items.indexOf(item);
            bool isLast = index == items.length - 1;
            return [
              GestureDetector(
                onTap: item.onTap,
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    color: isLast
                        ? colors(context).colorPrimary6 ?? Color(0xFF007BCE)
                        : colors(context).colorGrey2 ?? Color(0xFF394050),
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child:
                      Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                ),
            ];
          })
        ],
      ),
    );
  }
}

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  BreadcrumbItem({required this.label, this.onTap});
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Breadcrumb Example")),
        body: Center(
          child: Breadcrumb(
            items: [
              BreadcrumbItem(label: "Land Acquisition", onTap: () {}),
              BreadcrumbItem(label: "Master File - #56249", onTap: () {}),
              BreadcrumbItem(label: "Condition Report #1234", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
