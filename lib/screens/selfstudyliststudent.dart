import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/selfstudycontroller.dart';
import '../utils/constants.dart';

class SelfStudyListStudent extends StatefulWidget {
  const SelfStudyListStudent({super.key});

  @override
  State<SelfStudyListStudent> createState() => _SelfStudyListStudentState();
}

class _SelfStudyListStudentState extends State<SelfStudyListStudent> {
  SelfStudyController selfStudyController = Get.put(SelfStudyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('자습기록'),
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
          final dataList = selfStudyController.selfStudyData.where((e) => e.number == Constants.currentUser.number).toList();
          if(dataList.isEmpty){
            return const Center(child: Text('자료가 없습니다.'),);
          }
          return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final data = dataList[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
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
                            Text(DateFormat('M월 d일').format(data.time!), style: const TextStyle(fontSize: 16),),
                            Text(DateFormat('(E)','ko_KR').format(data.time!)),
                          ],
                        ),
                        const SizedBox(width: 15,),
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
              });
        }
      }),
    );
  }
}
