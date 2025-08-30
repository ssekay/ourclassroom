import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class SeatingChartController extends GetxController {
  final ApiService _apiService = ApiService();
  // 좌석표 데이터 변수
  RxList<SeatingChartData> seatingChartData = <SeatingChartData>[].obs;
  RxBool isLoadingSeatingChartData = false.obs;
  RxBool isLoadingSelectedSeatingChartData = false.obs;
  RxBool isLoadingLearningAttitudeData = false.obs;
  RxString fetchMessage = ''.obs;
  // 좌석표 그리드 크기
  double gridWidth = 42;
  double gridHeight = 42;
  // 스크린 사이즈
  Rx<Size> screenSize = const Size(0, 0).obs;
  late double chartWidth;
  late double chartHeight;
  late double chartX;
  late double chartY;

  @override
  void onInit() {
    super.onInit();
    fetchSeatingChartData();
  }

  Future<void> fetchSeatingChartData() async {
    isLoadingSeatingChartData.value = true;
    fetchMessage.value = '';
    seatingChartData.clear();

    Map<String, dynamic> postData = {
      'action': 'get_SeatingChart_data',
    };

    final responseData = await _apiService.postData(postData);

    if (responseData['success']) {
      for (var item in responseData['SeatingChartData']) {
        item['x'] = (double.tryParse(item['x'])! * gridWidth).toString();
        item['y'] = (double.tryParse(item['y'])! * gridWidth).toString();
        seatingChartData.add(SeatingChartData.fromJson(item));
      }
    } else {
      if (responseData.containsKey('error')) {
        fetchMessage.value = responseData['error'];
      } else {
        fetchMessage.value = responseData['message'];
      }
    }
    isLoadingSeatingChartData.value = false;
  }

  void updateScreenSize(Size size) {
    screenSize.value = size;
    chartWidth = screenSize.value.width*0.95;
    chartHeight = screenSize.value.height * 0.85;
    gridWidth = chartWidth / 32;
    gridHeight = gridWidth;
    chartX = (screenSize.value.width - chartWidth) / 2;
    chartY = (screenSize.value.height - chartHeight) / 2;
  }
}
