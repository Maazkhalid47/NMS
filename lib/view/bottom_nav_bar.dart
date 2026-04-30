import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:software_management/view/dashboard_screen.dart';
import 'package:software_management/view/profile_screen.dart';
import 'package:software_management/view/task_list_screen.dart';

import '../view_model/navigation_view_model.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Widget> _screens = [
      const DashboardScreen(),
      const TaskListScreen(),
      const Center(child: Text('Files')),
      const ProfileScreen(),
    ];
    final navVM = context.watch<NavigationViewModel>();

    return Scaffold(
      body: IndexedStack(
        index: navVM.currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF8F9FD),
        currentIndex: navVM.currentIndex,
          onTap: (index) => navVM.setIndex(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: const[
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: 'HOME'),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt),label: 'LIST'),
            BottomNavigationBarItem(icon: Icon(Icons.folder_open_outlined),label: 'FOLDER'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline),label: 'PROFILE')
          ]),
    );
  }
}
