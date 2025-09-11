
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
      offCampusPassData?.grade = int.parse(selectedStudent?['grade']);
      offCampusPassData?.classNum = int.parse(selectedStudent?['class']); // 모델 필드명은 classNum
      offCampusPassData?.number = int.parse(selectedStudent?['number']);
      offCampusPassData?.name = selectedStudent!['name'] as String?; // name은 String? 일 수 있음
      offCampusPassData?.issuerGrade = Constants.currentUser.grade;
      offCampusPassData?.issuerClass = Constants.currentUser.classNum;
      offCampusPassData?.issuerNumber = Constants.currentUser.number;
      offCampusPassData?.issuerName = Constants.currentUser.name;
      
      await offCampusPassController.insertOffCampusPassData(offCampusPassData!);
      // 성공 시 Get.back()은 버튼의 onPressed에서 호출
    } else {
      snackBarService.showCustomSnackBar('입력 내용을 확인하세요.', Colors.orange[200]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('외출증 발급'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Obx((){
          if (selfStudyController.isLoadingAllStudents.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Form(
              key: _offCampusPassFormKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // 담임이 아니거나, 담임이지만 학생 선택 UI를 직접 사용하고 싶을 때를 위해 항상 ChoiceChip 표시
                           Wrap(
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
                                  onSelected: (bool gradeWasSelected) {
                                    setState(() {
                                      selectedGrade = gradeWasSelected ? gradeList[index] : null;
                                      if(selectedGrade != null && selectedClass != null){
                                        studentList = selfStudyController.allStudents.where((e) => e['grade'] == selectedGrade.toString() && e['class'] == selectedClass.toString()).toList();
                                      } else {
                                        studentList = [];
                                      }
                                    });
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 5,),
                           Wrap(
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
                                  onSelected: (bool classWasSelected) {
                                    setState(() {
                                      selectedClass = classWasSelected ? classList[index] : null;
                                      if(selectedGrade != null && selectedClass != null){
                                        studentList = selfStudyController.allStudents.where((e) => e['grade'] == selectedGrade.toString() && e['class'] == selectedClass.toString()).toList();
                                      } else {
                                        studentList = [];
                                      }                                });
                                  },
                                ),
                            ],
                          ) ,
                          const SizedBox(height: 5,),
                          // 학생 선택 Chip은 studentList가 있을 때만 표시
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
                                    studentList[index]['name'] as String? ?? '이름없음',
                                  ),
                                  labelStyle: const TextStyle(fontSize: 14),
                                  labelPadding: const EdgeInsets.symmetric(horizontal: 1),
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
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              controller: reasonController,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                  labelText: '외출 이유를 입력하세요.',
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
                            height: 10,
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
                                          minDateForEndTimePicker = offCampusPassData!.startTime!.add(const Duration(minutes: 10));
                                        }

                                        DateTime initialEndTimeForPicker;
                                        if (offCampusPassData?.endTime != null &&
                                            (minDateForEndTimePicker == null || !offCampusPassData!.endTime!.isBefore(minDateForEndTimePicker))) {
                                          initialEndTimeForPicker = _getAdjustedDateTime(offCampusPassData!.endTime!, 10);
                                        } else if (offCampusPassData?.startTime != null) {
                                          DateTime potentialInitialEndTime = offCampusPassData!.startTime!.add(const Duration(minutes: 10));
                                           if (minDateForEndTimePicker != null && potentialInitialEndTime.isBefore(minDateForEndTimePicker)) {
                                              potentialInitialEndTime = minDateForEndTimePicker;
                                          }
                                          initialEndTimeForPicker = _getAdjustedDateTime(potentialInitialEndTime, 10);
                                          if(minDateForEndTimePicker != null && initialEndTimeForPicker.isBefore(minDateForEndTimePicker)){
                                             initialEndTimeForPicker = _getAdjustedDateTime(minDateForEndTimePicker, 10);
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                      onPressed: (){
                        _submitForm();
                        // _submitForm이 성공적으로 완료되었는지 여부에 따라 Get.back()을 조건부로 호출하는 것이 더 좋을 수 있습니다.
                        // 예를 들어, _submitForm이 bool을 반환하도록 하고, true일 때만 Get.back() 호출
                        Get.back();
                      },
                      child: const Text('발 급',style: TextStyle(fontSize: 20))),
                  const SizedBox(height: 100,),
                ],
              ),
            );
          }})
      ),
    );
  }
}
