import 'package:get/get.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/snackbar_service.dart';
import '../utils/constants.dart';

class VolunteerActivityController extends GetxController {
  final ApiService _apiService = ApiService();
  final SnackBarService snackBarService = SnackBarService();
  RxList<VolunteerActivityData> volunteerActivities =
      <VolunteerActivityData>[].obs;
  RxBool isFetchLoading = false.obs;
  RxString fetchMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVolunteerActivityData();
  }

  Future<void> fetchVolunteerActivityData() async {
    isFetchLoading.value = true;
    volunteerActivities.clear();
    Map<String, dynamic> postData = {
      'action': 'get_volunteeractivity_data',
      'grade': Constants.currentUser.grade,
      'class': Constants.currentUser.classNum,
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      for (var item in responseData['volunteeractivitydata']) {
        volunteerActivities.add(VolunteerActivityData.fromJson(item));
      }
    } else {
      if (responseData.containsKey('error')) {
        fetchMessage.value = responseData['error'];
      } else {
        fetchMessage.value = responseData['message'];
      }
    }
    isFetchLoading.value = false;
  }
}
