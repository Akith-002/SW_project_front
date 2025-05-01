import 'package:flutter/cupertino.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ToggleItem extends StatefulWidget {
  final String? label;
  final Function(bool) function;

  const ToggleItem({
    super.key,
    this.label,
    required this.function,
  });

  @override
  State<ToggleItem> createState() => _ToggleItemState();
}

class _ToggleItemState extends State<ToggleItem> {
  bool _isToggled = false; // Default state for each toggle

  @override
  void initState() {
    super.initState();
    // You can set initial state based on the label if needed
    // Initialize each toggle based on your preferences
    if (widget.label == "Zoning layer" || widget.label == "Data layer") {
      _isToggled = true;
    }
  }

  void _toggle() {
    setState(() {
      _isToggled = !_isToggled;
    });
    widget.function(_isToggled);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Row(
        children: [
          Text(widget.label ?? "Toggle"), // Use null-safe operator
          const SizedBox(width: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: PhosphorIcon(
              key: ValueKey<bool>(_isToggled),
              _isToggled
                  ? PhosphorIconsFill.toggleRight
                  : PhosphorIconsFill.toggleLeft,
              size: 24,
              color: _isToggled
                  ? colors(context).colorPrimary6
                  : colors(context).colorGrey3,
            ),
          ),
        ],
      ),
    );
  }
}