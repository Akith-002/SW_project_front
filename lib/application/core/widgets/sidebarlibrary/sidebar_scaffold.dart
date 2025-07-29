import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SidebarScaffold extends StatefulWidget {
  final Widget child;
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const SidebarScaffold({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  State<SidebarScaffold> createState() => _SidebarScaffoldState();
}

class _SidebarScaffoldState extends State<SidebarScaffold> {
  bool _isExpanded = true;
  bool _isMassRatingExpanded = false;

  // Add a set of indices that belong to the Mass Rating section
  final Set<int> _massRatingIndices = {2, 3, 4, 5, 6};

  // Modified onIndexChanged handler to collapse Mass Rating when needed
  void _handleIndexChanged(int index) {
    setState(() {
      // If sidebar is collapsed, expand it when any item is clicked
      if (!_isExpanded) {
        _isExpanded = true;
      }

      // If selecting a non-Mass Rating item, collapse the Mass Rating section
      if (!_massRatingIndices.contains(index)) {
        _isMassRatingExpanded = false;
      } else if (!_isMassRatingExpanded) {
        // If selecting a Mass Rating item but section is collapsed, expand it
        _isMassRatingExpanded = true;
      }
    });

    // Forward the index change to the parent
    widget.onIndexChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isExpanded ? 265 : 56,
            decoration: BoxDecoration(
              color: _isExpanded
                  ? colors(context).colorWhite!
                  : colors(context).colorPrimary6!,
              border: _isExpanded
                  ? Border(
                      right: BorderSide(
                        color: colors(context).colorGrey9!,
                        width: 1.0,
                      ),
                    )
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and title section
                _buildLogoHeader(),

                // Divider
                SizedBox(
                  height: 24,
                ),

                // Main sidebar content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 8,
                      children: [
                        // Dashboard
                        _buildMenuItem(
                          index: 0,
                          title: AppString.dashboard.localize(context)!,
                          icon: PhosphorIconsBold.squaresFour,
                        ),

                        // Land Acquisition
                        _buildMenuItem(
                          index: 1,
                          title: AppString.landAcquisition.localize(context)!,
                          icon: PhosphorIconsBold.mapTrifold,
                        ),

                        // Mass Rating with subcategories
                        _buildExpandableSection(
                          title: AppString.massRating.localize(context)!,
                          icon: PhosphorIconsBold.pencilRuler,
                          isExpanded: _isMassRatingExpanded,
                          onTap: () {
                            setState(() {
                              _isMassRatingExpanded = !_isMassRatingExpanded;
                              // Only expand sidebar if needed
                              if (_isMassRatingExpanded) {
                                _isExpanded = true;
                              }
                            });
                          },
                          children: [
                            _buildSubMenuItem(
                              index: 2,
                              title: AppString.massRating.localize(context)!,
                            ),
                            _buildSubMenuItem(
                              index: 3,
                              title:
                                  AppString.ratingAssessment.localize(context)!,
                            ),
                            _buildSubMenuItem(
                              index: 4,
                              title:
                                  AppString.ratingBuilding.localize(context)!,
                            ),
                            _buildSubMenuItem(
                              index: 5,
                              title: AppString.ratingObject.localize(context)!,
                            ),
                            _buildSubMenuItem(
                              index: 6,
                              title:
                                  AppString.mrRentalEvidence.localize(context)!,
                            ),
                          ],
                        ),

                        // Land Miscellaneous
                        _buildMenuItem(
                          index: 7,
                          title: AppString.landMiscellaneous.localize(context)!,
                          icon: PhosphorIconsBold.ticket,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Logo - Always visible
          GestureDetector(
            onTap: _isExpanded
                ? null
                : () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _isExpanded ? 42.54 : 32,
              height: _isExpanded ? 42 : 32,
              margin:
                  _isExpanded ? EdgeInsets.only(right: 8) : EdgeInsets.all(0),
              child: Image.asset(
                'images/pngs/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Title - Only visible when expanded
          if (_isExpanded)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  AppString.valuationDepartment.localize(context)!,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: colors(context).colorBlack!,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 0.9,
                  ),
                  overflow: TextOverflow.clip,
                ),
              ),
            ),

          // Collapse button - moved from bottom to header
          if (_isExpanded)
            IconButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                  // If collapsing, also collapse any open sections
                  if (!_isExpanded) {
                    _isMassRatingExpanded = false;
                  }
                });
              },
              icon: Icon(
                PhosphorIcons.sidebar(),
                color: colors(context).colorGrey4!,
              ),
              splashRadius: 20,
            )
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = widget.selectedIndex == index;

    return InkWell(
      onTap: () => _handleIndexChanged(index),
      child: Container(
        height: 44,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected
              ? _isExpanded
                  ? colors(context).colorPrimary9
                  : colors(context).colorPrimary4!
              : Colors.transparent,
          border: isSelected
              ? Border(
                  right: BorderSide(
                    color: _isExpanded
                        ? colors(context).colorPrimary6!
                        : colors(context).colorPrimary9!,
                    width: 4.0,
                  ),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            // Icon
            Container(
              width: 32,
              height: 32,
              margin: _isExpanded
                  ? EdgeInsets.only(left: 4, right: 8)
                  : EdgeInsets.only(left: 4),
              child: Icon(
                icon,
                color: isSelected
                    ? _isExpanded
                        ? colors(context).colorPrimary5!
                        : colors(context).colorPrimary7!
                    : _isExpanded
                        ? colors(context).colorGrey4!
                        : colors(context).colorPrimary8!,
                size: 20,
              ),
            ),

            // Title - Only visible when expanded
            if (_isExpanded)
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected
                        ? colors(context).colorPrimary5
                        : colors(context).colorGrey2!,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    // Check if any child of this section is selected
    final bool hasSelectedChild =
        _massRatingIndices.contains(widget.selectedIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        InkWell(
          onTap: () {
            // Call original onTap function to toggle expansion
            onTap();

            // If we're expanding and it's the Mass Rating section,
            // automatically select the first item (index 2)
            if (!isExpanded && title == 'Mass Rating') {
              widget.onIndexChanged(2);
            }
          },
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              border: hasSelectedChild && !_isMassRatingExpanded
                  ? Border(
                      right: BorderSide(
                        color: _isExpanded
                            ? colors(context).colorPrimary6!
                            : colors(context).colorPrimary9!,
                        width: 4.0,
                      ),
                    )
                  : null,
              color: _getExpandableSectionColor(hasSelectedChild),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const SizedBox(width: 4),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Icon(
                    icon,
                    color: hasSelectedChild
                        ? _isExpanded
                            ? colors(context).colorPrimary5!
                            : colors(context).colorPrimary7!
                        : _isExpanded
                            ? colors(context).colorGrey4!
                            : colors(context).colorPrimary8!,
                    size: 20,
                  ),
                ),
                if (_isExpanded) ...[
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: hasSelectedChild
                            ? colors(context).colorPrimary5!
                            : colors(context).colorGrey2!,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: hasSelectedChild
                        ? colors(context).colorPrimary5!
                        : colors(context).colorGrey4!,
                  ),
                ],
              ],
            ),
          ),
        ),

        // Collapsible children
        if (isExpanded && _isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(spacing: 8, children: children),
          ),
      ],
    );
  }

  Widget _buildSubMenuItem({
    required int index,
    required String title,
    IconData? icon,
  }) {
    final isSelected = widget.selectedIndex == index;

    return InkWell(
      onTap: () => _handleIndexChanged(index),
      child: Container(
        height: 42,
        width: double.infinity,
        decoration: BoxDecoration(
          color:
              isSelected ? colors(context).colorPrimary9! : Colors.transparent,
          border: isSelected
              ? Border(
                  right: BorderSide(
                    color: _isExpanded
                        ? colors(context).colorPrimary6!
                        : colors(context).colorPrimary9!,
                    width: 4.0,
                  ),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            // Icon
            if (icon != null)
              Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(left: 4, right: 8),
                child: Icon(
                  icon,
                  color: isSelected
                      ? colors(context).colorPrimary5!
                      : colors(context).colorGrey4!,
                  size: 18,
                ),
              )
            else
              const SizedBox(width: 36), // Padding for alignment when no icon

            // Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? colors(context).colorPrimary5!
                      : colors(context).colorGrey2!,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getExpandableSectionColor(bool hasSelectedChild) {
    // If no child is selected, use transparent background
    if (!hasSelectedChild) {
      return Colors.transparent;
    }

    // If sidebar is collapsed, use primary4 color
    if (!_isExpanded) {
      return colors(context).colorPrimary4!;
    }

    // If mass rating section is expanded, use transparent
    if (_isMassRatingExpanded) {
      return Colors.transparent;
    }

    // Otherwise (sidebar expanded, section collapsed, has selected child)
    return colors(context).colorPrimary9!;
  }
}
