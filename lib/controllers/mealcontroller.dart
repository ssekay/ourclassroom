
import 'package:get/get.dart';
import 'package:ourclassroom/services/api_service.dart';

import '../models/models.dart';

class MealController extends GetxController{
  var isLoading = true.obs;
  var lunch = MealData.empty().obs;

  @override
  void onInit(){
    super.onInit();
    fetchMealData();
  }

  void fetchMealData() async {
    try {
      isLoading(true);
      final mealData = await ApiService.mealData();
      if (mealData != null) {
        lunch.value = mealData;
      } else {
        lunch.value = MealData.empty();
      }
      isLoading(false);
    } catch (e) {
      throw Exception('Failed to fetch meal data: $e');
    } finally {
      isLoading(false);
    }
  }
}