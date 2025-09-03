
import 'package:get/get.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class NewsController extends GetxController {
  var isLoading = true.obs;
  var newsList = <News>[].obs;

  get $e => null;

  @override
  void onInit() {
    super.onInit();
    fetchNewsData();
  }

  void fetchNewsData() async {
    try {
      isLoading(true);
      final newsData = await ApiService.naverNewsData();
      for (var news in newsData) {
        newsList.add(News.fromJson(news));
      }
    } catch (e) {
      Exception('오류');
    } finally {
      isLoading(false);
    }
  }
}
