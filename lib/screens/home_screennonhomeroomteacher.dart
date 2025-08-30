import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/screens/menulist_screennonhomeroomteacher.dart';

import '../controllers/bottomnavbarcontroller.dart';
import 'ai_screen.dart';

class HomeScreenNonHomeroomTeacher extends StatefulWidget {
  const HomeScreenNonHomeroomTeacher({super.key});

  @override
  State<HomeScreenNonHomeroomTeacher> createState() => _HomeScreenNonHomeroomTeacherState();
}

class _HomeScreenNonHomeroomTeacherState extends State<HomeScreenNonHomeroomTeacher> {

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
                MenuListScreenNonHomeroomTeacher(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
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