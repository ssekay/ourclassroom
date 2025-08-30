
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/services/api_service.dart';

import '../models/models.dart';
import '../services/snackbar_service.dart';
import '../utils/constants.dart';

class PraiseController extends GetxController {
  final ApiService _apiService = ApiService();
  final SnackBarService snackBarService = SnackBarService();
  RxList<PraiseData> praiseData = <PraiseData>[].obs;
  RxList<Map<String, dynamic>> praiseFriendData = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingPraiseFriend = false.obs;
  RxString fetchMessage = ''.obs;
  RxString fetchFriendMessage = ''.obs;
  RxString submitMessage = ''.obs;
  RxInt praiseCount = 0.obs;


  @override
  void onInit() {
    super.onInit();
    if(!Constants.currentUser.isNonHomeroomTeacher) {
      fetchPraiseData();
      fetchPraiseFriendData();
    }
  }

  Future<void> fetchPraiseData() async {
    isLoading.value = true;
    fetchMessage.value='';
    praiseData.clear();
    Map<String, dynamic> postData = {
      'action': 'get_praise_data',
      'grade': Constants.currentUser.grade,
      'class': Constants.currentUser.classNum
    };
    final responseData = await _apiService.postData(postData);
      if (responseData['success']) {
        for (var item in responseData['praiseData']) {
          praiseData.add(PraiseData.fromJson(item));
        }
        praiseCount.value = praiseData.length;
      } else {
        if (responseData.containsKey('error')) {
          fetchMessage.value = responseData['error'];
        } else {
          fetchMessage.value = responseData['message'];
        }
      }
    isLoading.value = false;
  }

  Future<void> fetchPraiseFriendData() async {
    isLoadingPraiseFriend.value = true;
    fetchFriendMessage.value='';
    praiseFriendData.clear();

    Map<String, dynamic> postData = {
      'action': 'get_praiseFriend_data',
      'grade': Constants.currentUser.grade,
      'class': Constants.currentUser.classNum
    };
    final responseData = await _apiService.postData(postData);
      if (responseData['success']) {
        for (var item in responseData['praiseFriendData']) {
          praiseFriendData.add({'name' : item['name']});
        }
      } else {
        if(responseData.containsKey('error')) {
          fetchFriendMessage.value = responseData['error'];
        } else {
          fetchFriendMessage.value = responseData['message'];
        }
      }
    isLoadingPraiseFriend.value = false;
  }

  Future<void> submitPraiseData(PraiseData praiseData) async {
    isLoading.value = true;
    Map<String, dynamic> postData = {
      'action': 'insert_newPraise_data', // Pass action in the body
      'grade': praiseData.grade,
      'class': praiseData.classNum,
      'number': praiseData.number,
      'name': praiseData.name,
      'toname': praiseData.toname,
      'content': praiseData.content,
      'time': praiseData.time!.toIso8601String()
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      await fetchPraiseData();
      snackBarService.showCustomSnackBar(responseData['message'], Colors.green[200]!);
    } else {
      if(responseData.containsKey('error')){
        snackBarService.showCustomSnackBar(responseData['error'], Colors.orange[200]!);
      }else{
        snackBarService.showCustomSnackBar(responseData['message'], Colors.orange[200]!);
      }
    }
    isLoading.value = false;
  }

  Future<void> deletePraiseData(int id) async {
    isLoading.value = true;
    Map<String, dynamic> postData = {
      'action': 'delete_Praise_data', // Pass action in the body
      'id': id,
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      await fetchPraiseData();
      snackBarService.showCustomSnackBar(responseData['message'], Colors.green[200]!);
    } else {
      if(responseData.containsKey('error')){
        snackBarService.showCustomSnackBar(responseData['error'], Colors.orange[200]!);
      }else{
        snackBarService.showCustomSnackBar(responseData['message'], Colors.orange[200]!);
      }
    }
    isLoading.value = false;
  }
}
