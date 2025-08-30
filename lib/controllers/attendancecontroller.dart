
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/services/api_service.dart';
import 'package:ourclassroom/services/snackbar_service.dart';

import '../models/models.dart';
import '../utils/constants.dart';

class AttendanceController extends GetxController {
  final ApiService _apiService = ApiService();
  final SnackBarService snackBarService = SnackBarService();
  RxList<AttendanceData> attendanceData = <AttendanceData>[].obs;
  RxBool isLoadingAttendanceData = false.obs;
  RxString fetchMessage = ''.obs;
  RxString submitMessage = ''.obs;
  Rxn<int> selectedNumber = Rxn<int>();
  Rxn<String> selectedDivision1 = Rxn<String>();
  Rxn<String> selectedDivision2 = Rxn<String>();
  Rxn<String> selectedName = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    if(!Constants.currentUser.isNonHomeroomTeacher) {
      fetchAttendanceData();
    }
  }

  Future<void> fetchAttendanceData() async {
    isLoadingAttendanceData.value = true;
    fetchMessage.value='';
    attendanceData.clear();
    Map<String, dynamic> postData = {
      'action': 'get_Attendance_data',
      'grade': Constants.currentUser.grade,
      'class': Constants.currentUser.classNum,
    };
    final responseData = await _apiService.postData(postData);

      if (responseData['success']) {
        for (var item in responseData['AttendanceData']) {
          attendanceData.add(AttendanceData.fromJson(item));
        }
      } else {
        if(responseData.containsKey('error')) {
          fetchMessage.value = responseData['error'];
        } else {
        fetchMessage.value = responseData['message'];
      }
    }
    isLoadingAttendanceData.value = false;
  }


  Future<void> submitAttendanceData(DateTime date) async {
    Map<String, dynamic> postData = {
      'action': 'insert_Attendance_data', // Pass action in the body
      'grade': Constants.currentUser.grade,
      'class': Constants.currentUser.classNum,
      'number': selectedNumber.value,
      'name': selectedName.value,
      'division1': selectedDivision1.value,
      'division2': selectedDivision2.value,
      'etc' : 0,
      'date': date.toIso8601String()
    };
    if (selectedNumber.value == null || selectedName.value == null || selectedDivision1.value == null || selectedDivision2.value == null) {
      snackBarService.showCustomSnackBar('자료를 선택해주세요.', Colors.orange[200]!);
      return;
    }
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      await fetchAttendanceData();
      snackBarService.showCustomSnackBar(responseData['message'], Colors.green[200]!);
    } else {
      if(responseData.containsKey('error')){
        snackBarService.showCustomSnackBar(responseData['error'], Colors.orange[200]!);
      }else{
        snackBarService.showCustomSnackBar(responseData['message'], Colors.orange[200]!);
      }
    }
  }

  Future<void> deleteAttendanceData(int id) async {
    Map<String, dynamic> postData = {
      'action': 'delete_Attendance_data', // Pass action in the body
      'id': id,
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      await fetchAttendanceData();
      snackBarService.showCustomSnackBar(responseData['message'], Colors.green[200]!);
    } else {
      if(responseData.containsKey('error')){
        snackBarService.showCustomSnackBar(responseData['error'], Colors.orange[200]!);
      }else{
        snackBarService.showCustomSnackBar(responseData['message'], Colors.orange[200]!);
      }
    }
  }

  Future<void> updateAttendanceData(int id, int etc) async {
    Map<String, dynamic> postData = {
      'action': 'update_Attendance_data', // Pass action in the body
      'id': id,
      'etc': etc
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      await fetchAttendanceData();
      snackBarService.showCustomSnackBar(responseData['message'], Colors.green[200]!);
    } else {
      if(responseData.containsKey('error')){
        snackBarService.showCustomSnackBar(responseData['error'], Colors.orange[200]!);
      }else{
        snackBarService.showCustomSnackBar(responseData['message'], Colors.orange[200]!);
      }
    }
  }

}
