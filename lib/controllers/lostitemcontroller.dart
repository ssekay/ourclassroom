
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/models/models.dart';

import '../services/api_service.dart';
import '../services/snackbar_service.dart';

class LostItemController extends GetxController {
  final ApiService _apiService = ApiService();
  final SnackBarService snackBarService = SnackBarService();
  RxList<LostItemData> lostData = <LostItemData>[].obs;

  var isLostDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLostData();
  }

  Future<void> fetchLostData() async {
    isLostDataLoading.value = true;
    lostData.clear();
    Map<String, dynamic> data = {'action': 'get_lost_data'};
    final response = await _apiService.postData(data);
    if (response['success']) {
      for (var item in response['lostdata']) {
        lostData.add(LostItemData.fromJson(item));
      }
    } else {
      if (response.containsKey('error')) {
        snackBarService.showCustomSnackBar(
          '오류 : ${response['error']}',
          Colors.orange[200]!,
        );
      }
    }
    isLostDataLoading.value = false;
  }

}
