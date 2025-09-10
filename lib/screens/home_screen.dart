import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../controllers/bottomnavbarcontroller.dart';
import 'ai_screen.dart';
import 'attendance_screen.dart';
import 'health_screen.dart';
import 'praise_screen.dart';
import 'selfstudy_screen.dart';
import 'menulist_screen.dart';
import 'volunteeractivity_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavBarController>(
      init: BottomNavBarController(),
      builder: (controller) {
        return Scaffold(
          body: Center(
            child: IndexedStack(
              index: controller.tabIndex,
              children: const [
                AiScreen(),
                PraiseScreen(),
                SelfStudyScreen(),
                HealthScreen(),
                VolunteerActivityScreen(),
                AttendanceScreen(),
                MenuListScreen(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.tabIndex,
            onTap: controller.changeTab,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.wand_stars),
                label: 'AI',
                backgroundColor: Colors.blue,
                // ...
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.hand_thumbsup),
                label: '칭찬',
                backgroundColor: Colors.blue,
                // ...
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.square_pencil),
                label: '자습',
                backgroundColor: Colors.blue,
                // ...
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.bandage),
                label: '보건',
                backgroundColor: Colors.blue,
                // ...
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.heart_fill),
                label: '봉사',
                backgroundColor: Colors.blue,
                // ...
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.timer),
                label: '출결',
                backgroundColor: Colors.blue,
                // ...
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.list_bullet),
                label: '메뉴',
                backgroundColor: Colors.blue,
                // ...
              ),
            ],
          ),
        );
      },
    );
  }
}
