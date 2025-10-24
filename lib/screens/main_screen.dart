import 'package:flutter/material.dart';
import 'package:echo/widgets/mini_player.dart';
import 'package:echo/screens/home_screen.dart';
import 'package:echo/screens/library_screen.dart';
import 'package:echo/screens/search_screen.dart';
import 'package:echo/widgets/global_avatar_menu.dart';


/// Main screen for Project Echo
/// Hosts Home, Library, and Search pages with a persistent MiniPlayer.


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    LibraryScreen(),
    SearchScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: _pages[_selectedIndex]),
              const SafeArea(
                bottom: true,
                child: MiniPlayer(),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 16,
            child: SafeArea(child: const GlobalAvatarMenu()),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00FF7F), Color(0xFF00C853)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withValues(alpha:  0.3), /// ⚠️ This project uses the Color.withValues() API
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music_outlined),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
          ],
        ),
      ),
    );
  }
}
