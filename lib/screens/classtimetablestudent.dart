
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/controllers/timetablecontroller.dart';
import '../utils/constants.dart';

class ClassTimetableStudent extends StatefulWidget {
  const ClassTimetableStudent({super.key});

  @override
  State<ClassTimetableStudent> createState() => _ClassTimetableStudentState();
}

class _ClassTimetableStudentState extends State<ClassTimetableStudent> {
  final TimeTableController timeTableController = Get.put(TimeTableController());

  final List<String> days = ['구분','월', '화', '수', '목', '금'];
  final List<String> periods = [
    '1교시\n08:00',
    '2교시\n09:00',
    '3교시\n10:00',
    '4교시\n11:00',
    '5교시\n13:00',
    '6교시\n14:00',
    '7교시\n15:00',
  ];

  List<List<String>> transposeTimetable(List<List<String>> originalTable) {
    // 원래 테이블이 비어있으면 빈 리스트 반환
    if (originalTable.isEmpty || originalTable[0].isEmpty) {
      return [];
    }

    // 원래 테이블의 행과 열의 개수
    int numRows = originalTable.length;
    int numCols = originalTable[0].length; // 모든 행의 열 개수가 같다고 가정

    // 전치된 테이블을 저장할 리스트 초기화
    // 새로운 테이블의 행 개수는 원래 테이블의 열 개수가 되고,
    // 새로운 테이블의 열 개수는 원래 테이블의 행 개수가 됩니다.
    List<List<String>> transposedTable = List.generate(
      numCols, // 새로운 행의 개수
          (col) => List.generate(
        numRows, // 새로운 열의 개수
            (row) => '', // 초기값 (나중에 채워짐)
        growable: false,
      ),
      growable: false,
    );

    // 데이터 전치
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        // 만약 원래 테이블의 특정 행이 다른 행들보다 짧을 경우를 대비한 안전장치
        if (j < originalTable[i].length) {
          transposedTable[j][i] = originalTable[i][j];
        } else {
          // 원래 데이터가 해당 위치에 없으면 빈 문자열 또는 다른 기본값 처리
          transposedTable[j][i] = '';
        }
      }
    }

    return transposedTable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Constants.currentUser.grade}학년 ${Constants.currentUser.classNum}반 학급 시간표'),
        centerTitle: true,
      ),
      body: Obx(() {
        if(timeTableController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final listData = transposeTimetable(timeTableController.timeTableData.where((e) => e.grade == Constants.currentUser.grade
              && e.classNum == Constants.currentUser.classNum && e.category == 'class').map((e) => e.toValueList()).toList());
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
                children: [
                  Row(
                    children: [
                      ...days.map((day) =>
                          Expanded(
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(day, style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ],
                  ),
                  Expanded(
                    child: AlignedGridView.count(
                        crossAxisCount: days.length,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                        itemCount: periods.length * days.length,
                        itemBuilder: (context, index) {
                          int row = index ~/ days.length;
                          int col = index % days.length;
                          Widget cellContent;
                          BoxDecoration decoration = BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: const BorderRadius.all(Radius.circular(5))
                          );

                          if (col == 0) {
                            cellContent = Text(periods[row],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold),);
                          } else {
                            String data = '';
                            if (row < listData.length && (col - 1) <
                                listData[row].length) {
                              data = listData[row][col - 1];
                            }
                            cellContent = Text(
                              data, textAlign: TextAlign.center,);
                          }
                          return Container(
                            alignment: Alignment.center,
                            decoration: decoration,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: cellContent,
                          );
                        }
                    ),
                  ),

                ]),
          );
      }
      }),
    );
  }
}
