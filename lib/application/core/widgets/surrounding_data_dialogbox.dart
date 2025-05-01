import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupMenuWidget extends StatelessWidget {
  final void Function() onRentalEvidences;
  final void Function() onSalesEvidences;
  final void Function() onPastValuations;
  final void Function() onBuildingRates;

  const PopupMenuWidget({
    super.key,
    required this.onRentalEvidences,
    required this.onSalesEvidences,
    required this.onPastValuations,
    required this.onBuildingRates,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ClipPath(
              clipper: DialogClipper(),
              child: Container(
                width: 295,
                height: 241.28,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildListItem(
                      context,
                      "Rental Evidences",
                      Color(0xFF45A249),
                      onRentalEvidences,
                    ),
                    SizedBox(height: 12),
                    _buildListItem(
                      context,
                      "Sales Evidences",
                      Color(0xFFFF2830),
                      onSalesEvidences,
                    ),
                    SizedBox(height: 12),
                    _buildListItem(
                      context,
                      "Past Valuations",
                      Color(0xFFFFA600),
                      onPastValuations,
                    ),
                    SizedBox(height: 12),
                    _buildListItem(
                      context,
                      "Building Rates",
                      Color(0xFF069BF1),
                      onBuildingRates,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _safePop(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.pop(context);
  }
}

  Widget _buildListItem(
    BuildContext context,
    String title,
    Color color,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: () async{
        if (onTap != null) {
          onTap();
        }
      _safePop(context); // Use safe pop
      },
      child: Container(
        width: 255,
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}

class DialogClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double cornerRadius = 12;
    double pointerWidth = 16;
    double pointerHeight = 10;
    double pointerX = size.width / 2 - pointerWidth / 2;

    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height - pointerHeight),
        Radius.circular(cornerRadius)));

    path.moveTo(pointerX, size.height - pointerHeight);
    path.lineTo(pointerX + pointerWidth / 2, size.height);
    path.lineTo(pointerX + pointerWidth, size.height - pointerHeight);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
