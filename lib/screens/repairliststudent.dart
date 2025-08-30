import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourclassroom/controllers/repaircontroller.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/screens/repairwritestudent.dart';
import '../utils/constants.dart';

class RepairListStudent extends StatefulWidget {
  const RepairListStudent({super.key});

  @override
  State<RepairListStudent> createState() => _RepairListStudentState();
}

class _RepairListStudentState extends State<RepairListStudent> {
  RepairController repairController = Get.put(RepairController());
  final Map<String, Color?> repairColor = {
    'preapply': Colors.blue[100],
    'apply': Colors.blue[300],
    'progress': Colors.green[200],
    'complete': Colors.orange[200],
    'return' : Colors.grey,
  };
  final Map<String, String> repairStatus = {
    'preapply' : '예비',
    'apply': '신청',
    'progress': '진행',
    'complete': '완료',
    'return' : '반려'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('수리 목록'),
        centerTitle: true,
        actions: [
          const SizedBox(width: 10,),
          Container(
            width: 35,
            padding:
            const EdgeInsets.only(left: 6, right: 5, bottom: 4, top: 3),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: const Text('예비', style: TextStyle(fontSize: 12),),
          ),
          const SizedBox(width: 5,),
          Container(
            width: 35,
            padding:
            const EdgeInsets.only(left: 6, right: 5, bottom: 4, top: 3),
            decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: const Text('신청', style: TextStyle(fontSize: 12),),
          ),
          const SizedBox(width: 5,),
          Container(
            width: 35,
            padding:
            const EdgeInsets.only(left: 6, right: 5, bottom: 4, top: 3),
            decoration: BoxDecoration(
              color: Colors.green[200],
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: const Text('진행',style: TextStyle(fontSize: 12),),
          ),
          const SizedBox(width: 5,),
          Container(
            width: 35,
            padding:
            const EdgeInsets.only(left: 6, right: 5, bottom: 4, top: 3),
            decoration: BoxDecoration(
              color: Colors.orange[200],
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: const Text('완료',style: TextStyle(fontSize: 12),),
          ),
          const SizedBox(width: 5,),
          Container(
            width: 35,
            padding:
            const EdgeInsets.only(left: 6, right: 5, bottom: 4, top: 3),
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius:  BorderRadius.all(Radius.circular(15)),
            ),
            child: const Text('반려',style: TextStyle(fontSize: 12),),
          ),
          const SizedBox(width: 10,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() {
              if (repairController.isLoadingRepairData.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (repairController.repairData.isEmpty) {
                return Center(child: Text(repairController.fetchMessage.value));
              } else {
                final repairDataList = repairController.repairData
                    .where((e) =>
                        e.grade == Constants.currentUser.grade &&
                        e.classNum == Constants.currentUser.classNum &&
                        e.etc == Constants.currentUser.name)
                    .toList();
                if (repairDataList.isEmpty) {
                  return const Center(child: Text('신청내역이 없습니다.'));
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: repairDataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = repairDataList[index];
                          return Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              color: repairColor[data.status!],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '신청일',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(DateFormat('M월 d일(E)', 'ko_KR')
                                        .format(data.appTime!)),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '대 상 : ${data.item}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '내 용 : ${data.itemState}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    if(data.status == 'return') Text('이유 : ${data.statusExplain}', style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  );
                }
              }
            })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: Colors.green[100],
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              builder: (_) {
                return const Padding(
                  padding: EdgeInsets.only(top : 60),
                  child: RepairWriteStudent(),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
