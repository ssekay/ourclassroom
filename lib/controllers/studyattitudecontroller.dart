
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/services/api_service.dart';
import '../models/models.dart';
import '../services/snackbar_service.dart';

class StudyAttitudeController extends GetxController {
  final ApiService _apiService = ApiService();
  final SnackBarService snackBarService = SnackBarService();
  RxList<StudyAttitudeData> studyAttitudeData = <StudyAttitudeData>[].obs;
  RxList<StudyAttitudeData> newStudyAttitudeData = <StudyAttitudeData>[].obs;
  final List<StudyAttitudeCodeData> attitudeGoodCode =[], attitudeBadCode =[];
  RxBool isLoading = false.obs;
  RxBool isCodeDataLoading = false.obs;
  RxBool isInsertLoading = false.obs;
  RxBool isDeleteLoading = false.obs;
  RxString fetchMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStudyAttitudeData();
    fetchStudyAttitudeCodeData();
  }

  Future<void> fetchStudyAttitudeData() async {
    isLoading.value = true;
    fetchMessage.value='';
    studyAttitudeData.clear();
    Map<String, dynamic> postData = {
      'action': 'get_studyattitude_data',
    };
    final responseData = await _apiService.postData(postData);
      if (responseData['success']) {
        for (var item in responseData['studyattitudedata']) {
          studyAttitudeData.add(StudyAttitudeData.fromJson(item));
        }
      } else {
        if (responseData.containsKey('error')) {
          fetchMessage.value = responseData['error'];
        } else {
          fetchMessage.value = responseData['message'];
        }
      }
    isLoading.value = false;
  }

  Future<void> fetchStudyAttitudeCodeData() async {
    isCodeDataLoading.value = true;
    fetchMessage.value='';

    Map<String, dynamic> postData = {
      'action': 'get_studyattitudecode_data',
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      for (var item in responseData['studyattitudecodedata']) {
        if(item['type']=='good'){
          attitudeGoodCode.add(StudyAttitudeCodeData.fromJson(item));
        }else{
          attitudeBadCode.add(StudyAttitudeCodeData.fromJson(item));
        }
      }
      attitudeGoodCode.sort((a, b) => a.code!.compareTo(b.code!));
      attitudeBadCode.sort((a, b) => a.code!.compareTo(b.code!));
    } else {
      if (responseData.containsKey('error')) {
        fetchMessage.value = responseData['error'];
      } else {
        fetchMessage.value = responseData['message'];
      }
    }
    isCodeDataLoading.value = false;
  }

  Future<void> insertStudyAttitudeData(List<StudyAttitudeData> studyAttitudeData) async {
    isInsertLoading.value = true;
    List<Map<String, dynamic>> dataList = studyAttitudeData.map((item) {
      return {
        'grade': item.grade,
        'class': item.classNum,
        'number': item.number,
        'name': item.name,
        'studentgrade': item.studentGrade,
        'studentclass': item.studentClass,
        'studentnumber': item.studentNumber,
        'studentname': item.studentName,
        'attitude': item.attitude,
        'time': item.time!.toIso8601String(), // null 체크 및 기본값
      };
    }).toList();

    Map<String, dynamic> postData = {
      'action': 'insert_studyattitude_data', // Pass action in the body
      'dataList': dataList,
    };

    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      await fetchStudyAttitudeData();
      newStudyAttitudeData.clear();
      snackBarService.showCustomSnackBar(responseData['message'], Colors.green[200]!);
    } else {
      if(responseData.containsKey('error')){
        snackBarService.showCustomSnackBar(responseData['error'], Colors.orange[200]!);
      }else{
        snackBarService.showCustomSnackBar(responseData['message'], Colors.orange[200]!);
      }
    }
    isInsertLoading.value = false;
  }

  // Future<void> deletePraiseData(int id) async {
  //   isDeleteLoading.value = true;
  //   Map<String, dynamic> postData = {
  //     'action': 'delete_studyattitude_data', // Pass action in the body
  //     'id': id,
  //   };
  //   final responseData = await _apiService.postData(postData);
  //   if (responseData['success']) {
  //     await fetchStudyAttitudeData();
  //     snackBarService.showCustomSnackBar(responseData['message'], Colors.green[200]!);
  //   } else {
  //     if(responseData.containsKey('error')){
  //       snackBarService.showCustomSnackBar(responseData['error'], Colors.orange[200]!);
  //     }else{
  //       snackBarService.showCustomSnackBar(responseData['message'], Colors.orange[200]!);
  //     }
  //   }
  //   isDeleteLoading.value = false;
  // }
}
