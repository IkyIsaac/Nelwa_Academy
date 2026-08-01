import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../admin_constants.dart';
import '../design/admin_tokens.dart';
import 'admin_nav_items.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.currentPath, required this.child});

  final String currentPath;
  final Widget child;

  int get _selectedIndex {
    final index = kAdminNavItems.indexWhere((item) =>
        item.path == currentPath ||
        (item.path != '/' && currentPath.startsWith(item.path)));
    return index < 0 ? 0 : index;
  }

  String get _pageTitle => kAdminNavItems[_selectedIndex].label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.canvas,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Rail(selectedIndex: _selectedIndex),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TopBar(title: _pageTitle),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AdminSpace.xxl,
                      AdminSpace.xl,
                      AdminSpace.xxl,
                      AdminSpace.xxxl,
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: AdminColors.oxblood,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AdminSpace.xl, AdminSpace.xxl, AdminSpace.xl, AdminSpace.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NELWA', style: AdminType.display(22, weight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 2),
                Text('ACADEMY ADMIN', style: AdminType.eyebrow(color: AdminColors.onRailMuted)),
              ],
            ),
          ),
          Divider(color: AdminColors.onRailMuted.withValues(alpha: 0.25), height: 1),
          const SizedBox(height: AdminSpace.md),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AdminSpace.md),
              itemCount: kAdminNavItems.length,
              itemBuilder: (context, index) {
                final item = kAdminNavItems[index];
                final selected = index == selectedIndex;
                return _RailItem(
                  icon: item.icon,
                  label: item.label,
                  selected: selected,
                  onTap: () => context.go(item.path),
                );
              },
            ),
          ),
          Divider(color: AdminColors.onRailMuted.withValues(alpha: 0.25), height: 1),
          Padding(
            padding: const EdgeInsets.all(AdminSpace.lg),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: AdminColors.terracotta,
                  child: Text(
                    kAdminEmail.substring(0, 1).toUpperCase(),
                    style: AdminType.body(13, weight: FontWeight.w700, color: AdminColors.oxbloodDark),
                  ),
                ),
                const SizedBox(width: AdminSpace.sm),
                Expanded(
                  child: Text(
                    kAdminEmail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AdminType.body(12, color: AdminColors.onRail),
                  ),
                ),
                IconButton(
                  tooltip: 'Sign out',
                  icon: Icon(Icons.logout, size: 18, color: AdminColors.onRailMuted),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RailItem extends StatefulWidget {
  const _RailItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_RailItem> createState() => _RailItemState();
}

class _RailItemState extends State<_RailItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            decoration: BoxDecoration(
              color: active
                  ? Colors.white.withValues(alpha: 0.10)
                  : _hovering
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(AdminRadius.sm),
              border: Border(
                left: BorderSide(
                  color: active ? AdminColors.terracotta : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AdminSpace.md, vertical: AdminSpace.md),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 18,
                  color: active ? Colors.white : AdminColors.onRail,
                ),
                const SizedBox(width: AdminSpace.md),
                Expanded(
                  child: Text(
                    widget.label,
                    style: AdminType.body(
                      13,
                      weight: active ? FontWeight.w600 : FontWeight.w400,
                      color: active ? Colors.white : AdminColors.onRail,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: AdminSpace.xxl),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        border: Border(bottom: BorderSide(color: AdminColors.hairline)),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AdminType.display(20, weight: FontWeight.w600),
      ),
    );
  }
}
