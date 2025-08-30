import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ourclassroom/controllers/praisecontroller.dart';

import '../controllers/selfstudycontroller.dart';
import '../models/models.dart';

class SelfStudyTodayStateTeacher extends StatefulWidget {
  const SelfStudyTodayStateTeacher({super.key});

  @override
  State<SelfStudyTodayStateTeacher> createState() => _SelfStudyTodayTeacherState();
}

class _SelfStudyTodayTeacherState extends State<SelfStudyTodayStateTeacher> {
  SelfStudyController selfStudyController = Get.put(SelfStudyController());
  PraiseController praiseController = Get.put(PraiseController());
  // 총원
  int numberOfStudent =0;
  // 귀가
  int numberOfReturnStudent8 =0;
  int numberOfReturnStudent1 =0;
  int numberOfReturnStudent2 =0;
  // 자습인원
  int numberOfSelfStudyStudent8=0;
  int numberOfSelfStudyStudent1=0;
  int numberOfSelfStudyStudent2=0;
  // 이동
  int numberOfMovieStudent8=0;
  int numberOfMovieStudent1=0;
  int numberOfMovieStudent2=0;
  // 교실자습인원
  int numberOfClassStudent8 =0;
  int numberOfClassStudent1 =0;
  int numberOfClassStudent2 =0;

  List<String> movieStudent8 =[];
  List<String> movieStudent1 =[];
  List<String> movieStudent2 =[];

  List<String> classStudent8 =[];
  List<String> classStudent1 =[];
  List<String> classStudent2 =[];


