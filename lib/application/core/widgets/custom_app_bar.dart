import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:land_asset_valuation/data/repositories/auth_repository.dart';
import 'package:land_asset_valuation/data/datasource/secure_storage.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final IconData Function(PhosphorIconsStyle)? leftIcon;
  final VoidCallback? onLeftIconPressed;
  final IconData Function(PhosphorIconsStyle)? rightIcon1;
  final VoidCallback? onRightIcon1Pressed;
  final IconData Function(PhosphorIconsStyle)? rightIcon2;
  final VoidCallback? onRightIcon2Pressed;
  final TextStyle? style;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leftIcon,
    this.onLeftIconPressed,
    this.rightIcon1,
    this.onRightIcon1Pressed,
    this.rightIcon2,
    this.onRightIcon2Pressed,
    this.style,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class _CustomAppBarState extends State<CustomAppBar> {
  OverlayEntry? _overlayEntry;
  bool _isRightIcon1Selected = false;
  bool _isRightIcon2Selected = false;

  Widget _buildHoverMenuItem(IconData icon, String text, VoidCallback onTap) {
    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 24, color: Colors.black87),
              SizedBox(width: 16),
              Text(text,
                  style: AppStyling.regularTextSize20
                      .copyWith(color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      final secureStorage = GetIt.I<SecureStorage>();
      final authRepository = GetIt.I<AuthRepository>();

      // Get username from secure storage
      final username = await secureStorage.read('username');

      if (username != null) {
        final result = await authRepository.logout(username);

        result.fold(
          (error) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logout failed: ${error.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          },
          (success) {
            // Clear overlay and navigate to sign in
            _overlayEntry?.remove();
            _overlayEntry = null;
            context.go(Pages.routeSignIn.toPath());
          },
        );
      } else {
        // If no username found, just navigate to sign in
        _overlayEntry?.remove();
        _overlayEntry = null;
        context.go(Pages.routeSignIn.toPath());
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleProfileMenu(BuildContext context) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    } else {
      final overlay = Overlay.of(context);

      _overlayEntry = OverlayEntry(
        builder: (context) => Stack(
          children: [
            // Tap anywhere to dismiss dropdown
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _overlayEntry?.remove();
                  _overlayEntry = null;
                  setState(() {
                    _isRightIcon2Selected = false;
                  });
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              right: 16,
              top: 70,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHoverMenuItem(
                          Icons.person, AppString.profile.l10n(context)!,
                          () {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                        context.push(Pages.routeProfileScreen.toPath());
                      }),
                      SizedBox(height: 16),
                      _buildHoverMenuItem(
                          Icons.settings, AppString.settings.l10n(context)!,
                          () {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                        context.push(Pages.routeSettingsScreen.toPath());
                      }),
                      SizedBox(height: 16),
                      _buildHoverMenuItem(
                          Icons.logout,
                          AppString.logOut.l10n(context)!,
                          () => _handleLogout(context)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      overlay.insert(_overlayEntry!);
    }
  }

  Widget _buildSelectableIconButton(
    IconData Function(PhosphorIconsStyle) icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final appColors = colors(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? appColors.colorPrimary1 : appColors.colorGrey9,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          icon(PhosphorIconsStyle.regular),
          size: 24.0,
          color: isSelected ? appColors.colorWhite : appColors.colorBlack,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = colors(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 64,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: appColors.colorWhite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: widget.onLeftIconPressed,
                child: Icon(
                  (widget.leftIcon ??
                          (style) => PhosphorIcons.mapTrifold(style))(
                      PhosphorIconsStyle.regular),
                  size: 24.0,
                  color: appColors.grayColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: AppStyling.semiBoldTextSize16
                    .copyWith(color: appColors.labelTextColor),
              ),
            ],
          ),
          Row(
            children: [
              _buildSelectableIconButton(
                widget.rightIcon1 ?? (style) => PhosphorIcons.bell(style),
                _isRightIcon1Selected,
                () {
                  setState(() {
                    _isRightIcon1Selected = !_isRightIcon1Selected;
                  });
                  widget.onRightIcon1Pressed?.call();
                },
              ),
              const SizedBox(width: 12),
              _buildSelectableIconButton(
                widget.rightIcon2 ?? (style) => PhosphorIcons.user(style),
                _isRightIcon2Selected,
                () {
                  setState(() {
                    _isRightIcon2Selected = !_isRightIcon2Selected;
                  });
                  _toggleProfileMenu(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
