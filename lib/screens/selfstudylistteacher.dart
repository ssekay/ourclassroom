import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/selfstudycontroller.dart';

class SelfStudyListTeacher extends StatefulWidget {
  const SelfStudyListTeacher({super.key});

  @override
  State<SelfStudyListTeacher> createState() => _SelfStudyListTeacherState();
}

class _SelfStudyListTeacherState extends State<SelfStudyListTeacher> {
  SelfStudyController selfStudyController = Get.put(SelfStudyController());
  int month = 0;
  int day = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    month = DateTime.now().month;
    day = DateTime.now().day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('날짜별 자습기록'),
          centerTitle: true,
      ),
      body: Obx(() {
        if (selfStudyController.isLoadingSelfStudyData.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (selfStudyController.selfStudyData.isEmpty) {
          return Center(
            child: Text(selfStudyController.fetchMessage.value),
          );
        } else {
          final dataList = selfStudyController.selfStudyData.where((e) => e.time!.month == month && e.time!.day == day).toList();
          dataList.sort((a, b) => a.number!.compareTo(b.number!));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        if (DateTime(2025,month,day).isAfter(DateTime(2025,3,4))) {
                          setState(() {
                            month = DateTime(2025, month, day - 1).month;
                            day = DateTime(2025, month, day - 1).day;
                          });
                        }
                      },
                      child: const Icon(Icons.arrow_back_ios)),
                  Text(
                    DateFormat('M월 d일(E)', 'ko_KR')
                        .format(DateTime(2025, month, day)),
                    style: const TextStyle(fontSize: 16),
                  ),
                  TextButton(
                      onPressed: () {
                        if (DateTime(2025,month,day).isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                          setState(() {
                            month = DateTime(2025, month, day + 1).month;
                            day = DateTime(2025, month, day + 1).day;
                          });
                        }
                      },
                      child: const Icon(Icons.arrow_forward_ios)),
                ],
              ),
              dataList.isEmpty ? const Center(child: Text('자습기록이 없습니다.'),) :
              Expanded(
                child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final data = dataList[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10,top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(data.name!, style: const TextStyle(fontSize: 16),),
                                  Text('${data.number!.toString()}번', style: const TextStyle(fontSize: 14),),
                                ],
                              ),
                              const SizedBox(width: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('8교시 : ${selfStudyController.selfStudyCodeToString[data.term1]}',style: const TextStyle(fontSize: 14),),
                                  Text('야자 1차시 : ${selfStudyController.selfStudyCodeToString[data.term2]}',style: const TextStyle(fontSize: 14),),
                                  Text('야자 2차시 : ${selfStudyController.selfStudyCodeToString[data.term3]}',style: const TextStyle(fontSize: 14),),
                                ],
                              ),
                            ],
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
