import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/models/models.dart';
import '../services/api_service.dart';
import '../services/snackbar_service.dart';

class OffCampusPassController extends GetxController {
  final ApiService _apiService = ApiService();
  final SnackBarService snackBarService = SnackBarService();
  RxList<OffCampusPassData> offCampusPassData = <OffCampusPassData>[].obs;
  RxBool isLoadingOffCampusPassData = false.obs;
  RxString fetchMessage = ''.obs;
  RxBool isInserting = false.obs;
  RxBool isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOffCampusPassData();
  }

  Future<void> fetchOffCampusPassData() async {
    isLoadingOffCampusPassData.value = true;
    fetchMessage.value='';
    offCampusPassData.clear();
    Map<String, dynamic> data = {
      'action': 'get_offcampuspass_data',
    };
    final response = await _apiService.postData(data);
    if (response['success']) {
      for (var item in response['offcampuspassData']) {
        offCampusPassData.add(OffCampusPassData.fromJson(item));
      }
    } else {
      if (response.containsKey('error')) {
        snackBarService.showCustomSnackBar(
          '오류 : ${response['error']}',
          Colors.orange[200]!,
        );
      } else {
        fetchMessage.value = response['message'];
      }
    }
    isLoadingOffCampusPassData.value = false;
  }

  Future<void> insertOffCampusPassData(OffCampusPassData offCampusPassData) async {
    isInserting.value = true;
    Map<String, dynamic> data = {
      // 전송할 자료
      'action': 'insert_offcampuspass_data', // Pass action in the body
      'grade' : offCampusPassData.grade,
      'class' : offCampusPassData.classNum,
      'number' : offCampusPassData.number,
      'name' : offCampusPassData.name,
      'reason' : offCampusPassData.reason,
      'starttime' : offCampusPassData.startTime!.toIso8601String(),
      'endtime' : offCampusPassData.endTime!.toIso8601String(),
      'issuergrade' : offCampusPassData.issuerGrade,
      'issuerclass' : offCampusPassData.issuerClass,
      'issuernumber' : offCampusPassData.issuerNumber,
      'issuername' : offCampusPassData.issuerName,
    };
    final response = await _apiService.postData(data);
    if (response['success']) {
      snackBarService.showCustomSnackBar(
        '외출증이 발급 되었습니다.',
        Colors.green[200]!,
      );
      await fetchOffCampusPassData();
    } else {
      if (response.containsKey('error')) {
        snackBarService.showCustomSnackBar(
          '오류 : ${response['error']}',
          Colors.orange[200]!,
        );
      } else {
        snackBarService.showCustomSnackBar(
          response['message'],
          Colors.orange[200]!,
        );
      }
    }
    isInserting.value = false;
  }

  Future<void> deleteOffCampusPassData(int id) async {
    isDeleting.value = true;
    Map<String, dynamic> data = {
      // 전송할 자료
      'action': 'delete_offcampuspass_data', // Pass action in the body
      'id' : id,
    };
    final response = await _apiService.postData(data);
    if (response['success']) {
      await fetchOffCampusPassData();
    } else {
      if (response.containsKey('error')) {
        snackBarService.showCustomSnackBar(
          '오류 : ${response['error']}',
          Colors.orange[200]!,
        );
      } else {
        snackBarService.showCustomSnackBar(
          response['message'],
          Colors.orange[200]!,
        );
      }
    }
    isDeleting.value = false;
  }
}
