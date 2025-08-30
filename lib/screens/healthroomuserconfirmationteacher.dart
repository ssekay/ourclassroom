import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/helthcontroller.dart';

class HealthRoomUserConfirmationTeacher extends StatefulWidget {
  const HealthRoomUserConfirmationTeacher({super.key});

  @override
  State<HealthRoomUserConfirmationTeacher> createState() =>
      _HealthRoomUserConfirmationTeacherState();
}

class _HealthRoomUserConfirmationTeacherState
    extends State<HealthRoomUserConfirmationTeacher> {
  HealthController controller = Get.put(HealthController());
  int? selectedGrade;
  int? selectedClass;
  List<int> grades = [1, 2, 3];
  List<int> classes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('보건실 이용 확인'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                controller.fetchHealthData();
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
                  isSelected = false;
                  selectedGrade = null;
                  selectedClass = null;
                });
              },
              child: Column(
                children: [
                  const Text('길게 누르면 선택화면으로 돌아갑니다.'),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        final dataList = controller.healthData
                            .where((e) =>
                                e.grade == selectedGrade &&
                                e.classNum == selectedClass &&
                                DateTime.now()
                                        .difference(e.app_time!)
                                        .inMinutes
                                        .abs() <=
                                    60)
                            .toList();
                        if (dataList.isEmpty) {
                          return const Center(
                            child: Text('자료가 없습니다.'),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.builder(
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                final  data = dataList[index];
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[200],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10,),
                                    Text('${data.number}번 ${data.name}'),
                                    const SizedBox(width: 30,),
                                    Text('시간 : ${DateFormat('HH시 mm분', 'ko_KR').format(data.app_time!)}'),
                                  ],
                                ),
                                );
                              }),
                          );
                        }
                      }
                    }),
                  ),
                ],
              ),
            ),
    );
  }
}
