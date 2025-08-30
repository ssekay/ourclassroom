import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarService {
  void showCustomSnackBar(String message, Color color) {
    Get.snackbar(
      '',
      '',
      messageText: SizedBox(
        width: double.infinity,
        child: Center(
            child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        )),
      ),
      snackPosition: SnackPosition.BOTTOM,
      // Ensure it's at the bottom
      margin: const EdgeInsets.only(bottom: 70, left: 10, right: 10),
      // Adjust the bottom margin
      padding: const EdgeInsets.only(bottom: 25),
      // Add some padding
      backgroundColor: color,
      colorText: Colors.white,
      borderRadius: 30,
      duration: const Duration(seconds: 3),
    );
  }
}
