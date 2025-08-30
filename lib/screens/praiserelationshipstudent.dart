import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/praisecontroller.dart';
import '../utils/constants.dart';

class PraiseRelationshipStudent extends StatefulWidget {
  const PraiseRelationshipStudent({super.key});

  @override
  State<PraiseRelationshipStudent> createState() => _PraiseRelationshipStudentState();
}

class _PraiseRelationshipStudentState extends State<PraiseRelationshipStudent> {
  PraiseController praiseController = Get.put(PraiseController());
  List<String> friendPraisedMe = [];
  String friendPraisedMeString = '';
  List<String> friendPraiseI = [];
  String friendPraisedIString = '';
  List<List<dynamic>> praiseCount =
      List.generate(11, (_) => List.generate(3, (_) => 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 칭찬 관계'),
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
        iconTheme: IconThemeData(color: Colors.blue[200]),
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
          praiseRelationShip();
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '내가 칭찬한 친구들',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[200]!, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                        child: Text(
                      friendPraisedIString,
                      style: const TextStyle(fontSize: 15),
                    ))),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  '나를 칭찬한 친구들',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[200]!, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                        child: Text(
                      friendPraisedMeString,
                      style: const TextStyle(fontSize: 15),
                    ))),
                const SizedBox(height: 10,),
                Expanded(
                  child: Center(
                    child: GridView.builder(
                      shrinkWrap: true,
                        padding: const EdgeInsets.only(left: 50,right: 50),
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: praiseCount[0].length,
                          childAspectRatio: 2.5
                        ),
                        itemCount: praiseCount[0].length * praiseCount.length,
                        itemBuilder: (context, index) {
                          final row = index ~/ praiseCount[0].length;
                          final col = index % praiseCount[0].length;
                          final isHeaderRow = row == 0;
                          final isHeaderColumn = col == 0;
                          String cellData = praiseCount[row][col].toString();
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue[200]!, width: 0.7),
                            ),
                            child: Center(
                              child: Text(
                                cellData,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: (isHeaderColumn || isHeaderRow)
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
          );
        }
      }),
    );
  }

  void praiseRelationShip() {
    // 초기화
    friendPraisedMe.clear();
    friendPraisedMeString = '';
    friendPraiseI.clear();
    friendPraisedIString = '';
    praiseCount =
        List.generate(11, (_) => List.generate(3, (_) => 0));
    praiseCount[0][0] = '구분';
    praiseCount[0][1] = '칭찬한 횟수';
    praiseCount[0][2] = '칭찬받은 횟수';

    for (int i = 1; i < 11; i++) {
      praiseCount[i][0] = '${i + 2}월';
    }
    final dataList = praiseController.praiseData;
    for (var data in dataList) {
      // 나를 칭찬한 친구
      if (data.toname == Constants.currentUser.name) {
        friendPraisedMe.add(data.name!);
        if(data.time!.month >=3 ) {
        praiseCount[data.time!.month - 2][2]++;}
      }
      // 내가 칭찬한 친구
      if (data.name == Constants.currentUser.name) {
        friendPraiseI.add(data.toname!);
        if(data.time!.month >=3 ) {
        praiseCount[data.time!.month-2][1]++;}
      }
    }
    friendPraisedMeString = friendPraisedMe.toSet().toList().join(', ');
    friendPraisedIString = friendPraiseI.toSet().toList().join(', ');
  }
}
