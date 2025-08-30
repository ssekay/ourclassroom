import 'package:get/get.dart';

import '../services/api_service.dart';
import '../models/models.dart';
import '../utils/constants.dart';

class HealthController extends GetxController {
  final ApiService _apiService = ApiService();
  RxList<HealthData> healthData = <HealthData>[].obs;
  RxBool isLoading = false.obs;
  RxString fetchMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if(!Constants.currentUser.isNonHomeroomTeacher) {
    fetchHealthData();}
  }

  Future<void> fetchHealthData() async {
    isLoading.value = true;
    fetchMessage.value = '';
    healthData.clear();
    Map<String, dynamic> postData = {
      'action': 'get_health_data',
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      for (var item in responseData['healthData']) {
        healthData.add(HealthData.fromJson(item));
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
}