  // 미신청자 명단
  List<String> todayNonApplicant = [];
  TextStyle textStyle = const TextStyle(fontSize: 16);
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
        title: const Text('날짜별 자습 현황'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                selfStudyController.fetchSelfStudyData();
                praiseController.fetchPraiseFriendData();
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
        if (selfStudyController.isLoadingSelfStudyData.value ||
            praiseController.isLoadingPraiseFriend.value) {
          return Center(
            child: Text(selfStudyController.fetchMessage.value),
          );
        } else {
          todayDataCalculate(month, day);
          return SingleChildScrollView(
                child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    if (DateTime(2025,month,day).isAfter(DateTime(2025,3,4))) {
                                      DateTime newDay = DateTime(2025,month,day).subtract(const Duration(days: 1));
                                      setState(() {
                                        month = newDay.month;
                                        day = newDay.day;
                                      });
                                    }
                                  },
                                  child: const Icon(Icons.arrow_back_ios)),
                              Text(
                                DateFormat('M월 d일(E)', 'ko_KR')
                                    .format(DateTime(2025, month, day)),
                                style: textStyle,
                              ),
                              TextButton(
                                  onPressed: () {
                                    if (DateTime(2025,month,day).isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                                      DateTime newDay = DateTime(2025,month,day).add(const Duration(days: 1));
                                      setState(() {
                                        month = newDay.month;
                                        day = newDay.day;
                                      });
                                    }
                                  },
                                  child: const Icon(Icons.arrow_forward_ios)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Text(
                                  '8교시',
                                  style: textStyle,
                                )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '총원 : $numberOfStudent명, 귀가 : $numberOfReturnStudent8명, 자습 : $numberOfSelfStudyStudent8명',
                                  style: textStyle,
                                ),
                                Text(
                                  '이동 : $numberOfMovieStudent8명(${movieStudent8.join(', ')})',
                                  style: textStyle,
                                ),
                                Text(
                                  '교실 : $numberOfClassStudent8명(${classStudent8.join(', ')})',
                                  style: textStyle,
                                ),

                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Text(
                                  '야자 1차시',
                                  style: textStyle,
                                )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '총원 : $numberOfStudent명, 귀가 : $numberOfReturnStudent1명, 자습 : $numberOfSelfStudyStudent1명',
                                  style: textStyle,
                                ),
                                Text(
                                  '이동 : $numberOfMovieStudent1명(${movieStudent1.join(', ')})',
                                  style: textStyle,
                                ),
                                Text(
                                  '교실 : $numberOfClassStudent1명(${classStudent1.join(', ')})',
                                  style: textStyle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Text(
                                      '야자 2차시',
                                      style: textStyle,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                  Text(
                                    '총원 : $numberOfStudent명, 귀가 : $numberOfReturnStudent2명, 자습 : $numberOfSelfStudyStudent2명',
                                    style: textStyle,
                                  ),
                                Text(
                                  '이동 : $numberOfMovieStudent2명(${movieStudent2.join(', ')})',
                                  style: textStyle,
                                ),
                                Text(
                                  '교실 : $numberOfClassStudent2명(${classStudent2.join(', ')})',
                                  style: textStyle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Text(
                                  '미신청자',
                                  style: textStyle,
                                )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  todayNonApplicant.join(','),
                                  style: textStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              );
        }
      }),
    );
  }

  void todayDataCalculate(int month, int day ) {
    // 자료 초기화
    numberOfStudent =0;
    numberOfReturnStudent8 =0;
    numberOfSelfStudyStudent8=0;
    numberOfMovieStudent8=0;
    numberOfClassStudent8 =0;
    numberOfReturnStudent1 =0;
    numberOfSelfStudyStudent1=0;
    numberOfMovieStudent1=0;
    numberOfClassStudent1 =0;
    numberOfReturnStudent2 =0;
    numberOfSelfStudyStudent2=0;
    numberOfMovieStudent2=0;
    numberOfClassStudent2 =0;
    List<SelfStudyData> data = [];
    List<Map<String, dynamic>> nameData = [];
    bool isIn = false;
    movieStudent8 =[];
    movieStudent1 =[];
    movieStudent2 =[];
    classStudent8 =[];
    classStudent1 =[];
    classStudent2 =[];
    todayNonApplicant.clear();

    data = selfStudyController.selfStudyData
        .where((e) =>
            e.time!.month == month && e.time!.day == day)
        .toList();
    data.sort((a, b) => a.number!.compareTo(b.number!));

    for (final item in praiseController.praiseFriendData) {
      nameData.add(item);
    }
    numberOfStudent = nameData.length;
    for (final item in data) {
      if (item.term1 == 0 ){
        numberOfSelfStudyStudent8 ++;
        numberOfClassStudent8 ++;
        classStudent8.add(item.number.toString());
      }
      if (item.term1 == 1){
        numberOfReturnStudent8 ++;
      }
      if (item.term2 == 0 ){
        numberOfSelfStudyStudent1 ++;
        numberOfClassStudent1 ++;
        classStudent1.add(item.number.toString());
      }
      if (item.term3 == 0 ){
        numberOfSelfStudyStudent2 ++;
        numberOfClassStudent2 ++;
        classStudent2.add(item.number.toString());
      }
      if (item.term1! > 1 && item.term1! < 20){
        numberOfSelfStudyStudent8 ++;
        numberOfMovieStudent8 ++;
        movieStudent8.add(item.number.toString());
      }
      if (item.term2! > 1 && item.term2! < 20){
        numberOfSelfStudyStudent1 ++;
        numberOfMovieStudent1 ++;
        movieStudent1.add(item.number.toString());
      }
      if (item.term3! > 1 && item.term3! < 20){
        numberOfSelfStudyStudent2 ++;
        numberOfMovieStudent2 ++;
        movieStudent2.add(item.number.toString());
      }
      if (item.term2! >= 20){
        numberOfReturnStudent1 ++;
      }
      if (item.term3! >= 20){
        numberOfReturnStudent2 ++;
      }
    }
    for (int i = 0; i < nameData.length; i++) {
      for (var item in data) {
        if (nameData[i]['name'] == item.name) {
          isIn = true;
        }
      }
      if (!isIn) {
        todayNonApplicant.add('${nameData[i]['name']}');
      }
      isIn = false;
    }
  }
}
