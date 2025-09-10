import 'package:get/get.dart';
import '../models/models.dart'; // News 모델을 import 합니다.
import '../services/api_service.dart';

class NewsController extends GetxController {
  var isLoading = true.obs;
  var newsList = <News>[].obs;

  void fetchNewsData(String query) async {
    try {
      isLoading(true);
      final fetchedNewsItems = await ApiService.naverNewsData(query);
      if (fetchedNewsItems != null) {
        for(var item in fetchedNewsItems) {
          newsList.add(News.fromJson(item));
        }
      } else {
        newsList.clear(); 
      }
    } catch (e) {
      Exception("오류 발생: $e");
      newsList.clear();
    } finally {
      isLoading(false);
    }
  }
}
