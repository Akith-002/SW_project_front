import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';

/// Widget for saving a lot with an option to select lot id and callbacks for saving and cancelling.
class SaveLot extends StatefulWidget {
  final Function(String? selectedLotId) onSave;
  final VoidCallback onCancel;

  const SaveLot({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<SaveLot> createState() => _SaveLotState();
}

class _LotIdSearchDialog extends StatefulWidget {
  final List<String> allItems;

  const _LotIdSearchDialog({required this.allItems});

  @override
  State<_LotIdSearchDialog> createState() => _LotIdSearchDialogState();
}

class _LotIdSearchDialogState extends State<_LotIdSearchDialog> {
  late List<String> _filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initially show all lot IDs
    _filteredItems = widget.allItems;
    // Listen to changes in the search field to filter items dynamically
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    // Remove the listener and dispose the controller when the widget is removed
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  /// Filters the list of lot IDs based on the entered search term.
  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.allItems;
      } else {
        // Update filtered list with lot IDs that contain the query string
        _filteredItems = widget.allItems
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate approximate height needed for elements outside the list
    // Title (~56) + Padding (16 top content, 16 bottom actions) + TextField (~50) + SizedBox (10) + Actions (~52) = ~190
    // Target Dialog Height (312) - Other Elements (~190) = ~122 for the list view
    const double targetDialogHeight = 312.0;
    const double nonListHeight = 190.0; // Approximate height of other elements
    const double listMaxHeight = targetDialogHeight - nonListHeight > 0 ? targetDialogHeight - nonListHeight : 100; // Ensure positive height

    return AlertDialog(
      backgroundColor: Colors.white,
      // Dialog title prompting the user to select a lot ID.
      title: Text(AppString.selectLotId.l10n(context)!),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      // Constrain the overall content area width
      content: SizedBox(
        width: 398, // Set content width
        // Use SingleChildScrollView to prevent overflow if content exceeds calculated height
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search field for filtering lot IDs.
              // No specific width needed here as the parent SizedBox controls it.
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: AppString.searchEllipsis.l10n(context)!,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Constrained list view for displaying the filtered lot IDs.
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: listMaxHeight, // Adjusted max height for the list
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    return ListTile(
                      title: Text(item),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                      dense: true,
                      // Return the selected lot id and close the dialog.
                      onTap: () {
                        Navigator.of(context).pop(item);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // Cancel button to close the dialog without selection.
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppString.cancel.l10n(context)!),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}

class _SaveLotState extends State<SaveLot> {
  String? _selectedLotId;
  final TextEditingController _lotIdDisplayController = TextEditingController();

  // List of available lot IDs.
  final List<String> _allLotIds = [
    "LOT-001",
    "LOT-002",
    "LOT-003",
    "LOT-004",
    "LOT-005",
    "LOT-006",
    "LOT-007",
    "LOT-008",
    "LOT-009",
    "LOT-010",
    "LOT-011", // Added more items to test scrolling
    "LOT-012",
    "LOT-013",
    "LOT-014",
    "LOT-015",
  ];

  @override
  void dispose() {
    // Dispose text controller when non-needed.
    _lotIdDisplayController.dispose();
    super.dispose();
  }

  /// Opens the search dialog for selecting a lot ID.
  Future<void> _showLotIdSearchDialog() async {
    // Remove focus from text fields.
    FocusScope.of(context).unfocus();

    final String? result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _LotIdSearchDialog(allItems: _allLotIds),
    );

    if (result != null && mounted) {
      // Update selected lot id and display text if a result is chosen.
      setState(() {
        _selectedLotId = result;
        _lotIdDisplayController.text = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the content in a SizedBox to control the overall width of the SaveLot widget area
    // Note: This assumes SaveLot is shown in a way that respects this size (e.g., BottomSheet, Dialog)
    return SizedBox(
      width: 446, // Set the overall width for the SaveLot content area
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        // Main column holding title, lot id selection, and action buttons.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Important for height based on content
          children: [
            // Main title.
            Text(
              AppString.saveLot.l10n(context)!,
              style: AppStyling.semiBoldTextSize18.copyWith(
                color: colors(context).textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            // Label for lot id selection input.
            Text(
              AppString.selectLotId.l10n(context)!,
              style: AppStyling.normalTextSize14.copyWith(
                color: colors(context).textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            // Read-only input field that triggers the search dialog upon tapping.
            InkWell(
              onTap: _showLotIdSearchDialog,
              child: TextFormField(
                controller: _lotIdDisplayController,
                readOnly: true,
                enabled: false,
                style: TextStyle(
                  color: _selectedLotId != null
                      ? colors(context).textPrimary
                      : colors(context).textGrey,
                ),
                decoration: InputDecoration(
                  hintText: AppString.selectLotId.l10n(context),
                  hintStyle: AppStyling.normalTextSize14.copyWith(
                    color: _selectedLotId != null
                        ? colors(context).textPrimary
                        : colors(context).textGrey,
                  ),
                  filled: true,
                  fillColor: colors(context).colorGrey1,
                  suffixIcon: Icon(Icons.arrow_drop_down,
                      color: colors(context).colorIconDefault),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                        color: colors(context).colorGrey5 ?? Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                        color: colors(context).colorGrey5 ?? Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey[300]!)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Row containing Cancel and Save buttons.
            Row(
              // Let the buttons determine their size based on padding
              mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the end
              children: [
                OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(
                        color: colors(context).colorGrey5 ?? Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  ),
                  child: Text(AppString.cancel.l10n(context)!,
                      style: AppStyling.semiBoldTextSize14.copyWith(
                        color: colors(context).textPrimary,
                      )),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  // Disable save button if no lot id is selected.
                  onPressed: _selectedLotId != null
                      ? () {
                          widget.onSave(_selectedLotId);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors(context).colorPrimary6,
                    foregroundColor: colors(context).colorWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                    elevation: _selectedLotId != null ? 2 : 0,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade500,
                  ),
                  child: Text(AppString.save.l10n(context)!,
                      style: AppStyling.semiBoldTextSize14.copyWith(
                            color: colors(context).colorWhite,
                          )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
