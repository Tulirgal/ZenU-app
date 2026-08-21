import 'dart:ui'; 
import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../core/theme/app_theme.dart'; 
 
class ZenNavItem { 
  final String label; 
  final String route; 
  final IconData icon; 
 
  const ZenNavItem({required this.label, required this.route, required this.icon}); 
} 
 
class ZenNavShell extends StatefulWidget { 
  final Widget child; 
  const ZenNavShell({super.key, required this.child}); 
 
  @override 
  State<ZenNavShell> createState() => _ZenNavShellState(); 
} 
 
class _ZenNavShellState extends State<ZenNavShell> { 
  static const _items = [ 
    ZenNavItem(label: 'Home', route: '/dashboard', icon: Icons.home_rounded), 
    ZenNavItem(label: 'Wellness', route: '/breathing', icon: Icons.monitor_heart_rounded), 
    ZenNavItem(label: 'Create', route: '/diary', icon: Icons.palette_rounded), 
    ZenNavItem(label: 'Explore', route: '/bubble', icon: Icons.auto_fix_high_rounded), 
    ZenNavItem(label: 'Seviyan', route: '/chat', icon: Icons.smart_toy_rounded), 
  ]; 
 
  bool _isActive(String route) { 
    final loc = GoRouterState.of(context).matchedLocation; 
    if (route == '/dashboard') return loc == '/dashboard'; 
    return loc.startsWith(route); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final isDesktop = MediaQuery.of(context).size.width >= 600; 
     
    return Scaffold( 
      backgroundColor: Colors.transparent, 
      extendBody: true, 
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(), 
      bottomNavigationBar: isDesktop ? null : _buildBottomNav(), 
    ); 
  } 
 
  Widget _buildDesktopLayout() { 
    return Row( 
      children: [ 
        _buildSidebar(), 
        Expanded(child: widget.child), 
      ], 
    ); 
  } 
 
  Widget _buildMobileLayout() { 
    return widget.child; 
  } 
 
  Widget _buildSidebar() { 
    return ClipRRect( 
      child: BackdropFilter( 
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16), 
        child: Container( 
          width: 80, 
          decoration: BoxDecoration( 
            color: Colors.white.withValues(alpha: 0.08), 
            border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.12))), 
          ), 
          child: Column( 
            children: [ 
              const SizedBox(height: 48), 
              ..._items.map((e) => _buildNavItem(e, true)), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildBottomNav() { 
    return ClipRRect( 
      child: BackdropFilter( 
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16), 
        child: Container( 
          height: 88, 
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom), 
          decoration: BoxDecoration( 
            color: Colors.white.withValues(alpha: 0.08), 
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.12))), 
          ), 
          child: Row( 
            children: _items.map((e) => Expanded(child: _buildNavItem(e, false))).toList(), 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildNavItem(ZenNavItem item, bool isSidebar) { 
    final active = _isActive(item.route); 
    final color = active ? ZenTokens.primary : ZenTokens.fgMuted; 
 
    return GestureDetector( 
      behavior: HitTestBehavior.opaque, 
      onTap: () => context.go(item.route), 
      child: Container( 
        height: isSidebar ? 80 : double.infinity, 
        alignment: Alignment.center, 
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [ 
            Container( 
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
              decoration: BoxDecoration( 
                color: active ? ZenTokens.primary.withValues(alpha: 0.2) : Colors.transparent, 
                borderRadius: BorderRadius.circular(ZenTokens.radiusMd), 
              ), 
              child: Icon(item.icon, color: color, size: 24), 
            ), 
            const SizedBox(height: 4), 
            Text( 
              item.label, 
              style: GoogleFonts.inter( 
                fontSize: 10, 
                fontWeight: FontWeight.w500, 
                letterSpacing: 0.02, 
                color: color, 
              ), 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
}
