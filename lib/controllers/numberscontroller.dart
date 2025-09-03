import 'package:get/get.dart';
import '../models/models.dart'; // News 모델을 import 합니다.
import '../services/api_service.dart';

class NumbersController extends GetxController {
  var isLoading = true.obs;
  var numbersText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNumbersData();
  }

  void fetchNumbersData() async {
    try {
      isLoading(true);
      final fetchedNewsItems = await ApiService.numbersApi();
      if (fetchedNewsItems != null) {
        numbersText.value = fetchedNewsItems['text'];
      } else {
        numbersText.value = '';
      }
    } catch (e) {
      numbersText.value = '';
      Exception("오류 발생: $e");
    } finally {
      isLoading(false);
    }
  }
}
