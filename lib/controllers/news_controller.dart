import 'package:get/get.dart';
import '../models/models.dart'; // News 모델을 import 합니다.
import '../services/api_service.dart';

class NewsController extends GetxController {
  var isLoading = true.obs;
  // newsList는 RxList<News> 타입이므로, <News>[].obs로 초기화합니다.
  var newsList = <News>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNewsData();
  }

  void fetchNewsData() async {
    try {
      isLoading(true);
      // ApiService.naverNewsData()는 이제 List<News>? 를 반환합니다.
      final fetchedNewsItems = await ApiService.naverNewsData();
      
      if (fetchedNewsItems != null) {
        // 받아온 뉴스 리스트로 newsList를 업데이트합니다.
        newsList.value = fetchedNewsItems;
      } else {
        // 데이터가 null이거나 문제가 발생했을 경우, newsList를 비웁니다.
        newsList.clear(); 
      }
    } catch (e) {
      // 오류 발생 시 사용자에게 알림을 표시하고, newsList를 비웁니다.
      Get.snackbar('오류', '뉴스 데이터를 불러오는 데 실패했습니다: ${e.toString()}');
      newsList.clear();
    } finally {
      isLoading(false);
    }
  }
}
