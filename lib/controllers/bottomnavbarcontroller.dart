
import 'package:get/get.dart';

class BottomNavBarController extends GetxController {
  int tabIndex = 0;

  void changeTab(int index) {
    tabIndex = index;
    update();
  }
}