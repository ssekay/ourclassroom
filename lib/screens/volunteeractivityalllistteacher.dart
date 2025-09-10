import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/volunteeractivitycontroller.dart';

class VolunteerActivityAllListTeacher extends StatefulWidget {
  const VolunteerActivityAllListTeacher({super.key});

  @override
  State<VolunteerActivityAllListTeacher> createState() => _VolunteerActivityAllListTeacherState();
}

class _VolunteerActivityAllListTeacherState extends State<VolunteerActivityAllListTeacher> {
  final volunteerActivityController = Get.put(VolunteerActivityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('모든 학생 봉사활동 기록 보기'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                volunteerActivityController.fetchVolunteerActivityData();
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
        if (volunteerActivityController.isFetchLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (volunteerActivityController.volunteerActivities.isEmpty) {
          return Center(
            child: Text(volunteerActivityController.fetchMessage.value),
          );
        } else {
          final dataList = volunteerActivityController.volunteerActivities;
          if(dataList.isEmpty) {
            return const Center(
              child: Text('자료가 없습니다.'),
            );
          } else {
            return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final data = dataList[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 2),
                    child: Container(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: const BorderRadius.all(Radius.circular(
                            15)),
                      ),
                      child: Row(
                        children: [
                          Text(data.name, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 20,),
                          Expanded(
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
                        ],
                      ),
                    ),
                  );
                });
          }}
      }),
    );
  }
}
