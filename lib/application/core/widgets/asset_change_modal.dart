import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:land_asset_valuation/data/models/asset_change_request.dart';
import 'package:land_asset_valuation/domain/usecases/change_asset_number_usecase.dart';
import 'package:land_asset_valuation/injection.dart';

class AssetChangeModal extends StatefulWidget {
  final Asset asset;
  final VoidCallback onSave;

  const AssetChangeModal({
    super.key,
    required this.asset,
    required this.onSave,
  });

  @override
  State<AssetChangeModal> createState() => _AssetChangeModalState();
}

class _AssetChangeModalState extends State<AssetChangeModal> {
  late TextEditingController _newAssetNoController;
  late TextEditingController _reasonController;
  late ChangeAssetNumberUseCase _changeAssetNumberUseCase;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _newAssetNoController = TextEditingController();
    _reasonController = TextEditingController();
    _changeAssetNumberUseCase = injection<ChangeAssetNumberUseCase>();
  }

  @override
  void dispose() {
    _newAssetNoController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final newAssetNo = _newAssetNoController.text.trim();
    final reason = _reasonController.text.trim();

    if (newAssetNo.isEmpty || reason.isEmpty) {
      // Show validation error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create the asset change request
      final request = AssetChangeRequest(
        id: 0,
        oldAssetNo: widget.asset.assetNo,
        newAssetNo: newAssetNo,
        reason: reason,
        changedDate: DateTime.now().toIso8601String(),
        dateOfChange: DateTime.now().toIso8601String(),
      ); // Call the API
      final response = await _changeAssetNumberUseCase(request);

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.isSuccess
                  ? 'Asset number changed successfully to $newAssetNo'
                  : response.message ?? 'Asset number change completed',
            ),
            backgroundColor: Colors.green,
          ),
        );

        widget.onSave();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change asset number: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 400,
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
            const Text(
              'Change Asset Number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),

            // Current Asset Number (Read-only)
            const Text(
              'Current Asset No.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Container(
              width: 336,
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colors(context).colorGrey1?.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors(context).colorGrey5!),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.asset.assetNo,
                  style: TextStyle(
                    color: colors(context).colorGrey3,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // New Asset Number
            const Text(
              'New Asset No.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 336,
              height: 36,
              child: TextField(
                controller: _newAssetNoController,
                decoration: InputDecoration(
                  hintText: 'Enter new asset number',
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
                    borderSide:
                        BorderSide(color: colors(context).colorPrimary5!),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Reason/Description
            const Text(
              'Reason for Change',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 336,
              height: 80,
              child: TextField(
                controller: _reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter reason for asset number change',
                  hintStyle: TextStyle(color: colors(context).colorGrey3),
                  filled: true,
                  fillColor: colors(context).colorGrey1,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors(context).colorGrey5!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: colors(context).colorPrimary5!),
                  ),
                ),
              ),
            ),
            const Spacer(),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 40,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors(context).colorGrey5!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 81,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors(context).colorPrimary5,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
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
