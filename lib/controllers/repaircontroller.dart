
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../models/models.dart';
import '../services/api_service.dart';
import '../services/snackbar_service.dart';
import '../utils/constants.dart';

class RepairController extends GetxController{
  final ApiService _apiService = ApiService();
  final SnackBarService snackBarService = SnackBarService();
  final ImagePicker _imagePicker = ImagePicker();
  Rx<File?> selectedFile = Rx<File?>(null);

  RxList<RepairData> repairData = <RepairData>[].obs;
  RxBool isLoadingRepairData = false.obs;
  RxString fetchMessage = ''.obs;
  RxString insertStatus = '파일을 선택해주세요'.obs;
  RxBool isInserting = false.obs;

   @override
   void onInit() {
     super.onInit();
     fetchRepairData();
  }

  Future<void> fetchRepairData() async {
    isLoadingRepairData.value = true;
    fetchMessage.value='';
    repairData.clear();
    Map<String, dynamic> data = {'action': 'get_repair_data'};
    final response = await _apiService.postData(data);
    if (response['success']) {
      for (var item in response['repairData']) {
        repairData.add(RepairData.fromJson(item));
      }
    } else {
      if (response.containsKey('error')) {
        snackBarService.showCustomSnackBar(
          '오류 : ${response['error']}',
          Colors.orange[200]!,
        );
      } else {
        fetchMessage.value = response['message'];
      }
    }
    isLoadingRepairData.value = false;
  }

  Future<void> insertRepairData(RepairData repairData) async {
    isInserting.value = true;
    insertStatus.value = '업로드 중...';
    Map<String, dynamic> data = {
      // 전송할 자료
      'action': 'insert_repair_data', // Pass action in the body
      'grade' : Constants.currentUser.grade,
      'class' : Constants.currentUser.classNum,
      'teachername' : repairData.teacherName,
      'item': repairData.item,
      'location': repairData.location,
      'itemstate': repairData.itemState,
      'status': repairData.status,
      'etc': repairData.etc,
    };
    final response = await _apiService.uploadFile(selectedFile, data);
    if (response['success']) {
      insertStatus.value = '업로드 완료';
      selectedFile.value = null;
      snackBarService.showCustomSnackBar(
        '파일이 성공적으로 업로드되었습니다.',
        Colors.green[200]!,
      );
      await fetchRepairData();
    } else {
      if (response.containsKey('error')) {
        insertStatus.value = '업로드 중 오류';
        snackBarService.showCustomSnackBar(
          '오류 : ${response['error']}',
          Colors.orange[200]!,
        );
      } else {
        insertStatus.value = '업로드 실패';
        snackBarService.showCustomSnackBar(
          response['message'],
          Colors.orange[200]!,
        );
      }
    }
    isInserting.value = false;
  }

  Future<void> updateRepairData(int id, RepairData updatedData) async {
    Map<String, dynamic> postData = {
      'action': 'update_repair_data',
      'id': id,
      'teachername': updatedData.teacherName,
      'status': updatedData.status,
      'statusexplain' : updatedData.statusExplain,
      'apptime' : updatedData.appTime!.toIso8601String(),
      'receptiontime' : updatedData.receptionTime?.toIso8601String(),
      'completiontime' : updatedData.completionTime?.toIso8601String(),
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      await fetchRepairData();
      snackBarService.showCustomSnackBar(
          responseData['message'], Colors.green[200]!);
    } else {
      await fetchRepairData();
      if (responseData.containsKey('error')) {
        snackBarService.showCustomSnackBar(
            responseData['error'], Colors.orange[200]!);
      } else {
        snackBarService.showCustomSnackBar(
            responseData['message'], Colors.orange[200]!);
      }
    }
  }

  Future<void> selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.single.path != null) {
        File pickedFile = File(result.files.single.path!);
        int fileSizeInBytes = await pickedFile.length();
        double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
        if (fileSizeInMb > 2) {
          insertStatus.value = '파일 크기 조정 중...';
          img.Image? image = img.decodeImage(pickedFile.readAsBytesSync());
          if (image != null) {
            img.Image resizedImage;
            if (image.width > 500) {
              resizedImage = img.copyResize(image, width: 500);
            } else {
              resizedImage = image;
            }
            List<int> resizedImageBytes = img.encodePng(resizedImage);
            await pickedFile.writeAsBytes(resizedImageBytes);
            selectedFile.value = pickedFile;
            insertStatus.value = '파일 선택됨 : ${p.basename(selectedFile.value!.path)}';
          } else {
            insertStatus.value = '이미지 파일을 처리할 수 없습니다.';
            snackBarService.showCustomSnackBar('이미지 파일을 처리하는 중 문제가 발생했습니다.', Colors.orange[200]!);
          }
        } else{
          selectedFile.value = pickedFile;
          insertStatus.value = '파일 선택됨 : ${p.basename(selectedFile.value!.path)}';
        }

      } else {
        insertStatus.value = '파일을 선택해주세요';
      }
    } catch (e) {
      insertStatus.value = '파일 선택 오류 : $e';
      snackBarService.showCustomSnackBar(
        '파일선택 중 문제가 발생했습니다.',
        Colors.orange[200]!,
      );
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        // imageQuality: 85, // 이미지 품질 (0-100)
        maxWidth: 500, // 최대 너비 (선택 사항)
        // maxHeight: 1000, // 최대 높이 (선택 사항)
      );
      if (photo != null) {
        selectedFile.value = File(photo.path);
        insertStatus.value = '카메라 촬영: ${p.basename(selectedFile.value!.path)}';
      } else {
        insertStatus.value = '카메라 촬영이 취소되었습니다.';
      }
    } catch (e) {
      selectedFile.value = null; // 오류 시 기존 선택 유지 또는 null 처리
      insertStatus.value = '카메라 촬영 오류: $e';
      snackBarService.showCustomSnackBar('카메라 촬영 중 문제가 발생했습니다: $e', Colors.orange[200]!);
    }
  }
  void clearSelectedFile() {
    selectedFile.value = null;
    insertStatus.value = '파일을 선택해주세요';
  }

}