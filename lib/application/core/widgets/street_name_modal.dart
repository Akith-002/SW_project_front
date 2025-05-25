import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';

class StreetNameModal extends StatefulWidget {
  final TextEditingController newNoController;
  final VoidCallback onSave;

  const StreetNameModal({
    super.key,
    required this.newNoController,
    required this.onSave,
  });

  @override
  State<StreetNameModal> createState() => _StreetNameModalState();
}

class _StreetNameModalState extends State<StreetNameModal> {
  String? selectedStreet;
  String? selectedObsoleteNumber;

  final List<String> dummyStreets = ['Main Street', 'Second Ave', 'Palm Grove'];
  final List<String> dummyObsoleteNumbers = ['123', '456', '789'];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 384,
        height: 330,
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
            // Street Name
            const Text(
              'Street Name',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 323,
              height: 37,
              child: DropdownButtonFormField<String>(
                value: selectedStreet,
                items: dummyStreets.map((street) {
                  return DropdownMenuItem(
                    value: street,
                    child: Text(street),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedStreet = value),
                decoration: InputDecoration(
                  hintText: 'select street name',
                  hintStyle: TextStyle(color: colors(context).colorGrey3),
                  filled: true,
                  fillColor: colors(context).colorGrey1,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors(context).colorGrey5!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors(context).colorGrey5!),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Obsolete Number
            const Text(
              'Obsolete  number',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 323,
              height: 37,
              child: DropdownButtonFormField<String>(
                value: selectedObsoleteNumber,
                items: dummyObsoleteNumbers.map((number) {
                  return DropdownMenuItem(
                    value: number,
                    child: Text(number),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedObsoleteNumber = value),
                decoration: InputDecoration(
                  hintText: 'select obsolete  number',
                  hintStyle: TextStyle(color: colors(context).colorGrey3),
                  filled: true,
                  fillColor: colors(context).colorGrey1,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors(context).colorGrey5!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors(context).colorGrey5!),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // New No.
            const Text(
              'New No.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 323,
              height: 37,
              child: TextField(
                controller: widget.newNoController,
                decoration: InputDecoration(
                  hintText: 'new no.',
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
