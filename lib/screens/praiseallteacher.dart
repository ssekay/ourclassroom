import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/praisecontroller.dart';

class PraiseAllTeacher extends StatefulWidget {
  const PraiseAllTeacher({super.key});

  @override
  State<PraiseAllTeacher> createState() => _PraiseAllTeacherState();
}

class _PraiseAllTeacherState extends State<PraiseAllTeacher> {
  PraiseController praiseController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('모든 칭찬 기록'),
        centerTitle: true,
        leadingWidth: 100,
        leading: Row(
          children: [
            const SizedBox(width: 10,),
            const Icon(Icons.favorite, color: Colors.red,),
            const SizedBox(width: 5,),
            Text( praiseController.praiseCount.toString(),)
          ],
        ),
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
        iconTheme: IconThemeData(color: Colors.blue[200]),
      ),
      body: Obx(() {
        if (praiseController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (praiseController.praiseData.isEmpty) {
          return  Center(
            child: Text(praiseController.fetchMessage.value),
          );
        } else {
          return ListView.builder(
              itemCount: praiseController.praiseData.length,
              itemBuilder: (context, index) {
                final data = praiseController.praiseData[index];
                return index.isEven ? Padding(
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
                            width: MediaQuery.of(context).size.width * 2 / 3,
                              decoration: BoxDecoration(
                                color: Colors.blue[200],
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.zero,
                                  bottomRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              child:  Text(
                                  '${data.toname}, ${data.content}',
                                ),
                              ),
                          const SizedBox(width: 5,),
                          Text(DateFormat('M월 d일').format(data.time!)),
                        ],
                      )
                    ],
                  ),
                ) :
                Padding(
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
                          const SizedBox(width: 5,),
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 2 / 3,
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.zero,
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                            ),
                            child:  Text(
                              '${data.toname}, ${data.content}',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              });
        }
      }),
    );
  }
}
