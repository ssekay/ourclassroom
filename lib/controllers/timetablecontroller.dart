import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class TimeTableController extends GetxController {
  final ApiService _apiService = ApiService();
  RxList<TimeTableData> timeTableData = <TimeTableData>[].obs;
  RxBool isLoading = false.obs;
  RxString fetchMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
      fetchTimeTableData();
  }

  Future<void> fetchTimeTableData() async {
    isLoading.value = true;
    fetchMessage.value = '';
    timeTableData.clear();
    Map<String, dynamic> postData = {
      'action': 'get_timetable_data',
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      for (var item in responseData['timetabledata']) {
        timeTableData.add(TimeTableData.fromJson(item));
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
