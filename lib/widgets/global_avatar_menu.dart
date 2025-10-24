import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GlobalAvatarMenu extends StatefulWidget {
  const GlobalAvatarMenu({super.key});

  @override
  State<GlobalAvatarMenu> createState() => _GlobalAvatarMenuState();
}

class _GlobalAvatarMenuState extends State<GlobalAvatarMenu> {
  // Neon & background colors
  static const neon = Colors.greenAccent;
  static const bg = Color(0xFF0B0B0B);
  static const itemBg = Color(0xFF141414);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<_MenuAction>(
        tooltip: 'User menu',
        offset: const Offset(0, 50),
        color: itemBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (action) => _handleMenuAction(action),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: _MenuAction.profile,
            child: _buildMenuRow(Icons.person, 'Profile'),
          ),
          PopupMenuItem(
            value: _MenuAction.notifications,
            child: _buildMenuRow(Icons.notifications, 'Notifications'),
          ),
          PopupMenuItem(
            value: _MenuAction.settings,
            child: _buildMenuRow(Icons.settings, 'Settings'),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: _MenuAction.logout,
            child: _buildMenuRow(Icons.logout, 'Logout'),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: neon, width: 2),
            color: bg,
          ),
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF141414),
            child: Icon(Icons.person, color: neon, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: neon, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Future<void> _handleMenuAction(_MenuAction action) async {
    switch (action) {
      case _MenuAction.profile:
        Navigator.pushNamed(context, '/profile'); // replace with your route
        break;
      case _MenuAction.notifications:
        Navigator.pushNamed(context, '/notifications'); // replace with your route
        break;
      case _MenuAction.settings:
        Navigator.pushNamed(context, '/settings'); // replace with your route
        break;
      case _MenuAction.logout:
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Logout'),
              ),
            ],
          ),
        );

        if (shouldLogout ?? false) {
          await FirebaseAuth.instance.signOut();
          if (!mounted) return; // async-safe
          Navigator.pushReplacementNamed(context, '/login');
        }
        break;
    }
  }
}

enum _MenuAction { profile, notifications, settings, logout }
