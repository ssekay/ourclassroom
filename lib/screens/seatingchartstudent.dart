import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/seatingchartcontroller.dart';
import '../models/models.dart';
import '../utils/constants.dart';

class SeatingChartStudent extends StatefulWidget {
  const SeatingChartStudent({super.key});

  @override
  State<SeatingChartStudent> createState() => _SeatingChartStudentState();
}

class _SeatingChartStudentState extends State<SeatingChartStudent> {
  final SeatingChartController controller = Get.put(SeatingChartController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.updateScreenSize(MediaQuery.of(context).size);
    });
    return Scaffold(
      appBar: AppBar(
        title:  Text(
                '${Constants.currentUser.grade}학년 ${Constants.currentUser.classNum}반 학급 좌석표',
                style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.screenSize.value.isEmpty ||
            controller.isLoadingSeatingChartData.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.seatingChartData.isEmpty) {
          return const Center(
            child: Text('좌석 정보가 없습니다.'),
          );
        } else {
          final dataList = controller.seatingChartData
              .where((e) =>
                  e.grade == Constants.currentUser.grade &&
                  e.classNum == Constants.currentUser.classNum)
              .toList();
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                                child: seatingChartWidget(data),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
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
}
