import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:path/path.dart' as path show join;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/controllers/attendancecontroller.dart';
import 'package:ourclassroom/controllers/helthcontroller.dart';
import 'package:ourclassroom/controllers/praisecontroller.dart';
import 'package:ourclassroom/controllers/selfstudycontroller.dart';
import 'package:ourclassroom/services/snackbar_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class DownloadDataTeacher extends StatefulWidget {
  const DownloadDataTeacher({super.key});

  @override
  State<DownloadDataTeacher> createState() => _DownloadDataTeacherState();
}

class _DownloadDataTeacherState extends State<DownloadDataTeacher> {
  AttendanceController attendanceController = Get.put(AttendanceController());
  HealthController healthController = Get.put(HealthController());
  PraiseController praiseController = Get.put(PraiseController());
  SelfStudyController selfStudyController = Get.put(SelfStudyController());
  SnackBarService snackBarService = SnackBarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자료 다운로드'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() {
            if (attendanceController.isLoadingAttendanceData.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (attendanceController.attendanceData.isEmpty) {
              return const Center(
                child: Text('자료가 없습니다.'),
              );
            } else {
              return Center(
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final dataList = attendanceController.attendanceData
                            .map((data) => data.toJson())
                            .toList();
                        dataList.sort((a, b) => a['id'].compareTo(b['id']));
                        for(int i=0; i<dataList.length; i++){
                          dataList[i]['id'] = i+1;
                        }
                        final csv = convertToCSV(dataList,'attendanceData');
                        await saveCSV(csv, 'attendanceData');
                        snackBarService.showCustomSnackBar('자료가 저장되었습니다.', Colors.green[200]!);
                      } catch (e) {
                        snackBarService.showCustomSnackBar('오류 : $e', Colors.orange[200]!);
                      }
                    },
                    child: const Text('출석자료 저장')),
              );
            }
          }),
          const SizedBox(height: 30,),
          Obx(() {
            if (healthController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (healthController.healthData.isEmpty) {
              return const Center(
                child: Text('자료가 없습니다.'),
              );
            } else {
              return Center(
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final dataList = healthController.healthData
                            .map((data) => data.toJson())
                            .toList();
                        dataList.sort((a, b) => a['id'].compareTo(b['id']));
                        for(int i=0; i<dataList.length; i++){
                          dataList[i]['id'] = i+1;
                        }
                        final csv = convertToCSV(dataList,'healthData');
                        await saveCSV(csv, 'healthData');
                        snackBarService.showCustomSnackBar('자료가 저장되었습니다.', Colors.green[200]!);
                      } catch (e) {
                        snackBarService.showCustomSnackBar('오류 : $e', Colors.orange[200]!);
                      }
                    },
                    child: const Text('보건증 자료 저장')),
              );
            }
          }),
          const SizedBox(height: 30,),
          Obx(() {
            if (praiseController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (praiseController.praiseData.isEmpty) {
              return const Center(
                child: Text('자료가 없습니다.'),
              );
            } else {
              return Center(
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final dataList = praiseController.praiseData
                            .map((data) => data.toJson())
                            .toList();
                        dataList.sort((a, b) => a['id'].compareTo(b['id']));
                        for(int i=0; i<dataList.length; i++){
                          dataList[i]['id'] = i+1;
                        }
                        final csv = convertToCSV(dataList,'praiseData');
                        await saveCSV(csv, 'praiseData');
                        snackBarService.showCustomSnackBar('자료가 저장되었습니다.', Colors.green[200]!);
                      } catch (e) {
                        snackBarService.showCustomSnackBar('오류 : $e', Colors.orange[200]!);
                      }
                    },
                    child: const Text('칭찬 자료 저장')),
              );
            }
          }),
          const SizedBox(height: 30,),
          Obx(() {
            if (selfStudyController.isLoadingSelfStudyData.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (selfStudyController.selfStudyData.isEmpty) {
              return const Center(
                child: Text('자료가 없습니다.'),
              );
            } else {
              return Center(
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final dataList = selfStudyController.selfStudyData
                            .map((data) => data.toJson())
                            .toList();
                        dataList.sort((a, b) => a['id'].compareTo(b['id']));
                        for(int i=0; i<dataList.length; i++){
                          dataList[i]['id'] = i+1;
                        }
                        final csv = convertToCSV(dataList, 'selfStudyData');
                        await saveCSV(csv, 'selfStudyData');
                        snackBarService.showCustomSnackBar('자료가 저장되었습니다.', Colors.green[200]!);
                      } catch (e) {
                        snackBarService.showCustomSnackBar('오류 : $e', Colors.orange[200]!);
                      }
                    },
                    child: const Text('자습 자료 저장')),
              );
            }
          }),
        ],
      ),
    );
  }

  String convertToCSV(List<Map<String, dynamic>> dataList, String fieldName) {
    List<List<dynamic>> csvData = [];
    csvData.add(fieldNames(fieldName));
    for (var data in dataList) {
      csvData.add(data.values.toList());
    }
    return const ListToCsvConverter().convert(csvData);
  }

  Future<void> saveCSV(String csv, String filename) async {
    if (Platform.isAndroid) {
      final directory = await AndroidPathProvider.downloadsPath;
      final file = File(path.join(directory,'$filename.csv'));
      await file.writeAsString(csv);
    }
    if (Platform.isIOS) {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$filename.csv');
      await file.writeAsString(csv);
      final bytes = await file.readAsBytes();
      await Printing.sharePdf(bytes: bytes, filename: '$filename.csv');
    }
  }

  List<dynamic> fieldNames(String dataName) {
     switch(dataName){
      case 'attendanceData':
        return ['순번','학년','반','번호','이름','구분','내용','날짜'];
      case 'healthData':
        return ['순번','학년','반','번호','이름','증상','처치','약','약','약','신청시간','발급시간'];
      case 'praiseData':
        return ['순번','학년','반','번호','이름','창친한 학생','내용','날짜'];
      case 'selfStudyData':
        return ['순번','학년','반','번호','이름','1차시','2차시','3차시','날짜'];
       default : return [];
    }
  }
}
