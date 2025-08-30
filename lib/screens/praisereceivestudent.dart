import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/praisecontroller.dart';
import '../utils/constants.dart';
import 'praise_new.dart';

class PraiseReceiveStudent extends StatefulWidget {
  const PraiseReceiveStudent({super.key});

  @override
  State<PraiseReceiveStudent> createState() => _PraiseReceiveStudentState();
}

class _PraiseReceiveStudentState extends State<PraiseReceiveStudent> {
  PraiseController praiseController = Get.put(PraiseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('칭찬 받은 기록'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                praiseController.fetchPraiseData();
              });
            },
            icon: const Icon(Icons.refresh_rounded), iconSize: 30,),
          const SizedBox(width: 10,)
        ],
        iconTheme: IconThemeData(color: Colors.orange[200]),
      ),
      body: Obx(() {
        if (praiseController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (praiseController.praiseData.isEmpty) {
          return Center(
            child: Text(praiseController.fetchMessage.value),
          );
        } else {
          var dataList = praiseController.praiseData
              .where((e) => e.toname == Constants.currentUser.name)
              .toList();
          if(dataList.isEmpty) {
            return const Center(
              child: Text('자료가 없습니다.'),
            );
          } else {
            return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final data = dataList[index];
                  return index.isEven
                      ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Text(data.name!),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              width:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * 2 / 3,
                              decoration: BoxDecoration(
                                color: Colors.orange[200],
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.zero,
                                  bottomRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              child: Text(
                                '${data.toname}, ${data.content}',
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(DateFormat('M월 d일').format(data.time!)),
                          ],
                        )
                      ],
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          child: Text(data.name!),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(DateFormat('M월 d일').format(data.time!)),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              width:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * 2 / 3,
                              decoration: BoxDecoration(
                                color: Colors.orange[200],
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.zero,
                                  topLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              child: Text(
                                '${data.toname}, ${data.content}',
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                });
          }}
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: Colors.green[100],

              context: context,
              isScrollControlled: true,
              isDismissible: true,
              builder: (_) => const NewPraise());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
