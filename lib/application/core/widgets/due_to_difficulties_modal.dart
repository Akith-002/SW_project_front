import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';

class DueToDifficultiesModal extends StatefulWidget {
  final TextEditingController newNoController;
  final VoidCallback onSave;

  const DueToDifficultiesModal({
    super.key,
    required this.newNoController,
    required this.onSave,
  });

  @override
  State<DueToDifficultiesModal> createState() => _DueToDifficultiesModalState();
}

class _DueToDifficultiesModalState extends State<DueToDifficultiesModal> {
  String? selectedStreet;
  String? selectedObsoleteNumber;

 

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 384,
        height: 390,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 32,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            const SizedBox(height: 4),
            

            // New No.
            const Text(
              'Field',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 323,
              height: 37,
              child: TextField(
                controller: widget.newNoController,
                decoration: InputDecoration(
                  hintText: 'field',
                  hintStyle: TextStyle(color: colors(context).colorGrey3),
                  filled: true,
                  fillColor: colors(context).colorGrey1,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors(context).colorGrey5!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors(context).colorGrey5!),
                  ),
                ),
              ),
            ),
                        const SizedBox(height: 4),

            // New No.
            const Text(
              'Field Description',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 323,
              height: 37,
              child: TextField(
                controller: widget.newNoController,
                decoration: InputDecoration(
                  hintText: 'field description',
                  hintStyle: TextStyle(color: colors(context).colorGrey3),
                  filled: true,
                  fillColor: colors(context).colorGrey1,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors(context).colorGrey5!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors(context).colorGrey5!),
                  ),
                ),
              ),
            ),
                        const SizedBox(height: 4),

             const Text(
              'Field Type',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 323,
              height: 37,
              child: TextField(
                controller: widget.newNoController,
                decoration: InputDecoration(
                  hintText: 'field type',
                  hintStyle: TextStyle(color: colors(context).colorGrey3),
                  filled: true,
                  fillColor: colors(context).colorGrey1,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors(context).colorGrey5!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors(context).colorGrey5!),
                  ),
                ),
              ),
            ),
                        const SizedBox(height: 4),

             const Text(
              'Field Size',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 323,
              height: 37,
              child: TextField(
                controller: widget.newNoController,
                decoration: InputDecoration(
                  hintText: 'field size',
                  hintStyle: TextStyle(color: colors(context).colorGrey3),
                  filled: true,
                  fillColor: colors(context).colorGrey1,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors(context).colorGrey5!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors(context).colorGrey5!),
                  ),
                ),
              ),
            ),
            const Spacer(),
            

            // Save Button
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 81,
                height: 40,
                child: ElevatedButton(
                  onPressed: widget.onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors(context).colorPrimary5,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadowColor: Colors.black.withOpacity(0.25),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
