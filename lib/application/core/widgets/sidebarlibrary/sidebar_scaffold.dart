import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sidebarx/sidebarx.dart';

class SidebarScaffold extends StatelessWidget {
  SidebarScaffold({super.key});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            drawer: ExampleSidebarX(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) ExampleSidebarX(controller: _controller),
                Expanded(
                  child: Center(
                    child: _ScreensExample(
                      controller: _controller,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

//
// ─── UPDATED SIDEBAR WITH EXPANDABLE SUBMENU ─────────────────────────────
//

class ExampleSidebarX extends StatefulWidget {
  final SidebarXController controller;
  final Function(int)? onSelectedIndexChanged;
  const ExampleSidebarX(
      {super.key, required this.controller, this.onSelectedIndexChanged});

  @override
  _ExampleSidebarXState createState() => _ExampleSidebarXState();
}

class _ExampleSidebarXState extends State<ExampleSidebarX> {
  // Track if the Mass Rating item is expanded
  bool _isMassRatingExpanded = false;
  bool _isMassRatingSelected = false;

  @override
  void initState() {
    super.initState();
    // Initialize expansion state based on selected index
    _updateExpansionState();

    
  widget.controller.addListener(() {
    // Collapse Mass Rating when sidebar is minimized
    if (!widget.controller.extended && _isMassRatingExpanded) {
      setState(() {
        _isMassRatingExpanded = false;
      });
    }
  });

  }

  @override
  void didUpdateWidget(ExampleSidebarX oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller.selectedIndex != widget.controller.selectedIndex) {
      _updateExpansionState();
    }
  }

  void _updateExpansionState() {
    // Expand Mass Rating section if selected index is in that range
    if (widget.controller.selectedIndex >= 3 &&
        widget.controller.selectedIndex <= 7) {
      _isMassRatingExpanded = true;
      _isMassRatingSelected = true;
    } else {
      _isMassRatingSelected = false;
      // Keep expanded if user manually expanded it
    }
  }

  void _toggleMassRating() {
    setState(() {
      _isMassRatingExpanded = !_isMassRatingExpanded;

      // If expanding and not already selected, select the first item
      if (_isMassRatingExpanded && !_isMassRatingSelected) {
        widget.controller.selectIndex(3);
        if (widget.onSelectedIndexChanged != null) {
          widget.onSelectedIndexChanged!(3);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _isMassRatingSelected = widget.controller.selectedIndex >= 3 &&
        widget.controller.selectedIndex <= 7;

    debugPrint(
        "Current sidebar selected index: ${widget.controller.selectedIndex}");

    final items = <SidebarXItem>[
      SidebarXItem(
        icon: PhosphorIcons.squaresFour(),
        label: 'Dashboard',
        onTap: () {
          widget.controller.selectIndex(0);
          if (widget.onSelectedIndexChanged != null) {
            widget.onSelectedIndexChanged!(0);
          }
        },
      ),
      SidebarXItem(
        icon: PhosphorIcons.mapTrifold(),
        label: 'Land Acquisition',
        onTap: () {
          widget.controller.selectIndex(1);
          if (widget.onSelectedIndexChanged != null) {
            widget.onSelectedIndexChanged!(1);
          }
        },
      ),
      SidebarXItem(
        icon: PhosphorIcons.caretDown(),
        iconBuilder: (selected, extended) {
          bool isInMassRatingSection = widget.controller.selectedIndex >= 3 &&
              widget.controller.selectedIndex <= 7;
          return Icon(
            _isMassRatingExpanded && widget.controller.extended
                ? PhosphorIcons.caretUp()
                : PhosphorIcons.caretDown(),
            color: isInMassRatingSection
                ? const Color(0xff007BCE)
                : const Color(0xff9EA2AE),
            size: 16,
          );
        },
        label: 'Mass Rating',
        onTap: _toggleMassRating,
      ),
    ];

    // When expanded, add submenu items with a small indent.
    if (_isMassRatingExpanded && widget.controller.extended) {
      items.addAll([
        SidebarXItem(
          icon: Icons.space_bar,
          iconBuilder: (_, __) => const SizedBox.shrink(),
          label: '   Mass Rating',
          onTap: () {
            widget.controller.selectIndex(3);
            if (widget.onSelectedIndexChanged != null) {
              widget.onSelectedIndexChanged!(3);
            }
          },
        ),
        SidebarXItem(
          icon: Icons.space_bar,
          iconBuilder: (_, __) => const SizedBox.shrink(),
          label: '   Rating Assessment',
          onTap: () {
            widget.controller.selectIndex(4);
            if (widget.onSelectedIndexChanged != null) {
              widget.onSelectedIndexChanged!(4);
            }
          },
        ),
        SidebarXItem(
          icon: Icons.space_bar,
          iconBuilder: (_, __) => const SizedBox.shrink(),
          label: '   Rating Building',
          onTap: () {
            widget.controller.selectIndex(5);
            if (widget.onSelectedIndexChanged != null) {
              widget.onSelectedIndexChanged!(5);
            }
          },
        ),
        SidebarXItem(
          icon: Icons.space_bar,
          iconBuilder: (_, __) => const SizedBox.shrink(),
          label: '   Rating Object',
          onTap: () {
            widget.controller.selectIndex(6);
            if (widget.onSelectedIndexChanged != null) {
              widget.onSelectedIndexChanged!(6);
            }
          },
        ),
        SidebarXItem(
          icon: Icons.space_bar,
          iconBuilder: (_, __) => const SizedBox.shrink(),
          label: '   MR Rental Evidence',
          onTap: () {
            widget.controller.selectIndex(7);
            if (widget.onSelectedIndexChanged != null) {
              print("Sidebar: Selected MR Rental Evidence (index 7)");
              widget.onSelectedIndexChanged!(7);
            }
          },
        ),
      ]);
    }

    // Continue with the remaining items.
    items.add(
      SidebarXItem(
        icon: PhosphorIcons.ticket(),
        label: 'Land Miscellaneous',
        onTap: () {
          print("Land Miscellaneous tab selected manually");
          widget.controller.selectIndex(8);
          if (widget.onSelectedIndexChanged != null) {
            widget.onSelectedIndexChanged!(8);
          }
        },
      ),
    );

    return GestureDetector(
        onTap: () {
          if (!widget.controller.extended) {
            widget.controller.setExtended(true);
          }
        },
        child: SidebarX(
          controller: widget.controller,
          theme: SidebarXTheme(
            decoration: BoxDecoration(
              color: const Color(0xff007BCE),
            ),
            width: 56,
            hoverColor: scaffoldBackgroundColor,
            textStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            selectedTextStyle: const TextStyle(
              color: Color(0xff007BCE),
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            hoverTextStyle: const TextStyle(
              color: Color(0xff007BCE),
              fontWeight: FontWeight.w500,
            ),
            itemTextPadding: const EdgeInsets.only(left: 15, top: 2, bottom: 2),
            selectedItemTextPadding:
                const EdgeInsets.only(left: 15, top: 2, bottom: 2),
            selectedItemDecoration: BoxDecoration(
              color: Colors.white,
              border: const Border(
                right: BorderSide(
                  color: Colors.white,
                  width: 4,
                ),
              ),
              gradient: const LinearGradient(
                colors: [Color(0xff02528A), Color(0xff02528A)],
              ),
            ),
            itemDecoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: widget.controller.selectedIndex >= 3 &&
                          widget.controller.selectedIndex <= 7
                      ? Colors.white
                      : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
              size: 24,
            ),
            selectedIconTheme: const IconThemeData(
              color: Colors.white,
              size: 20,
            ),
          ),
          extendedTheme: const SidebarXTheme(
            width: 256,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            selectedItemDecoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(
                  color: Color(0xff007BCE),
                  width: 4,
                ),
              ),
              gradient: LinearGradient(
                colors: [Color(0xffDFF0FF), Color(0xffDFF0FF)],
              ),
            ),
            iconTheme: IconThemeData(
              color: Color(0xff9EA2AE),
              size: 16,
            ),
            selectedIconTheme: IconThemeData(
              color: Color(0xff007BCE),
              size: 16,
            ),
          ),
          // TODO: Make the below icon disappear when the sidebar is minimized and expanded.
          // collapseIcon: widget.controller.extended
          //     ? Icons.keyboard_double_arrow_left
          //     : Icons.keyboard_double_arrow_right,

          // footerDivider: divider,
          headerBuilder: (context, extended) {
            if (!extended) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 24),
                      Image.asset(
                        'images/pngs/logo.png',
                        width: 42,
                        height: 42,
                        fit: BoxFit.contain,
                      ),
                    ]),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'images/pngs/logoextended.png',
                            width: 137,
                            height: 42,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          PhosphorIcons.sidebar(
                            PhosphorIconsStyle.bold,
                          ),
                          color: const Color(0xff9EA2AE),
                          size: 24,
                        ),
                        onPressed: () {
                          widget.controller.toggleExtended();
                        },
                      ),
                    ],
                  ),
                  // const SizedBox(height: 8),
                ],
              ),
            );
          },
          items: items,
        ));
  }
}

//
// ─── OTHER SCREEN CONTENT ────────────────────────────────────────────────────
//

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({
    required this.controller,
  });

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return Column(
                children: List.generate(
              10,
              (index) => Container(
                padding: const EdgeInsets.only(top: 10),
                height: 100,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).canvasColor,
                  boxShadow: const [BoxShadow()],
                ),
              ),
            ));
          default:
            return Text(
              pageTitle,
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Search';
    case 2:
      return 'People';
    case 3:
      return 'Favorites';
    case 4:
      return 'Custom iconWidget';
    case 5:
      return 'Profile';
    case 6:
      return 'Settings';
    default:
      return 'Not found page';
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: Colors.red, height: 0);
