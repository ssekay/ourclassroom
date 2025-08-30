import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/attendancecontroller.dart';
import '../utils/constants.dart';

class AttendanceListStudent extends StatefulWidget {
  const AttendanceListStudent({super.key});

  @override
  State<AttendanceListStudent> createState() => _AttendanceListStudentState();
}

class _AttendanceListStudentState extends State<AttendanceListStudent> {
  AttendanceController attendanceController = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> attendanceStatics = {
      '결석': 0,
      '지각': 0,
      '조퇴': 0,
      '결과': 0
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('출결 기록'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                attendanceController.fetchAttendanceData();
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
        if (attendanceController.isLoadingAttendanceData.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (attendanceController.attendanceData.isEmpty) {
          return Center(
            child: Text(attendanceController.fetchMessage.value),
          );
        } else {
          final dataList = attendanceController.attendanceData
              .where((e) => e.number == Constants.currentUser.number)
              .toList();
          for (var item in dataList) {
            switch (item.division1) {
              case '결석':
                attendanceStatics['결석']++;
              case '지각':
                attendanceStatics['지각']++;
              case '조퇴':
                attendanceStatics['조퇴']++;
              case '결과':
                attendanceStatics['결과']++;
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue[200]!, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Text(
                      '결석 : ${attendanceStatics['결석']}, 지각 : ${attendanceStatics['지각']}, 조퇴 : ${attendanceStatics['조퇴']}, 결과 : ${attendanceStatics['결과']}')),
              const SizedBox(height: 10,),
              dataList.isEmpty ? const Center(child: Text('자료가 없습니다.'),)
              : Expanded(
                child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final data = dataList[index];
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    DateFormat('M월 d일').format(data.date!),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(DateFormat('(E)', 'ko_KR')
                                      .format(data.date!)),
                                ],
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '구분 : ${data.division1}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    '내용 : ${data.division2}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        }
      }),
    );
  }
}
