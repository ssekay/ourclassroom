import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/snackbar_service.dart';
import '../controllers/praisecontroller.dart';
import '../utils/constants.dart';
import 'praise_new.dart';

class PraiseGiveStudent extends StatefulWidget {
  const PraiseGiveStudent({super.key});

  @override
  State<PraiseGiveStudent> createState() => _PraiseGiveStudentState();
}

class _PraiseGiveStudentState extends State<PraiseGiveStudent> {
  PraiseController praiseController = Get.put(PraiseController());
  SnackBarService snackBarService = SnackBarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('칭찬한 기록'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                praiseController.fetchPraiseData();
              });
            },
            icon: const Icon(Icons.refresh_rounded),
            iconSize: 30,
          ),
          const SizedBox(
            width: 10,
          )
        ],
        iconTheme: IconThemeData(color: Colors.green[200]),
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
              .where((e) => e.name == Constants.currentUser.name && e.number == Constants.currentUser.number)
              .toList();
          if(dataList.isEmpty) {
            return const Center(
                child: Text('자료가 없습니다.'));
          } else {
            return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final data = dataList[index];
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("삭제 확인"),
                              content: Text('${data.toname} 자료를 삭제하시겠습니까?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("취소"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text("삭제"),
                                  onPressed: () {
                                    if (data.time!.day == DateTime
                                        .now()
                                        .day &&
                                        data.time!.month ==
                                            DateTime
                                                .now()
                                                .month &&
                                        data.time!.year == DateTime
                                            .now()
                                            .year) {
                                      setState(() {
                                        praiseController
                                            .deletePraiseData(data.id!);
                                      });
                                    } else {
                                      snackBarService.showCustomSnackBar('오늘 자료만 삭제할 수 있습니다.', Colors.blue);
                                    }
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: !index.isEven
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
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    2 /
                                    3,
                                decoration: BoxDecoration(
                                  color: Colors.green[200],
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
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    2 /
                                    3,
                                decoration: BoxDecoration(
                                  color: Colors.green[200],
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
