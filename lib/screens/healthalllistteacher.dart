import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/helthcontroller.dart';
import '../utils/constants.dart';

class HealthAllListTeacher extends StatefulWidget {
  const HealthAllListTeacher({super.key});

  @override
  State<HealthAllListTeacher> createState() => _HealthAllListTeacherState();
}

class _HealthAllListTeacherState extends State<HealthAllListTeacher> {
  HealthController healthController = Get.put(HealthController());

  @override
  Widget build(BuildContext context) {
    // String medication = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('모든 학생 보건기록 보기'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                healthController.fetchHealthData();
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
        if (healthController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (healthController.healthData.isEmpty) {
          return Center(
            child: Text(healthController.fetchMessage.value),
          );
        } else {
          final dataList = healthController.healthData.where((e) => e.grade == Constants.currentUser.grade && e.classNum == Constants.currentUser.classNum).toList();
          if(dataList.isEmpty) {
            return const Center(
              child: Text('자료가 없습니다.'),
            );
          } else {
            return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final data = dataList[index];
                  // 보건증 발급앱 활성화 이후 사용
                  // if (data.therapy == '투약') {
                  //   medication = data.medication1.toString();
                  //   if (data.medication2 != '') {
                  //     medication = '$medication, ${data.medication2}';
                  //   }
                  //   if (data.medication3 != '') {
                  //     medication = '$medication, ${data.medication3}';
                  //   }
                  // }
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: const BorderRadius.all(Radius.circular(
                            15)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                DateFormat('M월 d일(E)', 'ko_KR').format(data.app_time!),
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(DateFormat('HH시', 'ko_KR')
                                  .format(data.app_time!),style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.name}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '증상 : ${data.symptoms}',
                                style: const TextStyle(fontSize: 16),
                              ),

                              // 보건증 발급앱 활성화 이후 사용
                              // data.iss_time != null ?
                              // const Text('보건증 발급', style: TextStyle(fontSize: 16),)
                              //     : const Text('보건증 신청', style: TextStyle(fontSize: 16),),
                              // data.iss_time != null ?
                              // Text(
                              //   '처치 : ${data.therapy}',
                              //   style: const TextStyle(fontSize: 16),
                              // ) : const SizedBox.shrink(),
                              // data.therapy == '투약' ?
                              //   Text(
                              //     medication,
                              //     style: const TextStyle(fontSize: 16),
                              //   ) : const SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }}
      }),
    );
  }
}
