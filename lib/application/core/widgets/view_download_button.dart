import 'package:flutter/material.dart';

class ViewDownloadWidget extends StatelessWidget {
  const ViewDownloadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconButton(
          imagePath: "images/pngs/eye-empty.png",
          backgroundColor: Colors.white,
          borderColor: const Color(0xffd0d5dd),
          iconColor: const Color(0xff4a4a4a),
          onPressed: () {
            debugPrint("View button pressed");
          },
        ),
        const SizedBox(width: 12),
        CustomIconButton(
          imagePath: "images/pngs/download.png",
          backgroundColor: const Color(0xFFDFF0FF),
          borderColor: const Color(0xff069bf1),
          iconColor: const Color(0xff007bce),
          onPressed: () {
            debugPrint("Download button pressed");
          },
        ),
      ],
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final String imagePath;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.imagePath,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Center(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            child: Image.asset(
              imagePath,
              width: 24.0,
              height: 24.0,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
