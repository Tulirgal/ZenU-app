import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/zen_tokens.dart';

class _NavItem {
  final String label;
  final String route;
  final IconData icon;

  const _NavItem(this.label, this.route, this.icon);
}

const List<_NavItem> _navItems = [
  _NavItem('Home', '/dashboard', Icons.home_rounded),
  _NavItem('Seviyan', '/chat', Icons.smart_toy_rounded),
  _NavItem('Journal', '/diary', Icons.menu_book_rounded),
  _NavItem('Gratitude', '/gratitude', Icons.favorite_rounded),
  _NavItem('Breathing', '/breathing', Icons.air_rounded),
  _NavItem('Mindfulness', '/mindfulness', Icons.self_improvement_rounded),
  _NavItem('Bubble Wrap', '/bubble', Icons.auto_fix_high_rounded),
  _NavItem('Burst It', '/burst', Icons.bolt_rounded),
  _NavItem('Scribble', '/scribble', Icons.draw_rounded),
  _NavItem('Doodle', '/doodle', Icons.auto_fix_high_rounded),
  _NavItem('Healing Garden', '/healing-garden', Icons.park_rounded),
  _NavItem('Inner Compass', '/inner-compass', Icons.explore_rounded),
  _NavItem('Stress Check', '/pss', Icons.monitor_heart_rounded),
];

class ZenNavShell extends StatefulWidget {
  final Widget child;
  const ZenNavShell({super.key, required this.child});

  @override
  State<ZenNavShell> createState() => _ZenNavShellState();
}

class _ZenNavShellState extends State<ZenNavShell> {
  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _navItems.length; i++) {
      if (location.startsWith(_navItems[i].route)) {
        return i;
      }
    }
    return 0; // Default to dashboard
  }

  void _onItemTapped(int index, BuildContext context) {
    context.go(_navItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 640;

        return Scaffold(
          extendBody: true,
          body: Row(
            children: [
              if (!isMobile)
                _buildSidebar(selectedIndex, context),
              Expanded(child: widget.child),
            ],
          ),
          bottomNavigationBar: isMobile ? _buildBottomNav(selectedIndex, context) : null,
        );
      },
    );
  }

  Widget _buildSidebar(int selectedIndex, BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32.0, sigmaY: 32.0),
        child: Container(
          width: 252,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.10))),
          ),
          child: Column(
            children: [
              const SizedBox(height: ZenTokens.s6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ZenTokens.s4),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: ZenTokens.zenPrimary,
                      ),
                      child: const Icon(Icons.self_improvement_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: ZenTokens.s3),
                    Text(
                      'ZenU',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: ZenTokens.s6),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: ZenTokens.s3),
                  itemCount: _navItems.length,
                  itemBuilder: (context, index) {
                    final item = _navItems[index];
                    final isActive = index == selectedIndex;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: ZenTokens.s1),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(ZenTokens.radiusZenLg),
                          onTap: () => _onItemTapped(index, context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: ZenTokens.s3, vertical: ZenTokens.s2),
                            decoration: BoxDecoration(
                              color: isActive ? ZenTokens.zenPrimary.withValues(alpha: 0.15) : Colors.transparent,
                              borderRadius: BorderRadius.circular(ZenTokens.radiusZenLg),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  item.icon,
                                  size: 20,
                                  color: isActive ? ZenTokens.zenPrimary : ZenTokens.zenFgMuted,
                                ),
                                const SizedBox(width: ZenTokens.s3),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                                      color: isActive ? ZenTokens.zenPrimary : ZenTokens.zenFgMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(int selectedIndex, BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32.0, sigmaY: 32.0),
        child: Container(
          height: 64 + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.10))),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isActive = index == selectedIndex;
                return GestureDetector(
                  onTap: () => _onItemTapped(index, context),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: ZenTokens.s1),
                    padding: const EdgeInsets.symmetric(horizontal: ZenTokens.s3, vertical: ZenTokens.s1),
                    decoration: BoxDecoration(
                      color: isActive ? ZenTokens.zenPrimary.withValues(alpha: 0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(ZenTokens.radiusZenFull),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: isActive ? ZenTokens.zenPrimary : ZenTokens.zenFgMuted,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                            color: isActive ? ZenTokens.zenPrimary : ZenTokens.zenFgMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
