import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// StatefulWidget SaveMenu - provides a save button with an attached dropdown menu.
class SaveMenu extends StatefulWidget {
  // Callback for when the main "Save" button is tapped.
  final Function()? onSave;
  // Callback for when "New File" is selected from the menu.
  final Function()? onNewFile;
  // Optional list of custom menu items.
  final List<Map<String, dynamic>>? menuItems;

  const SaveMenu({
    super.key,
    this.onSave,
    this.onNewFile,
    this.menuItems,
  });

  @override
  State<SaveMenu> createState() => _SaveMenuState();
}

class _SaveMenuState extends State<SaveMenu> {
  // Tracks whether the dropdown menu is open.
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      // Offset to position the popup menu relative to the button.
      offset: const Offset(0, 40),
      // Setting fixed width constraints for the popup menu.
      constraints: const BoxConstraints(
        minWidth: 242,
        maxWidth: 242,
      ),
      // Rounded corners for the popup menu.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      // Popup menu background color.
      color: colors(context).colorWhite,
      elevation: 4,
      padding: EdgeInsets.zero,
      // Called when the popup menu is dismissed.
      onCanceled: () {
        setState(() {
          _isMenuOpen = false;
        });
      },
      // Called when a menu item is selected.
      onSelected: (_) {
        setState(() {
          _isMenuOpen = false;
        });
      },
      // Called when the popup menu is opened.
      onOpened: () {
        setState(() {
          _isMenuOpen = true;
        });
      },
      // Build the list of menu items.
      itemBuilder: (context) => [
        // If custom menuItems are provided, use them.
        if (widget.menuItems != null)
          ...widget.menuItems!.map(
            (item) => PopupMenuItem<String>(
              value: item['value'],
              onTap: item['onTap'],
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                item['label'],
                style: AppStyling.normalTextSize16.copyWith(
                  color: colors(context).colorGrey5,
                ),
              ),
            ),
          )
        else ...[
          // Default menu item: New File.
          PopupMenuItem<String>(
            value: 'new',
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onTap: widget.onNewFile ?? () {},
            child: Text(AppString.openNew.l10n(context)!),
          ),
          // Default menu item: Open.
          PopupMenuItem<String>(
            value: 'open',
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(AppString.open.l10n(context)!),
          ),
          // Default menu item: Save.
          PopupMenuItem<String>(
            value: 'save',
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onTap: widget.onSave ?? () {},
            child: Text(AppString.save.l10n(context)!),
          ),
          // Default menu item: Save As.
          PopupMenuItem<String>(
            value: 'saveAs',
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(AppString.saveAs.l10n(context)!),
          ),
          // Divider between groups of menu items.
          const PopupMenuDivider(height: 1),
          // Default menu item: Send Data.
          PopupMenuItem<String>(
            value: 'sendData',
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(AppString.sendData.l10n(context)!),
          ),
        ],
      ],
      // Custom child widget for the popup trigger button.
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main save button with onTap action.
          GestureDetector(
            onTap: widget.onSave ?? () {},
            child: Container(
              width: 94,
              height: 48,
              decoration: BoxDecoration(
                color: colors(context).colorPrimary7,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  AppString.save.l10n(context)!,
                  style: AppStyling.mediumTextSize16.copyWith(
                    color: colors(context).colorPrimary5,
                  ),
                ),
              ),
            ),
          ),
          // Toggle button that shows dropdown menu arrow.
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              // Change color when menu is open.
              color: _isMenuOpen
                  ? colors(context).colorPrimary8
                  : colors(context).colorPrimary7,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              // Border between the main button and the toggle button.
              border: Border(
                left: BorderSide(
                  color: colors(context).colorPrimary8 ?? const Color(0xFFB8E3FF),
                  width: 1,
                ),
              ),
            ),
            child: Center(
              // Icon to indicate dropdown functionality.
              child: Icon(
                PhosphorIconsRegular.caretDown,
                color: colors(context).colorPrimary5,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
