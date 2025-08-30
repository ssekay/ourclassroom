import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ourclassroom/services/snackbar_service.dart';

import '../controllers/helthcontroller.dart';
import '../controllers/praisecontroller.dart';
import '../utils/constants.dart';

class HealthStudentListTeacher extends StatefulWidget {
  const HealthStudentListTeacher({super.key});

  @override
  State<HealthStudentListTeacher> createState() => _HealthStudentListTeacherState();
}

class _HealthStudentListTeacherState extends State<HealthStudentListTeacher> {
  HealthController healthController = Get.put(HealthController());
  PraiseController praiseController = Get.put(PraiseController());
  SnackBarService snackBarService = SnackBarService();
  String? selectedName;
  bool isViewHealthData = false;

  @override
  Widget build(BuildContext context) {
    // String medication = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('학생별 보건기록 보기'),
        centerTitle: true,
      ),
      body: !isViewHealthData
          ? Obx(() {
              if (praiseController.isLoadingPraiseFriend.value ||
                  healthController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var data = praiseController.praiseFriendData;
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 6.0,
                            runSpacing: -5,
                            children: [
                              for (int index = 0; index < data.length; index++)
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
                                    data[index]['name'],
                                  ),
                                  selected: selectedName == data[index]['name'],
                                  onSelected: (bool selected) {
                                    setState(() {
                                      selectedName =
                                          selected ? data[index]['name'] : null;
                                      isViewHealthData =
                                          selected ? true : false;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }
            })
          : Obx(() {
              if (praiseController.isLoadingPraiseFriend.value ||
                  healthController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final healthDataList = healthController.healthData
                    .where((e) => e.name == selectedName && e.grade == Constants.currentUser.grade
                    && e.classNum == Constants.currentUser.classNum)
                    .toList();
                if (healthDataList.isEmpty) {
                  return GestureDetector(
                      onDoubleTap: () {
                      setState(() {
                        isViewHealthData = false;
                        selectedName = null;
                      });
                    },
                    child: Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue[200],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15)),
                              ),
                              child: Text(selectedName!, style: const TextStyle(fontSize: 16),),),
                            const SizedBox(height: 20),
                            const Text('더블탭하면 이전화면으로 돌아갑니다.'),
                            const Text('자료가 없습니다.'),
                          ]),
                    ),
                  );
                }
                return GestureDetector(
                    onDoubleTap: () {
                    setState(() {
                      isViewHealthData = false;
                      selectedName = null;
                    });
                  },
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: const BorderRadius.all(
                                Radius.circular(15)),
                          ),
                          child: Text(selectedName!, style: const TextStyle(fontSize: 16),),),
                        const SizedBox(
                          height: 30,
                        ),
                        const Center(child: Text('더블탭하면 이전화면으로 돌아갑니다.')),
                        Expanded(
                          child: ListView.builder(
                              itemCount: healthDataList.length,
                              itemBuilder: (context, index) {
                                final healthData = healthDataList[index];
                                // 보건증 발급앱 활성화 이후 사용
                                // if (healthData.therapy == '투약') {
                                //   medication =
                                //       healthData.medication1.toString();
                                //   if (healthData.medication2 != '') {
                                //     medication =
                                //         '$medication, ${healthData.medication2}';
                                //   }
                                //   if (healthData.medication3 != '') {
                                //     medication =
                                //         '$medication, ${healthData.medication3}';
                                //   }
                                // }
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[200],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              DateFormat('M월 d일(E)', 'ko_KR')
                                                  .format(healthData.app_time!),
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                            Text(DateFormat('hh시')
                                                .format(healthData.app_time!), style: const TextStyle(fontSize: 16),),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // 보건증 발급앱 활성화 이후 사용
                                            //healthData.iss_time != null ? const Text('보건증 발급', style: TextStyle(fontSize: 16),) : const Text('보건증 신청', style: TextStyle(fontSize: 16),),
                                            Text(
                                              '증상 : ${healthData.symptoms}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            // 보건증 발급앱 활성화 이후 사용
                                            // healthData.iss_time != null ? Text(
                                            //   '처치 : ${healthData.therapy}',
                                            //   style:
                                            //       const TextStyle(fontSize: 16),
                                            // ) : const SizedBox.shrink(),
                                            // healthData.therapy == '투약' ?
                                            //   Text(
                                            //     medication,
                                            //     style: const TextStyle(
                                            //         fontSize: 16),
                                            //   ) : const SizedBox.shrink(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
    );
  }
}
