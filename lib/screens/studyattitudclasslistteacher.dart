import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart' show AndroidPathProvider;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ourclassroom/services/snackbar_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../controllers/studyattitudecontroller.dart';
import '../utils/constants.dart';

class StudyAttitudeClassListTeacher extends StatefulWidget {
  const StudyAttitudeClassListTeacher({super.key});

  @override
  State<StudyAttitudeClassListTeacher> createState() =>
      _StudyAttitudeClassListTeacherState();
}

class _StudyAttitudeClassListTeacherState
    extends State<StudyAttitudeClassListTeacher> {
  StudyAttitudeController studyAttitudeController =
      Get.put(StudyAttitudeController());
  SnackBarService snackBarService = SnackBarService();
  int? selectedGrade;
  int? selectedClass;
  List<int> grades = [1, 2, 3];
  List<int> classes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSelected ? Text('$selectedGrade학년 $selectedClass반 학습 태도') : const Text('학습 태도'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  final dataList = studyAttitudeController.studyAttitudeData.where((e) => e.grade == Constants.currentUser.grade
                  && e.classNum == Constants.currentUser.classNum && e.number == Constants.currentUser.number && e.name == Constants.currentUser.name)
                      .map((data) => data.toJson())
                      .toList();
                  if(dataList.isNotEmpty) {
                    dataList.sort((a, b) => a['id'].compareTo(b['id']));
                    for(int i=0; i<dataList.length; i++){
                      dataList[i]['id'] = i+1;
                      if(dataList[i]['attitude'] <= 20) {
                        dataList[i]['attitude'] = studyAttitudeController.attitudeBadCode.firstWhere((e) => e.code == dataList[i]['attitude']).explain!;
                      } else {
                        dataList[i]['attitude'] = studyAttitudeController.attitudeGoodCode.firstWhere((e) => e.code == dataList[i]['attitude']).explain!;
                      }
                    }
                    final csv = convertToCSV(dataList,'studyAttitudeData');
                    await saveCSV(csv, 'studyAttitudeData');
                    snackBarService.showCustomSnackBar('자료가 저장되었습니다.', Colors.green[200]!);
                  } else {
                    snackBarService.showCustomSnackBar('자료가 없습니다.', Colors.orange[200]!);
                  }
                } catch (e) {
                  snackBarService.showCustomSnackBar('오류 : $e', Colors.orange[200]!);
                }
              },
            icon: const Icon(Icons.download),
          ),
          const SizedBox(width: 30,)
        ],
      ),
      body: !isSelected
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    spacing: 8,
                    children: grades.map((grade) {
                      return ChoiceChip(
                        color: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          // Your logic to determine the color based on the states
                          if (states.contains(WidgetState.selected)) {
                            return Colors.blue; // Example: Blue when pressed
                          } else {
                            return Colors.white; // Example: Default color
                          }
                        }),
                        showCheckmark: false,
                        label: Text('$grade학년'),
                        selected: selectedGrade == grade,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedGrade = selected ? grade : null;
                            if (selectedGrade != null &&
                                selectedClass != null) {
                              isSelected = true;
                            } else {
                              isSelected = false;
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 5,
                    children: classes.map((classNum) {
                      return ChoiceChip(
                        color: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          // Your logic to determine the color based on the states
                          if (states.contains(WidgetState.selected)) {
                            return Colors.green; // Example: Blue when pressed
                          } else {
                            return Colors.white; // Example: Default color
                          }
                        }),
                        showCheckmark: false,
                        label: Text('$classNum반'),
                        selected: selectedClass == classNum,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedClass = selected ? classNum : null;
                            if (selectedGrade != null &&
                                selectedClass != null) {
                              isSelected = true;
                            } else {
                              isSelected = false;
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          : Obx(() {
              if (studyAttitudeController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final dataList = studyAttitudeController.studyAttitudeData
                    .where((e) =>
                        e.studentGrade == selectedGrade && e.studentClass == selectedClass
                            && e.grade == Constants.currentUser.grade && e.classNum == Constants.currentUser.classNum && e.number == Constants.currentUser.number
                            && e.name == Constants.currentUser.name)
                    .toList();
                dataList.sort((a, b) => a.studentNumber!.compareTo(b.studentNumber!));
                return GestureDetector(
                  onLongPress: () {
                    setState(() {
                      isSelected = false;
                      selectedGrade = null;
                      selectedClass = null;
                    });
                  },
                  child: Column(
                    children: [
                      const Center(child: Text('길게 누르면 선택 화면으로 돌아갑니다.')),
                      const SizedBox(height: 10,),
                      dataList.isEmpty ? const Center(child: Text('데이터가 없습니다.')) : Expanded(
                        child: ListView.builder(
                            itemCount: dataList.length,
                            itemBuilder: (context, index) {
                              final data = dataList[index];
                              return Container(
                                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${data.studentNumber}번 ${data.studentName}',
                                      style:
                                      const TextStyle(fontSize: 16),
                                    ),
                                    data.attitude! <= 20 ?
                                    Text(
                                      studyAttitudeController.attitudeBadCode.firstWhere((e) => e.code == data.attitude).explain!,
                                      style:
                                      const TextStyle(fontSize: 16),
                                    ) :
                                    Text(
                                      studyAttitudeController.attitudeGoodCode.firstWhere((e) => e.code == data.attitude).explain!,
                                      style:
                                      const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      DateFormat('M월 d일(E)', 'ko_KR')
                                          .format(data.time!),
                                      style:
                                          const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                );
              }
            }),
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
      case 'studyAttitudeData':
        return ['순번','학년','반','번호','이름','학생학년','학생반','학생번호','학생이름','학습태도','시간'];
      default : return [];
    }
  }
}
