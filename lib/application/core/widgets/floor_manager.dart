import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';

class FloorManager extends StatefulWidget {
  final Function(String)? onFloorSelected;

  const FloorManager({super.key, this.onFloorSelected});

  @override
  State<FloorManager> createState() => _FloorManagerState();
}

class _FloorManagerState extends State<FloorManager> {
  List<String> floors = ['Ground'];
  String _selectedFloor = 'Ground'; // Default selected floor

  // Show floor selection menu
  void _showFloorSelectionMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: floors.map((floor) {
        return PopupMenuItem<String>(
          value: floor,
          child: Row(
            children: [
              Text(floor),
              const SizedBox(width: 8),
              if (_selectedFloor == floor)
                Icon(Icons.check, color: colors(context).colorPrimary6),
            ],
          ),
        );
      }).toList(),
    ).then((selectedFloor) {
      if (selectedFloor != null) {
        _selectFloor(selectedFloor);
      }
    });
  }

  void _addFloor() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddFloorDialog(),
    );

    if (result != null) {
      String name = result['name'];
      String position = result['position'];

      setState(() {
        if (position == 'below') {
          // When selecting "below", add the floor above in the stack (at the beginning)
          floors.insert(0, name);
        } else if (position == 'above') {
          // When selecting "above", add the floor below in the stack (at the end)
          floors.add(name);
        }
      });

      // Automatically select the newly added floor
      _selectFloor(name);
    }
  }

  void _selectFloor(String floorName) {
    if (_selectedFloor != floorName) {
      setState(() {
        _selectedFloor = floorName;
      });
      // Notify parent about floor selection
      if (widget.onFloorSelected != null) {
        widget.onFloorSelected!(floorName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      color: colors(context).colorWhite,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString.floor.l10n(context)!,
                  style: AppStyling.semiBoldTextSize18,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addFloor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Floors
            ...floors
                .map((floor) => FloorItem(
                      floorName: floor,
                      isSelected: _selectedFloor == floor,
                      onTap: () => _selectFloor(floor),
                    ))
                ,
          ],
        ),
      ),
    );
  }
}

class FloorItem extends StatelessWidget {
  final String floorName;
  final bool isSelected;
  final VoidCallback onTap;

  const FloorItem({super.key, 
    required this.floorName,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 194, // Fixed width for all floor rows
        height: 36,
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? colors(context).colorPrimary6!.withOpacity(0.1)
              : colors(context).colorGrey5,
          borderRadius: BorderRadius.circular(4),
          border: isSelected
              ? Border.all(color: colors(context).colorPrimary6!, width: 1.5)
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                floorName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? colors(context).colorPrimary6
                      : colors(context).colorBlack,
                ),
                overflow:
                    TextOverflow.ellipsis, // Truncate with ... for long text
                maxLines: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: isSelected ? colors(context).colorPrimary6 : null,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  iconSize: 20,
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: isSelected ? colors(context).colorPrimary6 : null,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  iconSize: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddFloorDialog extends StatefulWidget {
  const AddFloorDialog({super.key});

  @override
  State<AddFloorDialog> createState() => _AddFloorDialogState();
}

class _AddFloorDialogState extends State<AddFloorDialog> {
  final _nameController = TextEditingController();
  String _selectedPosition = 'above';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colors(context).colorWhite,
      title: Text(
        AppString.addFloor.l10n(context)!,
        style: AppStyling.regularTextSize16,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
                labelText: AppString.floorName.l10n(context)!),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(AppString.position.l10n(context)!),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedPosition,
                dropdownColor: colors(context).colorWhite,
                items: [
                  DropdownMenuItem(
                      value: 'above',
                      child: Text(AppString.above.l10n(context)!)),
                  DropdownMenuItem(
                      value: 'below',
                      child: Text(AppString.below.l10n(context)!)),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedPosition = val);
                  }
                },
              )
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
            style: TextButton.styleFrom(
              backgroundColor: colors(context).colorGrey5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppString.cancel.l10n(context)!,
              style: AppStyling.semiBoldTextSize14
                  .copyWith(color: colors(context).colorBlack),
            )),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors(context).colorPrimary6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              Navigator.pop(context, {
                'name': _nameController.text.trim(),
                'position': _selectedPosition
              });
            }
          },
          child: Text(
            AppString.add.l10n(context)!,
            style: AppStyling.semiBoldTextSize14
                .copyWith(color: colors(context).colorWhite),
          ),
        ),
      ],
    );
  }
}
