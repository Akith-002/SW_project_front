import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';

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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Advanced Search',
                  style: AppStyling.boldTextSize20.copyWith(
                    color: colors(context).colorBlack,
                  ),
                ),
                IconButton(
                  onPressed: widget.onCancel,
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Search Fields
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _assetNoController,
                    label: 'Asset No',
                    hint: 'e.g., AST001',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _wardController,
                    label: 'Ward',
                    hint: 'e.g., Ward 01',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _roadController,
                    label: 'Road/Street',
                    hint: 'e.g., Main Street',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _ownerController,
                    label: 'Owner',
                    hint: 'e.g., John Doe',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'e.g., Commercial property',
            ),
            const SizedBox(height: 16),
            
            // Dropdowns
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Status',
                    value: _selectedStatus,
                    items: ['Active', 'Inactive', 'Completed'],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    label: 'Rating Card',
                    value: _hasRatingCard == null 
                        ? null 
                        : (_hasRatingCard! ? 'Yes' : 'No'),
                    items: ['Yes', 'No'],
                    onChanged: (value) {
                      setState(() {
                        _hasRatingCard = value == 'Yes';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _clearAll,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: colors(context).colorGrey6,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: colors(context).colorGrey5!,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _handleSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors(context).colorPrimary6,
                  ),
                  child: const Text('Search'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyling.semiBoldTextSize14.copyWith(
            color: colors(context).colorGrey7,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colors(context).colorGrey5,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colors(context).colorGrey5!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colors(context).colorGrey5!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colors(context).colorPrimary6!,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyling.semiBoldTextSize14.copyWith(
            color: colors(context).colorGrey7,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: colors(context).colorGrey5!,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(
                'Select $label',
                style: TextStyle(
                  color: colors(context).colorGrey5,
                  fontSize: 14,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}