import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/models/models.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../screens/certification.dart';
import '../screens/errorscreen.dart';
import '../screens/home_screen.dart';
import '../screens/home_screennonhomeroomteacher.dart';
import '../screens/unuseablescreen.dart';
import '../services/api_service.dart';
import '../services/snackbar_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  final StorageService _storageService = Get.find();
  final ApiService _apiService = ApiService();
  final SnackBarService _snackBarService = SnackBarService();
  Timer? _timer;
  RxBool isLoading = false.obs;
  RxString message = ''.obs;
  PackageInfo? _packageInfo;

  String? get certificationNumber =>
      _storageService.read(Constants.certificationNumberKey);

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    const duration = Duration(hours: 12);
    _timer = Timer.periodic(duration, (timer) {
      handleAuth();
    });
  }

  Widget handleAuth() {
    if (certificationNumber != null) {
      checkCertificationNumber(certificationNumber!);
      return Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const HomeScreen();
        }
      });
    } else {
      return const CertificationScreen();
    }
  }

  Future<void> checkCertificationNumber(String certificationNumber) async {
    isLoading.value = true;
    message.value = '';
    try {
      final response =
          await _apiService.checkCertificationNumber(certificationNumber);
      if (response['success']) {
        _storageService.write(
            Constants.certificationNumberKey, certificationNumber);
        _storageService.write(Constants.gradeKey, response['grade']);
        _storageService.write(Constants.classKey, response['class']);
        _storageService.write(Constants.numberKey, response['number']);
        _storageService.write(Constants.nameKey, response['name']);
        Constants.currentUser = CurrentUser.fromJson(response);
        _packageInfo = await PackageInfo.fromPlatform();
        String? targetPackageNamePart = _packageInfo!.packageName.split('.').last;
        if(Constants.currentUser.usedApp?.contains(targetPackageNamePart) ?? false) {
          if (response['class'] != '0') {
            if (response['number'] == '0') {
              Constants.currentUser.isHomeroomTeacher = true;
            }
            isLoading.value = false;
            Get.offAll(() => const HomeScreen());
          } else {
            isLoading.value = false;
            Constants.currentUser.isNonHomeroomTeacher = true;
            Get.offAll(() => const HomeScreenNonHomeroomTeacher());
          }
        } else {
          isLoading.value = false;
          _storageService.remove(Constants.gradeKey);
          _storageService.remove(Constants.classKey);
          _storageService.remove(Constants.numberKey);
          _storageService.remove(Constants.nameKey);
          _storageService.remove(Constants.certificationNumberKey);
          Get.offAll(() => const UnUseAbleScreen());
        }
      } else {
        if(response.containsKey('error')) {
          isLoading.value = false;
          Get.offAll(() => const ErrorScreen(errorCode: 1));
        } else {
          isLoading.value = false;
          _snackBarService.showCustomSnackBar(response['message'], Colors.orange);
          _storageService.remove(Constants.gradeKey);
          _storageService.remove(Constants.classKey);
          _storageService.remove(Constants.numberKey);
          _storageService.remove(Constants.nameKey);
          _storageService.remove(Constants.certificationNumberKey);
          Get.offAll(() => const CertificationScreen());
        }
      }
    } catch (e) {
      isLoading.value = false;
     Get.offAll(() => const ErrorScreen( errorCode: 2));
    } finally {
      isLoading.value = false;
    }
  }
}
