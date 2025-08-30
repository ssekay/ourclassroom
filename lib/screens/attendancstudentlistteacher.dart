import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ourclassroom/controllers/praisecontroller.dart';

import '../controllers/attendancecontroller.dart';

class AttendanceStudentListTeacher extends StatefulWidget {
  const AttendanceStudentListTeacher({super.key});

  @override
  State<AttendanceStudentListTeacher> createState() => _AttendanceStudentListTeacherState();
}

class _AttendanceStudentListTeacherState extends State<AttendanceStudentListTeacher> {
  AttendanceController attendanceController = Get.put(AttendanceController());
  PraiseController praiseController = Get.put(PraiseController());
  String? selectedName;
  bool isViewAttendanceData = false;
  List<int> statics =[0,0,0,0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학생별 출결기록 보기'),
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
      body: !isViewAttendanceData ? Obx(() {
      if (praiseController.isLoadingPraiseFriend.value) {
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
                              isViewAttendanceData =
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
        :Obx(() {
        if (attendanceController.isLoadingAttendanceData.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (attendanceController.attendanceData.isEmpty) {
          return Center(
            child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    isViewAttendanceData = false;
                    selectedName = null;
                  });
                },
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
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
                      Text(attendanceController.fetchMessage.value),
                    ],
                  ),
                )),
          );
        } else {
          final dataList = attendanceController.attendanceData.where((e) => e.name == selectedName).toList();
          if (dataList.isEmpty) {
            return GestureDetector(
              onDoubleTap: () {
                setState(() {
                  isViewAttendanceData = false;
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
                        child: Text(selectedName!, style: const TextStyle(fontSize: 16),),),
                      const SizedBox(height: 20),
                      const Text('더블탭하면 이전화면으로 돌아갑니다.'),
                      const Text('자료가 없습니다.'),
                    ]),
              ),
            );
          }
          attendanceStatistic(dataList);
          return GestureDetector(
            onDoubleTap: (){
              setState(() {
                isViewAttendanceData = false;
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
                    child: Text(selectedName!, style: const TextStyle(fontSize: 16),),),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(child: Text('더블탭하면 이전화면으로 돌아갑니다.')),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[200]!, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Text('  결석 : ${statics[0]}      지각: ${statics[1]}      조퇴 : ${statics[2]}      결과 : ${statics[3]}  ',),),
                  Expanded(
                    child: ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          final data = dataList[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                            child: GestureDetector(
                              onLongPress: (){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("삭제 확인"),
                                        content: Text('${data.name} 자료를 삭제하시겠습니까?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text("취소"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("삭제"),
                                            onPressed: () {
                                              setState(() {
                                                attendanceController.deleteAttendanceData(data.id!);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });},

                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('M월 d일(E)','ko_KR').format(data.date!),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(
                                      width: 40,
                                    ),
                                    Text(
                                      '구분 : ${data.division1}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(
                                      width: 20,
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
              ),
            ),
          );
        }
      }),
    );
  }
  void attendanceStatistic(dynamic dataList){
    // 초기화
    statics=[0,0,0,0];
    for(var data in dataList ){
      switch (data.division1){
        case '결석' : statics[0]++;
        break;
        case '지각' : statics[1]++;
        break;
        case '조퇴' : statics[2]++;
        break;
        case '결과' : statics[3]++;
        break;
      }
    }
  }
}
