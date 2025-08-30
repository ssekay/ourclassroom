import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/seatingchartcontroller.dart';
import '../controllers/studyattitudecontroller.dart';
import '../models/models.dart';
import '../utils/constants.dart';

class SeatingChartTeacher extends StatefulWidget {
  const SeatingChartTeacher({super.key});

  @override
  State<SeatingChartTeacher> createState() => _SeatingChartTeacherState();
}

class _SeatingChartTeacherState extends State<SeatingChartTeacher> {
  final SeatingChartController controller = Get.put(SeatingChartController());
  final StudyAttitudeController studyAttitudeController =
      Get.put(StudyAttitudeController());
  int? selectedGrade;
  int? selectedClass;
  List<int> grades = [1, 2, 3];
  List<int> classes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  bool isSelected = false;
  int attitudeId =0;

  @override
  void dispose() {
    super.dispose();
    if(studyAttitudeController.newStudyAttitudeData.isNotEmpty) {
      studyAttitudeController.insertStudyAttitudeData(studyAttitudeController.newStudyAttitudeData);
      studyAttitudeController.newStudyAttitudeData.clear();
      attitudeId =0;
    }
    controller.dispose();
    studyAttitudeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.updateScreenSize(MediaQuery.of(context).size);
    });
    return Scaffold(
      appBar: AppBar(
        title: isSelected
            ? Text(
                '$selectedGrade학년 $selectedClass반 학급 좌석표',
                style: const TextStyle(fontSize: 20),
              )
            : const Text(
                '학급 좌석표',
                style: TextStyle(fontSize: 20),
              ),
        centerTitle: true,
      ),
      body: !isSelected
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    spacing: 8,
                    children: grades.map((grade) {
                      return ChoiceChip(
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
                        label: Text('$grade학년'),
                        selected: selectedGrade == grade,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedGrade = selected ? grade : null;
                            if (selectedGrade != null &&
                                selectedClass != null) {
                              isSelected = true;
                            } else {
                              isSelected = false;
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 5,
                    children: classes.map((classNum) {
                      return ChoiceChip(
                        color: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          // Your logic to determine the color based on the states
                          if (states.contains(WidgetState.selected)) {
                            return Colors.green; // Example: Blue when pressed
                          } else {
                            return Colors.white; // Example: Default color
                          }
                        }),
                        showCheckmark: false,
                        label: Text('$classNum반'),
                        selected: selectedClass == classNum,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedClass = selected ? classNum : null;
                            if (selectedGrade != null &&
                                selectedClass != null) {
                              isSelected = true;
                            } else {
                              isSelected = false;
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          : GestureDetector(
              onLongPress: () {
                setState(() {
                  if(studyAttitudeController.newStudyAttitudeData.isNotEmpty) {
                    studyAttitudeController.insertStudyAttitudeData(studyAttitudeController.newStudyAttitudeData);
                    studyAttitudeController.newStudyAttitudeData.clear();
                    attitudeId =0;
                  }
                  isSelected = false;
                  selectedGrade = null;
                  selectedClass = null;
                });
              },
              child: Obx(() {
                if (controller.screenSize.value.isEmpty ||
                    controller.isLoadingSeatingChartData.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (controller.seatingChartData.isEmpty) {
                  return const Center(
                    child: Text('학생들의 좌석 정보가 없습니다.'),
                  );
                } else {
                  final dataList = controller.seatingChartData
                      .where((e) =>
                          e.grade == selectedGrade &&
                          e.classNum == selectedClass)
                      .toList();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('좌석표를 길게 누르면 선택화면으로 돌아갑니다.'),
                      SizedBox(
                        height: controller.chartHeight / 3 + 20,
                        child: Stack(
                          children: [
                            Positioned(
                              left: controller.chartX,
                              top: controller.chartY - kToolbarHeight,
                              child: Container(
                                width: controller.chartWidth,
                                height: controller.chartHeight / 3,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    // 교탁
                                    Positioned(
                                      left: controller.chartWidth / 2 -
                                          controller.gridWidth * 2.5,
                                      top: controller.chartHeight / 3 -
                                          controller.gridHeight * 4,
                                      child: Container(
                                        width: controller.gridWidth * 4,
                                        height: controller.gridWidth * 3,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '교탁',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // 학생 책상
                                    ...dataList.map((data) {
                                      return Positioned(
                                        left: data.x.value - 20,
                                        top: data.y.value,
                                        child: GestureDetector(
                                            onTap: () {
                                              _showDialog(context, data);
                                            },
                                            child: seatingChartWidget(data)),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Text('학습 태도 평가 내용', style: TextStyle(fontSize: 16),),
                      ),
                      const SizedBox(height: 10,),
                      studyAttitudeController.newStudyAttitudeData.isNotEmpty ?
                      SingleChildScrollView(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: studyAttitudeController
                                .newStudyAttitudeData.length,
                            itemBuilder: (context, index) {
                              final data = studyAttitudeController
                                  .newStudyAttitudeData[index];
                              return Dismissible(
                                key : Key(data.id.toString()),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction){
                                  if (index >= 0 && index < studyAttitudeController.newStudyAttitudeData.length) {
                                    studyAttitudeController.newStudyAttitudeData.removeAt(index);
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(data.studentName.toString(), style: const TextStyle(fontSize: 16)),
                                      data.attitude! > 20 ?
                                      Text(studyAttitudeController.attitudeGoodCode.firstWhere((e) => e.code == data.attitude).explain!, style: const TextStyle(fontSize: 16))
                                      : Text(studyAttitudeController.attitudeBadCode.firstWhere((e) => e.code == data.attitude).explain!, style: const TextStyle(fontSize: 16)),
                                      Text(DateFormat('M월 d일 H:mm','ko_KR').format(data.time!)),
                                    ]
                                  ),
                                ),
                              );
                            }),
                      ) : const Center(child: Text('자료가 없습니다.')),
                    ],
                  );
                }
              }),
            ),
    );
  }

  Widget seatingChartWidget(SeatingChartData data) {
    return Container(
      width: controller.gridWidth * 4,
      height: controller.gridWidth * 3,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          data.name.length > 3
              ? Text(
                  data.name,
                  style: const TextStyle(fontSize: 11),
                )
              : Text(
                  data.name,
                  style: const TextStyle(fontSize: 14),
                ),
          Text(data.number.toString(), style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Future<void> _showDialog(BuildContext context, SeatingChartData data) async {
    const double dialogWidthPercentage = 0.8; // 다이얼로그가 화면 너비의 80%를 차지하도록 설정
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dialogEstimatedWidth = screenWidth * dialogWidthPercentage;

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // 사용자가 대화 상자 외부를 탭하여 닫을 수 있는지 여부
      builder: (BuildContext context) {

        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * (1 - dialogWidthPercentage) / 2, vertical: 24.0),
          title: Center(child: Text('${data.name} 학생 평가')),
          content: const Text('평가 내용을 선택하세요.', style: TextStyle(fontSize: 16)),
          actionsPadding: EdgeInsets.zero,
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
             SingleChildScrollView(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    Column(
                      children: [
                         for(var item in studyAttitudeController.attitudeGoodCode)
                        Material(
                             color: Colors.transparent,
                             child: InkWell(
                                 onTap: (){
                                   StudyAttitudeData student = StudyAttitudeData();
                                   student.id = attitudeId;
                                   student.grade = Constants.currentUser.grade;
                                   student.classNum = Constants.currentUser.classNum;
                                   student.number = Constants.currentUser.number;
                                   student.name = Constants.currentUser.name;
                                   student.studentGrade = data.grade;
                                   student.studentClass = data.classNum;
                                   student.studentNumber = data.number;
                                   student.studentName = data.name;
                                   student.attitude = item.code;
                                   student.time = DateTime.now();
                                  studyAttitudeController.newStudyAttitudeData.add(student);
                                  attitudeId++;
                                   Navigator.of(context).pop();
                                 },
                                 child: Container(
                                   alignment: Alignment.center,
                                   width: dialogEstimatedWidth * 0.4,
                                   margin: const EdgeInsets.only(left: 10, bottom: 5),
                                   padding: const EdgeInsets.all(10),
                                   decoration: BoxDecoration(
                                     color: Colors.green[200],
                                     border: Border.all(
                                       color: Colors.green[200]!,
                                       width: 1.0,
                                     ),
                                     borderRadius: BorderRadius.circular(5.0),
                                   ),
                                   child: Text(item.explain!, style: const TextStyle(fontSize: 16),
                                   ),
                                 ),
                             ),
                           ),
                        const SizedBox(height: 30)
                      ],
                    ),
                   const SizedBox(width: 2,),
                    Column(
                      children: [
                        for (var item in studyAttitudeController.attitudeBadCode)
                        Material(
                                 color: Colors.transparent,
                                 child: InkWell(
                                   onTap: () {
                                     StudyAttitudeData student = StudyAttitudeData();
                                     student.id = attitudeId;
                                     student.grade = Constants.currentUser.grade;
                                     student.classNum =
                                         Constants.currentUser.classNum;
                                     student.number = Constants.currentUser.number;
                                     student.name = Constants.currentUser.name;
                                     student.studentGrade = data.grade;
                                     student.studentClass = data.classNum;
                                     student.studentNumber = data.number;
                                     student.studentName = data.name;
                                     student.attitude = item.code;
                                     student.time = DateTime.now();
                                     studyAttitudeController.newStudyAttitudeData
                                         .add(student);
                                     attitudeId++;
                                     Navigator.of(context).pop();
                                   },
                                   child: Container(
                                     alignment: Alignment.center,
                                     width: dialogEstimatedWidth * 0.4,
                                     margin: const EdgeInsets.only(
                                         right: 10, bottom: 5),
                                     padding: const EdgeInsets.all(10),
                                     decoration: BoxDecoration(
                                       color: Colors.orange[200],
                                       border: Border.all(
                                         color: Colors.orange[200]!,
                                         width: 1.0,
                                       ),
                                       borderRadius: BorderRadius.circular(5.0),
                                     ),
                                     child: Text(item.explain!,
                                       style: const TextStyle(fontSize: 16),),
                                   ),),
                               ),
                        const SizedBox(height: 30)
                      ],
                    ),
                 ],
               ),
             ),
          ],
        );
      },
    );
  }
}
