import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'), 
      home: Scaffold(
        appBar: AppBar(title: Text("Dialog Example")),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CustomDialog(),
              );
            },
            child: Text("Show Dialog"),
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), 
      ),
      child: Container(
        width: 201,
        height: 142,
        padding: EdgeInsets.all(16), 
        decoration: BoxDecoration(
          color:colors(context).colorWhite?? Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26, 
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Distance: 35 ft 9 inch",
                style: TextStyle(fontSize: 15, fontFamily: 'Roboto')),
            SizedBox(height: 20), 
            Text("Bearing : 150.51°",
                style: TextStyle(fontSize: 15, fontFamily: 'Roboto')),
            SizedBox(height: 20), 
            Text("Lot Area : 64 ft 19 inch",
                style: TextStyle(fontSize: 15, fontFamily: 'Roboto')),
          ],
        ),
      ),
    );
  }
}
