import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ourclassroom/controllers/praisecontroller.dart';
import 'package:ourclassroom/services/snackbar_service.dart';

import '../controllers/attendancecontroller.dart';

class AttendanceWriteTeacher extends StatefulWidget {
  const AttendanceWriteTeacher({super.key});

  @override
  State<AttendanceWriteTeacher> createState() => _AttendanceWriteTeacherState();
}

class _AttendanceWriteTeacherState extends State<AttendanceWriteTeacher> {
  AttendanceController attendanceController = Get.put(AttendanceController());
  PraiseController praiseController = Get.put(PraiseController());
  SnackBarService snackBarService = SnackBarService();

  final List<String> _divison1 = ['결석', '지각', '조퇴', '결과'];
  final List<String> _divison2 = ['인정', '질병', '미인정', '기타'];
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('출결기록하기'),
          centerTitle: true,
        ),
        body: Obx(() {
          if (praiseController.isLoadingPraiseFriend.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var data = praiseController.praiseFriendData;
            return Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: (){
                            setState(() {
                              selectedDate = selectedDate.add(const Duration(days: -1));
                            });
                          },
                          icon: const Icon(Icons.arrow_back_ios)
                      ),
                      const SizedBox(width: 10,),
                      Text(DateFormat('M월 d일(E)','ko_kr').format(selectedDate),style: const TextStyle(fontSize: 16),),
                      const SizedBox(width: 10,),
                      IconButton(
                          onPressed: (){
                            setState(() {
                              selectedDate = selectedDate.add(const Duration(days: 1));
                            });
                          },
                          icon: const Icon(Icons.arrow_forward_ios)
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
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
                                return Colors.blue; // Example: Blue when pressed
                              } else {
                                return Colors.white; // Example: Default color
                              }
                            }),
                            showCheckmark: false,
                            label: Text(
                              data[index]['name'],
                            ),
                            selected: attendanceController.selectedNumber.value ==
                                index+1,
                            onSelected: (bool selected) {
                              setState(() {
                                attendanceController.selectedNumber.value =
                                    selected ? index+1 : null;
                                attendanceController.selectedName.value =
                                    selected ? data[index]['name'] : null;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (attendanceController.selectedNumber.value != null)
                    Wrap( alignment: WrapAlignment.center,spacing: 10.0, runSpacing: 10, children: [
                      for (int index = 0; index < _divison1.length; index++)
                        ChoiceChip(
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
                          label: Text(
                            _divison1[index],
                          ),
                          selected:
                              attendanceController.selectedDivision1.value ==
                                  _divison1[index],
                          onSelected: (bool selected) {
                            setState(() {
                              attendanceController.selectedDivision1.value =
                                  selected ? _divison1[index] : null;
                            });
                          },
                        ),
                    ]),
                  const SizedBox(height: 20),
                  if (attendanceController.selectedDivision1.value != null)
                    Wrap( alignment: WrapAlignment.center,spacing: 10.0, runSpacing: 10, children: [
                      for (int index = 0; index < _divison2.length; index++)
                        ChoiceChip(
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
                          label: Text(
                            _divison2[index],
                          ),
                          selected:
                              attendanceController.selectedDivision2.value ==
                                  _divison2[index],
                          onSelected: (bool selected) {
                            setState(() {
                              attendanceController.selectedDivision2.value =
                                  selected ? _divison2[index] : null;
                            });
                          },
                        ),
                    ]),
                  const SizedBox(height: 50),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (attendanceController.selectedNumber.value == null ||
                            attendanceController.selectedDivision1.value ==
                                null || attendanceController.selectedDivision2.value == null) {
                          snackBarService.showCustomSnackBar('자료를 선택해주세요.', Colors.orange[200]!);
                        }else{
                          setState(() {
                            attendanceController.submitAttendanceData(selectedDate);
                            attendanceController.selectedNumber.value = null;
                            attendanceController.selectedDivision1.value = null;
                            attendanceController.selectedDivision2.value = null;
                            selectedDate = DateTime.now();
                          });
                        }
                      },
                      child: const Text('확인'),
                    ),
                  ),
                ],
              ),
            );
          }
        }));
  }
}
