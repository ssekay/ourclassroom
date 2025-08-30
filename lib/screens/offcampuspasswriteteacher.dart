
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/models/models.dart';
import '../controllers/offcampuspasscontroller.dart';
import '../controllers/selfstudycontroller.dart';
import '../services/snackbar_service.dart';
import '../utils/constants.dart';

class OffCampusPassWriteTeacher extends StatefulWidget {
  const OffCampusPassWriteTeacher({super.key});

  @override
  State<OffCampusPassWriteTeacher> createState() => _OffCampusPassWriteTeacherState();
}

class _OffCampusPassWriteTeacherState extends State<OffCampusPassWriteTeacher> {
  final offCampusPassController = Get.put(OffCampusPassController());
  final selfStudyController = Get.put(SelfStudyController());
  final SnackBarService snackBarService = SnackBarService();
  final GlobalKey<FormState> _offCampusPassFormKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();
  OffCampusPassData? offCampusPassData = OffCampusPassData();
  Map<String, dynamic>? selectedStudent;
  List<Map<String, dynamic>> studentList = [];
  TimeOfDay? selectedStartTime, selectedEndTime;
  int? selectedGrade, selectedClass;
  List<int> gradeList = [1, 2, 3];
  List<int> classList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // Adjusted DateTime helper function
  DateTime _getAdjustedDateTime(DateTime dateTime, int minuteInterval) {
    final int roundedMinute = (dateTime.minute ~/ minuteInterval) * minuteInterval;
    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, roundedMinute);
  }

  void _submitForm() async {
    if (_offCampusPassFormKey.currentState!.validate()) {
      _offCampusPassFormKey.currentState!.save();
      if (selectedStudent == null) {
        snackBarService.showCustomSnackBar('학생을 선택하세요.', Colors.orange[200]!);
        return;
      }
      if (offCampusPassData?.startTime == null) {
        snackBarService.showCustomSnackBar('시작 시간을 선택하세요.', Colors.orange[200]!);
        return;
      }
      if (offCampusPassData?.endTime == null) {
        snackBarService.showCustomSnackBar('종료 시간을 선택하세요.', Colors.orange[200]!);
        return;
      }
      if (offCampusPassData!.endTime!.isBefore(offCampusPassData!.startTime!) ||
          offCampusPassData!.endTime!.isAtSameMomentAs(offCampusPassData!.startTime!)) {
        snackBarService.showCustomSnackBar('종료 시간은 시작 시간 이후여야 합니다.', Colors.orange[200]!);
        return;
      }
      offCampusPassData?.grade = int.parse(selectedStudent!['grade']);
      offCampusPassData?.classNum = int.parse(selectedStudent!['classNum']);
      offCampusPassData?.number = int.parse(selectedStudent!['number']);
      offCampusPassData?.name = selectedStudent!['name'];
      offCampusPassData?.issuerGrade = Constants.currentUser.grade;
      offCampusPassData?.issuerClass = Constants.currentUser.classNum;
      offCampusPassData?.issuerNumber = Constants.currentUser.number;
      offCampusPassData?.issuerName = Constants.currentUser.name;
      // Consider renaming insertRepairData if it's for off-campus passes
      await offCampusPassController.insertOffCampusPassData(offCampusPassData!);
    } else {
      snackBarService.showCustomSnackBar('입력 내용을 확인하세요.', Colors.orange[200]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('외출증 발급'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
            padding: const EdgeInsets.all(5),
          child: Obx((){
            if (selfStudyController.isLoadingAllStudents.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              print(selectedClass);
              print(selectedGrade);
              print(studentList);
              print(selfStudyController.allStudents);
              return Form(
                key: _offCampusPassFormKey,
                child: SingleChildScrollView( // Added SingleChildScrollView for small screens
                  child: Column(
                    children: [
                      studentList.isEmpty ? Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 5.0,
                        runSpacing: -5,
                        children: [
                          for (int index = 0; index < gradeList.length; index++)
                            ChoiceChip(
                              color: WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Colors.blue;
                                    } else {
                                      return Colors.white;
                                    }
                                  }),
                              showCheckmark: false,
                              label: Text('${gradeList[index]}학년'),
                              selected: selectedGrade == gradeList[index],
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedGrade = selected ? gradeList[index] : null;
                                  if(selectedGrade != null && selectedClass != null){
                                    studentList = selfStudyController.allStudents.where((element) => element['grade'] == selectedGrade && element['classNum'] == selectedClass).toList();
                                  } else {
                                    studentList = [];
                                  }
                                });
                              },
                            ),
                        ],
                      ) : const SizedBox.shrink(),
                      const SizedBox(height: 10,),
                      studentList.isEmpty ? Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 5.0,
                        runSpacing: -5,
                        children: [
                          for (int index = 0; index < classList.length; index++)
                            ChoiceChip(
                              color: WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Colors.blue;
                                    } else {
                                      return Colors.white;
                                    }
                                  }),
                              showCheckmark: false,
                              label: Text(
                                '${classList[index]}반',
                              ),
                              selected: selectedClass == classList[index],
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedClass =
                                  selected ? classList[index] : null;
                                  if(selectedGrade != null && selectedClass != null){
                                    studentList = selfStudyController.allStudents.where((element) => element['grade'] == selectedGrade && element['classNum'] == selectedClass).toList();
                                  } else {
                                    studentList = [];
                                  }
                                });
                              },
                            ),
                        ],
                      ) : const SizedBox.shrink(),
                      const SizedBox(height: 10,),
                      studentList.isEmpty ? const SizedBox.shrink() : Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 5.0,
                        runSpacing: -5,
                        children: [
                          for (int index = 0; index < studentList.length; index++)
                            ChoiceChip(
                              color: WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Colors.blue;
                                    } else {
                                      return Colors.white;
                                    }
                                  }),
                              showCheckmark: false,
                              label: Text(
                                studentList[index]['name'],
                              ),
                              selected: selectedStudent == studentList[index],
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedStudent =
                                  selected ? studentList[index] : null;
                                });
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          controller: reasonController,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                              labelText: '외출 이유를 입력하세요.', // '입력하새요' -> '입력하세요'
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '외출 이유를 입력하세요.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null && value.isNotEmpty) {
                              offCampusPassData?.reason = value;
                            }
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text('시작 시간', style: TextStyle(fontSize: 18)),
                              SizedBox(
                                height: 150,
                                width: 180,
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.time,
                                  initialDateTime: _getAdjustedDateTime(DateTime.now(), 10),
                                  itemExtent: 28,
                                  onDateTimeChanged: (DateTime newStartTime) {
                                    setState(() {
                                      selectedStartTime = TimeOfDay.fromDateTime(newStartTime);
                                      offCampusPassData?.startTime = newStartTime;
                                      if (offCampusPassData?.endTime != null &&
                                          !offCampusPassData!.endTime!.isAfter(newStartTime)) {
                                        offCampusPassData?.endTime = null;
                                        selectedEndTime = null;
                                      }
                                    });
                                  },
                                  use24hFormat: true,
                                  minuteInterval: 10,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('종료 시간', style: TextStyle(fontSize: 18)),
                              SizedBox(
                                height: 150,
                                width: 180,
                                child: Builder(
                                  builder: (context) {
                                    DateTime? minDateForEndTimePicker;
                                    if (offCampusPassData?.startTime != null) {
                                      minDateForEndTimePicker = offCampusPassData!.startTime!.add(const Duration(minutes: 10)); // 최소 10분 후
                                    }

                                    DateTime initialEndTimeForPicker;
                                    if (offCampusPassData?.endTime != null &&
                                        (minDateForEndTimePicker == null || !offCampusPassData!.endTime!.isBefore(minDateForEndTimePicker))) {
                                      initialEndTimeForPicker = _getAdjustedDateTime(offCampusPassData!.endTime!, 10);
                                    } else if (offCampusPassData?.startTime != null) {
                                      DateTime potentialInitialEndTime = offCampusPassData!.startTime!.add(const Duration(minutes: 10)); // 기본 10분 후
                                       if (minDateForEndTimePicker != null && potentialInitialEndTime.isBefore(minDateForEndTimePicker)) {
                                          potentialInitialEndTime = minDateForEndTimePicker;
                                      }
                                      initialEndTimeForPicker = _getAdjustedDateTime(potentialInitialEndTime, 10);
                                       // 조정 후에도 minDate보다 이전이면 minDate 사용 (간격 문제 해결)
                                      if(minDateForEndTimePicker != null && initialEndTimeForPicker.isBefore(minDateForEndTimePicker)){
                                         initialEndTimeForPicker = _getAdjustedDateTime(minDateForEndTimePicker, 10);
                                          // 만약 minDate 자체가 interval에 안맞아서 조정된 값이 minDate보다 이전이면, 다음 interval로.
                                          if(initialEndTimeForPicker.isBefore(minDateForEndTimePicker)){
                                              initialEndTimeForPicker = initialEndTimeForPicker.add(const Duration(minutes:10));
                                          }
                                      }

                                    } else {
                                      initialEndTimeForPicker = _getAdjustedDateTime(DateTime.now().add(const Duration(minutes:10)), 10);
                                    }
                                    
                                    return CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.time,
                                      minimumDate: minDateForEndTimePicker,
                                      initialDateTime: initialEndTimeForPicker,
                                      itemExtent: 28,
                                      onDateTimeChanged: (DateTime newDateTime) {
                                        setState(() {
                                          selectedEndTime = TimeOfDay.fromDateTime(newDateTime);
                                          offCampusPassData?.endTime = newDateTime;
                                        });
                                      },
                                      use24hFormat: true,
                                      minuteInterval: 10,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: (){
                            _submitForm();
                            Get.back();
                            }, // Get.back()은 _submitForm 내부로 이동
                          child: const Text('발 급',style: TextStyle(fontSize: 20)))
                    ],
                  ),
                ),
              );
            }}),
        )
      ),
    );
  }
}
