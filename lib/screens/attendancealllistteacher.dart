import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/attendancecontroller.dart';

class AttendanceAllListTeacher extends StatefulWidget {
  const AttendanceAllListTeacher({super.key});

  @override
  State<AttendanceAllListTeacher> createState() => _AttendanceAllListTeacherState();
}

class _AttendanceAllListTeacherState extends State<AttendanceAllListTeacher> {
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
        title: const Text('모든 학생 출결기록 보기'),
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
          final dataList = attendanceController.attendanceData;
          attendanceStatics['결석'] = 0;
          attendanceStatics['지각'] = 0;
          attendanceStatics['조퇴'] = 0;
          attendanceStatics['결과'] = 0;
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
                        child: GestureDetector(
                          onLongPress: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    actionsAlignment: MainAxisAlignment.center,
                                    title: const Text("서류 제출 확인"),
                                    content: Text('${data.name} 출결서류를 제출했나요?'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: data.etc == true ? const Text("미제출") : const Text("제출"),
                                        onPressed: () {
                                          setState(() {
                                            if(data.etc == true) {
                                              attendanceController
                                                  .updateAttendanceData(
                                                  data.id!, 0);
                                            } else {
                                              attendanceController
                                                  .updateAttendanceData(
                                                  data.id!, 1);
                                            }
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: data.etc! ? Colors.blue[200] : Colors.orange[200],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('M월 d일(E)','ko_KR').format(data.date!),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${data.name}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '구분 : ${data.division1}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '내용 : ${data.division2}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
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
