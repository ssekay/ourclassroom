import 'package:flutter/material.dart';
import '../controllers/selfstudycontroller.dart';
import 'package:get/get.dart';

import '../services/snackbar_service.dart';
import '../utils/constants.dart';

class SelfStudyNonApplicantTeacher extends StatefulWidget {
  const SelfStudyNonApplicantTeacher({super.key});

  @override
  State<SelfStudyNonApplicantTeacher> createState() => _SelfStudyNonApplicantState();
}

class _SelfStudyNonApplicantState extends State<SelfStudyNonApplicantTeacher> {
  SelfStudyController selfStudyController = Get.put(SelfStudyController());
  SnackBarService snackBarService = SnackBarService();

  // 미신청자 정보
  List<Map<String, dynamic>> nonApplicant = [];

  // 미신청자 학생 선택 변수
  String? selectedName;
  Map<String, dynamic>? selectedStudent = {};

  // 차시별 선택 결과 변수
  int? selectedTerm1;
  int? selectedTerm2;
  int? selectedTerm3;

  Map<int, String> selfStudyCodeToString8 =
  {0: '학교 > 교실자습',
    1: '귀가',
    10: '학교 > 이동 > 상담',
    11: '학교 > 이동 > 학교활동',
  };
  Map<int, String> selfStudyCodeToString1 =
  {0: '학교 > 교실자습',
    10: '학교 > 이동 > 상담',
    11: '학교 > 이동 > 학교활동',
    12: '학교 > 이동 > PMP실 이용',
    20: '귀가 > 학교 밖 자습',
    21: '귀가 > 학원/과외 > 국어',
    22: '귀가 > 학원/과외 > 수학',
    23: '귀가 > 학원/과외 > 영어',
    24: '귀가 > 학원/과외 > 전공어',
    25: '귀가 > 학원/과외 > 기타과목',
    26: '귀가 > 학교활동',
    27: '귀가 > 기타'};
  Map<int, String> selfStudyCodeToString2 =
  {0: '학교 > 교실자습',
    10: '학교 > 이동 > 상담',
    11: '학교 > 이동 > 학교활동',
    20: '귀가 > 학교 밖 자습',
    21: '귀가 > 학원/과외 > 국어',
    22: '귀가 > 학원/과외 > 수학',
    23: '귀가 > 학원/과외 > 영어',
    24: '귀가 > 학원/과외 > 전공어',
    25: '귀가 > 학원/과외 > 기타과목',
    26: '귀가 > 학교활동',
    27: '귀가 > 기타'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자습 미신청자 처리'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                selfStudyController.fetchSelfStudyData();
              });
            },
            icon: const Icon(Icons.refresh_rounded),
            iconSize: 30,
          ),
          const SizedBox(
            width: 10,
          )
        ],
        iconTheme: IconThemeData(color: Colors.blue[200]),
      ),
      body: Obx(() {
        if (selfStudyController.isLoadingSelfStudyData.value ||
            selfStudyController.isLoadingAllStudents.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (selfStudyController.allStudents.where((e) => e['grade'] == Constants.currentUser.grade
            && e['class'] == Constants.currentUser.classNum).isEmpty) {
          return const Center(child: Text('학급학생 명단이 없습니다.'),);
        } else {
          nonApplicantCalculate();
          return nonApplicant.isNotEmpty ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6.0,
                    runSpacing: -5,
                    children: [
                      for (int index = 0; index < nonApplicant.length; index++)
                        ChoiceChip(
                          color: WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                // Your logic to determine the color based on the states
                                if (states.contains(WidgetState.selected)) {
                                  return Colors
                                      .blue; // Example: Blue when pressed
                                } else {
                                  return Colors
                                      .white; // Example: Default color
                                }
                              }),
                          showCheckmark: false,
                          label: Text(
                            nonApplicant[index]['name'],
                          ),
                          selected: selectedName == nonApplicant[index]['name'],
                          onSelected: (bool selected) {
                            setState(() {
                              selectedName =
                              selected ? nonApplicant[index]['name'] : null;
                              selectedStudent =
                              selected ? nonApplicant[index] : null;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      border: Border.all(color: Colors.blue),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: DropdownButton<int>(
                        hint: const Text('8교시 선택하세요.'),
                        value: selectedTerm1,
                        icon: const Icon(Icons.arrow_circle_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedTerm1 = newValue; // null assertion 제거
                          });
                        },
                        items:
                        selfStudyCodeToString8.entries.map<DropdownMenuItem<int>>((
                            MapEntry<int, String> entry) {
                          return DropdownMenuItem<int>(
                            value: entry.key, // 키를 value로 사용
                            child: Text(entry.value,
                                style: const TextStyle(fontSize: 16)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      border: Border.all(color: Colors.blue),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:20.0, right: 20),
                      child: DropdownButton<int>(
                        hint: const Text('야자1차시 선택하세요.'),
                        value: selectedTerm2,
                        icon: const Icon(Icons.arrow_circle_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedTerm2 = newValue; // null assertion 제거
                          });
                        },
                        items:
                        selfStudyCodeToString1.entries.map<DropdownMenuItem<int>>((
                            MapEntry<int, String> entry) {
                          return DropdownMenuItem<int>(
                            value: entry.key, // 키를 value로 사용
                            child: Text(entry.value,
                                style: const TextStyle(fontSize: 16)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      border: Border.all(color: Colors.blue),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: DropdownButton<int>(
                        hint: const Text('야자2차시 선택하세요.'),
                        value: selectedTerm3,
                        icon: const Icon(Icons.arrow_circle_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedTerm3 = newValue; // null assertion 제거
                          });
                        },
                        items:
                        selfStudyCodeToString2.entries.map<DropdownMenuItem<int>>((
                            MapEntry<int, String> entry) {
                          return DropdownMenuItem<int>(
                            value: entry.key, // 키를 value로 사용
                            child: Text(entry.value,
                                style: const TextStyle(fontSize: 16)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (selectedName != null) {
                          if (selectedStudent != null && selectedTerm1 != null && selectedTerm2 != null &&
                              selectedTerm3 != null) {
                            selfStudyController.nonApplicantSubmitSelfStudyData(
                                int.parse(selectedStudent!['number']),
                                selectedStudent!['name'],
                                selectedTerm1!,
                                selectedTerm2!,
                                selectedTerm3!
                            );
                            setState(() {
                              selectedStudent = null;
                              selectedTerm1 = null;
                              selectedTerm2 = null;
                              selectedTerm3 = null;
                            });
                          } else {
                            snackBarService.showCustomSnackBar('모든 차시를 선택하세요.', Colors.orange[200]!);
                          }
                        } else {
                          snackBarService.showCustomSnackBar('학생을 선택하세요.', Colors.orange[200]!);
                        }
                      },
                      child: const Text('저장'),
                  ),
                ],
              ),
            ),
          ) :
          const Center(child: Text('미신청자가 없습니다.'),);
        }
      }),
    );
  }

  void nonApplicantCalculate() {
    bool isIn = false;
    nonApplicant.clear();
    final data = selfStudyController.selfStudyData.where((e) =>
    e.time!.day == DateTime
        .now()
        .day && e.time!.month == DateTime
        .now()
        .month).toList();
    final students = selfStudyController.allStudents.where((e) => e['grade'] == Constants.currentUser.grade && e['class'] == Constants.currentUser.classNum).toList();
    for (int i = 0; i < students.length; i++) {
      for (var item in data) {
        if (students[i]['name'] == item.name) {
          isIn = true;
        }
      }
      if (!isIn) {
        nonApplicant.add(students[i]);
      }
      isIn = false;
    }
  }
}
