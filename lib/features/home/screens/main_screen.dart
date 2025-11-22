import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_colors.dart';
import '../../chat/screens/chat_list_screen.dart';
import '../../contacts/screens/contacts_screen.dart';
import '../../settings/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ChatListScreen(),
    ContactsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.electricBlue.withOpacity(0.2),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(LucideIcons.messageCircle),
              selectedIcon: Icon(LucideIcons.messageCircle),
              label: 'Chats',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.users),
              selectedIcon: Icon(LucideIcons.users),
              label: 'Contacts',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.settings),
              selectedIcon: Icon(LucideIcons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
