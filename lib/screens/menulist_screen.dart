
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/screens/advertisementstudent.dart';
import 'package:ourclassroom/screens/classtimetablestudent.dart';
import 'package:ourclassroom/screens/downloaddatateacher.dart';
import 'package:ourclassroom/screens/healthroomuserconfirmationteacher.dart';
import 'package:ourclassroom/screens/lostitemlist.dart';
import 'package:ourclassroom/screens/mealtable.dart';
import 'package:ourclassroom/screens/offcampuspasslistteacher.dart';
import 'package:ourclassroom/screens/repairliststudent.dart';
import 'package:ourclassroom/screens/repairlistteacher.dart';
import 'package:ourclassroom/screens/seatingchartteacher.dart';
import 'package:ourclassroom/screens/studyattitudclasslistteacher.dart';
import 'package:ourclassroom/screens/timetableteacher.dart';

import '../utils/constants.dart';
import 'classtimetableteacher.dart';
import 'infouserandapp.dart';
import 'news.dart';
import 'offcampuspassliststudent.dart';
import 'seatingchartstudent.dart';

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메 뉴'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
        // 교사용 메뉴
        child: Constants.currentUser.isHomeroomTeacher
            ? Column(
          children: [
            // 광고
            GestureDetector(
              onTap: () {
                Get.to(() =>const AdvertisementStudent());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: const Icon(Icons.campaign, size: 25, color: Colors.amber,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('광고',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('다양한, 재미 있는',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 뉴스
            GestureDetector(
              onTap: () {
                Get.to(() => News());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: const Icon(Icons.article_outlined, size: 25, color: Colors.blue,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('오늘의 뉴스',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('청소년 뉴스',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 오늘의 급식
            GestureDetector(
              onTap: () {
                Get.to(() => const MealTable());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: Icon(Icons.dinner_dining_outlined, size: 20, color: Colors.blueAccent[200]!,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('오늘의 급식',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('맛있게',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 외출증 발급
            GestureDetector(
              onTap: () {
                Get.to(() => const OffCampusPassListTeacher());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: Icon(Icons.outbond_outlined, size: 20, color: Colors.deepPurpleAccent[200]!,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('외출증 발급',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('외출증 목록과 발급',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 학급 시간표
            GestureDetector(
              onTap: () {
                Get.to(() => const ClassTimetableTeacher());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: Icon(Icons.view_list_outlined, size: 20, color: Colors.blueAccent[200]!,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('학급 시간표',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('2학기',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 교사 시간표
            GestureDetector(
              onTap: () {
                Get.to(() => const TimetableTeacher());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: Icon(Icons.view_list_outlined, size: 20, color: Colors.blueAccent[200]!,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('교사 시간표',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('2학기',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 보건실 방문 확인
            GestureDetector(
              onTap: () {
                Get.to(() =>const HealthRoomUserConfirmationTeacher());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: Icon(Icons.medical_services_outlined, size: 20, color: Colors.red[200]!,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('보건실 이용 확인',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('1시간 이내, 반별 확인',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 학급좌석표
            GestureDetector(
              onTap: () {
                Get.to(() =>const SeatingChartTeacher());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: Icon(Icons.chair_outlined, size: 20, color: Colors.green[300]!,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('학급좌석표',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('실시간',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 학습태도 확인
            GestureDetector(
              onTap: () {
                Get.to(() =>const StudyAttitudeClassListTeacher());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: Icon(Icons.menu_book_outlined, size: 20, color: Colors.green[300]!,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('학습태도 확인',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('학급별 학생 학습태도 확인',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 수리신청
            GestureDetector(
              onTap: () {
                Get.to(() =>const RepairListTeacher());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: const Icon(Icons.home_repair_service, size: 20, color: Colors.lightBlue,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('수리신청',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('빠르게, 완벽하게',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            //분실물 정보
            GestureDetector(
              onTap: () {
                Get.to(() =>const LostItemList());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: const Icon(Icons.visibility_off, size: 25, color: Colors.deepPurple,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('분실물',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('학생부에서 분실물 찾기',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 담임용 자료 다운로드
            GestureDetector(
              onTap: () {
                Get.to(() =>const DownloadDataTeacher());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: const Icon(Icons.file_download, size: 25, color: Colors.black,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('다운로드',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('담임선생님 학급 자료',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            //사용자 및 앱 정보
            GestureDetector(
              onTap: () {
                Get.to(() =>const InfoUserAndApp());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: const Icon(Icons.info, size: 25, color: Colors.deepOrange,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('사용자 및 앱',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('사용자, 앱 정보',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
          ]
        ) :
            // 학생용 메뉴
        Column(
          children: [
            // 광고
            GestureDetector(
              onTap: () {
                Get.to(() =>const AdvertisementStudent());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: const Icon(Icons.campaign, size: 25, color: Colors.amber,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('광고',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('다양한, 재미 있는',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 오늘의 급식
            GestureDetector(
              onTap: () {
                Get.to(() => const MealTable());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: Icon(Icons.dinner_dining_outlined, size: 20, color: Colors.blueAccent[200]!,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('오늘의 급식',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('맛있게',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 외출증 확인
            GestureDetector(
              onTap: () {
                Get.to(() => const OffCampusPassListStudent());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: Icon(Icons.outbond_outlined, size: 20, color: Colors.deepPurpleAccent[200]!,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('외출증',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('외출증 보기',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 학급 시간표
            GestureDetector(
              onTap: () {
                Get.to(() => const ClassTimetableStudent());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: Icon(Icons.view_list_outlined, size: 20, color: Colors.blueAccent[200]!,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('학급 시간표',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('2학기',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 학급좌석표
            GestureDetector(
              onTap: () {
                Get.to(() =>const SeatingChartStudent());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: Icon(Icons.chair_outlined, size: 20, color: Colors.green[300]!,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('햑급좌석표',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('실시간',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 수리신청
            GestureDetector(
              onTap: () {
                Get.to(() =>const RepairListStudent());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: const Icon(Icons.home_repair_service, size: 20, color: Colors.lightBlue,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('수리신청',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('빠르게, 완벽하게',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 분실물 목록
            GestureDetector(
              onTap: () {
                Get.to(() =>const LostItemList());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: const Icon(Icons.visibility_off, size: 25, color: Colors.deepPurple,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('분실물',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('학생부에서 분실물 찾기',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            // 사용자 및 앱 정보
            GestureDetector(
              onTap: () {
                Get.to(() =>const InfoUserAndApp());
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                              width: 35,
                              height: 35,
                              color: Colors.grey[200],
                              child: const Icon(Icons.info, size: 25, color: Colors.deepOrange,))
                      ),
                      const SizedBox(width: 20,),
                      const Text('사용자 및 앱',style: TextStyle(fontSize: 18),),
                    ],
                  ),
                  const Text('사용자, 앱 정보',style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
