import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/praisecontroller.dart';
import '../controllers/volunteeractivitycontroller.dart';
import '../services/snackbar_service.dart';

class VolunteerActivityStudentListTeacher extends StatefulWidget {
  const VolunteerActivityStudentListTeacher({super.key});

  @override
  State<VolunteerActivityStudentListTeacher> createState() => _VolunteerActivityStudentListTeacherState();
}

class _VolunteerActivityStudentListTeacherState extends State<VolunteerActivityStudentListTeacher> {
  final volunteerActivityController = Get.put(VolunteerActivityController());
  PraiseController praiseController = Get.put(PraiseController());
  SnackBarService snackBarService = SnackBarService();
  String? selectedName;
  bool isViewVolunteerActivityData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학생별 봉사활동 기록 보기'),
        centerTitle: true,
      ),
      body: !isViewVolunteerActivityData
          ? Obx(() {
              if (praiseController.isLoadingPraiseFriend.value ||
                  volunteerActivityController.isFetchLoading.value) {
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
                            spacing: 5.0,
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
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  selected: selectedName == data[index]['name'],
                                  onSelected: (bool selected) {
                                    setState(() {
                                      selectedName =
                                          selected ? data[index]['name'] : null;
                                      isViewVolunteerActivityData =
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
                  volunteerActivityController.isFetchLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final  dataList = volunteerActivityController.volunteerActivities
                    .where((e) => e.name == selectedName)
                    .toList();
                if (dataList.isEmpty) {
                  return GestureDetector(
                      onDoubleTap: () {
                      setState(() {
                        isViewVolunteerActivityData = false;
                        selectedName = null;
                      });
                    },
                    child: Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue[200],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15)),
                              ),
                              child: Text(selectedName!, style: const TextStyle(fontSize: 13),),),
                            const SizedBox(height: 10),
                            const Text('더블탭하면 이전화면으로 돌아갑니다.'),
                            const Text('자료가 없습니다.'),
                          ]),
                    ),
                  );
                }
                return GestureDetector(
                    onDoubleTap: () {
                    setState(() {
                      isViewVolunteerActivityData = false;
                      selectedName = null;
                    });
                  },
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: const BorderRadius.all(
                                Radius.circular(15)),
                          ),
                          child: Text(selectedName!, style: const TextStyle(fontSize: 13),),),
                        const SizedBox(
                          height: 20,
                        ),
                        const Center(child: Text('더블탭하면 이전화면으로 돌아갑니다.',style: TextStyle(fontSize: 13),)),
                        Expanded(
                          child: ListView.builder(
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                final data = dataList[index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 20, right: 10, bottom: 5, top: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[200],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('기간 : ${DateFormat('M월 d일(E)', 'ko_KR').format(data.startTime)} - ${DateFormat('M월 d일(E)', 'ko_KR').format(data.endTime)}', style: const TextStyle(fontSize: 14)),
                                        Text('내용 : ${data.activityDetails}', style: const TextStyle(fontSize: 14),
                                            overflow: TextOverflow.visible),
                                        Text('시간 : ${data.recognizedTime.toString()}', style: const TextStyle(fontSize: 14)),
                                        Text('확인 : ${data.instructorName}선생님', style: const TextStyle(fontSize: 14))
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
