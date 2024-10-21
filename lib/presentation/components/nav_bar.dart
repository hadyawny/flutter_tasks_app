import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function onTabChange;

  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black, // Background color
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),

        // Rounded top edges
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5.0,
            spreadRadius: 2.0,
            offset: const Offset(0, 2), // Position of the shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: GNav(
          backgroundColor: Colors.transparent,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
          gap: 8,
          onTabChange: (index) => onTabChange(index),
          selectedIndex: selectedIndex,
          padding: const EdgeInsets.all(16),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.pie_chart,
              text: 'Statistics',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Preferences',
            ),
          ],
        ),
      ),
    );
  }
}
