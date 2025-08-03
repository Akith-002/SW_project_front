import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';

class AdvancedSearchDialog extends StatefulWidget {
  final Function(Map<String, String>) onSearch;
  final VoidCallback onCancel;

  const AdvancedSearchDialog({
    super.key,
    required this.onSearch,
    required this.onCancel,
  });

  @override
  State<AdvancedSearchDialog> createState() => _AdvancedSearchDialogState();
}

class _AdvancedSearchDialogState extends State<AdvancedSearchDialog> {
  final TextEditingController _assetNoController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _roadController = TextEditingController();
  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String? _selectedStatus;
  bool? _hasRatingCard;

  @override
  void dispose() {
    _assetNoController.dispose();
    _wardController.dispose();
    _roadController.dispose();
    _ownerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    Map<String, String> searchCriteria = {};
    
    if (_assetNoController.text.isNotEmpty) {
      searchCriteria['assetNo'] = _assetNoController.text;
    }
    if (_wardController.text.isNotEmpty) {
      searchCriteria['ward'] = _wardController.text;
    }
    if (_roadController.text.isNotEmpty) {
      searchCriteria['road'] = _roadController.text;
    }
    if (_ownerController.text.isNotEmpty) {
      searchCriteria['owner'] = _ownerController.text;
    }
    if (_descriptionController.text.isNotEmpty) {
      searchCriteria['description'] = _descriptionController.text;
    }
    if (_selectedStatus != null) {
      searchCriteria['status'] = _selectedStatus!;
    }
    if (_hasRatingCard != null) {
      searchCriteria['hasRatingCard'] = _hasRatingCard.toString();
    }
    
    widget.onSearch(searchCriteria);
  }

  void _clearAll() {
    setState(() {
      _assetNoController.clear();
      _wardController.clear();
      _roadController.clear();
      _ownerController.clear();
      _descriptionController.clear();
      _selectedStatus = null;
      _hasRatingCard = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = colors(context);
    
    return Dialog(
      backgroundColor: appColors.colorWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: appColors.colorWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: appColors.colorGrey1,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Advanced Search',
                    style: AppStyling.boldTextSize18.copyWith(
                      color: appColors.colorGrey7,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onCancel,
                    icon: Icon(
                      Icons.close,
                      color: appColors.colorGrey4,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Fields
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            label: 'Asset No',
                            placeholder: 'e.g., AST001',
                            controller: _assetNoController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: LabeledTextField(
                            label: 'Ward',
                            placeholder: 'e.g., Ward 01',
                            controller: _wardController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            label: 'Road/Street',
                            placeholder: 'e.g., Main Street',
                            controller: _roadController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: LabeledTextField(
                            label: 'Owner',
                            placeholder: 'e.g., John Doe',
                            controller: _ownerController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LabeledTextField(
                      label: 'Description',
                      placeholder: 'e.g., Commercial property',
                      controller: _descriptionController,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 20),
                    // Dropdowns
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdownField(
                            label: 'Status',
                            items: ['Active', 'Inactive', 'Completed'],
                            initialValue: _selectedStatus,
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value;
                              });
                            },
                            required: false,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomDropdownField(
                            label: 'Rating Card',
                            items: ['Yes', 'No'],
                            initialValue: _hasRatingCard == null 
                                ? null 
                                : (_hasRatingCard! ? 'Yes' : 'No'),
                            onChanged: (value) {
                              setState(() {
                                _hasRatingCard = value == 'Yes';
                              });
                            },
                            required: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Footer Actions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: appColors.colorGrey1,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _clearAll,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: Text(
                      'Clear All',
                      style: AppStyling.mediumTextSize14.copyWith(
                        color: appColors.colorGrey6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    text: 'Cancel',
                    onPressed: widget.onCancel,
                    backgroundColor: appColors.colorGrey1!,
                    width: 120,
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    text: 'Search',
                    onPressed: _handleSearch,
                    backgroundColor: appColors.colorPrimary6!,
                    width: 140,
                    icon: Icons.search,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}