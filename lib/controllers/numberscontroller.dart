import 'package:get/get.dart';
import '../services/api_service.dart';

class NumbersController extends GetxController {
  var isLoading = true.obs;
  var numbersText = ''.obs;

  void fetchNumbersData(String numbers) async {
    try {
      isLoading(true);
      final fetchedNewsItems = await ApiService.numbersApi(numbers);
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
