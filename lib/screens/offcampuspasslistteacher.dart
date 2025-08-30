
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/offcampuspasscontroller.dart';
import '../services/snackbar_service.dart';
import '../utils/constants.dart';
import 'offcampuspasswriteteacher.dart';

class OffCampusPassListTeacher extends StatefulWidget {
  const OffCampusPassListTeacher({super.key});

  @override
  State<OffCampusPassListTeacher> createState() => _OffCampusPassListTeacherState();
}

// 1. TickerProviderStateMixin 추가
class _OffCampusPassListTeacherState extends State<OffCampusPassListTeacher> with TickerProviderStateMixin {
  final OffCampusPassController offCampusPassController = Get.put(OffCampusPassController());
  final SnackBarService snackBarService = SnackBarService();

  // 2. AnimationController 선언
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    // 3. AnimationController 초기화 및 애니메이션 시작
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20), // 회전 속도 (10초에 한 바퀴)
      vsync: this,
    )..repeat(); // 애니메이션 반복
  }

  @override
  void dispose() {
    // 4. AnimationController 해제
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('외출증 목록'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  offCampusPassController.fetchOffCampusPassData();
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              iconSize: 30,
              color: Colors.blue[200],
            ),
            const SizedBox(width: 30,)
          ]
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
        child: Obx((){
          if (offCampusPassController.isLoadingOffCampusPassData.value) {
            return const Center(child: CircularProgressIndicator());
          } else if( offCampusPassController.offCampusPassData.isEmpty){
            return const Center(child: Text('자료가 없습니다.'));
          } else {
            final dataList = offCampusPassController.offCampusPassData.where((e) => e.issuerGrade == Constants.currentUser.grade
            && e.issuerClass == Constants.currentUser.classNum && e.issuerNumber == Constants.currentUser.number
            && e.issuerName == Constants.currentUser.name).toList();
            if(dataList.isEmpty) {
              return const Center(child: Text('자료가 없습니다.'));
            }
            return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final data = dataList[index];
                return data.endTime!.isAfter(DateTime.now()) ?
                Dismissible(
                  key: ValueKey(data.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    try {
                      await offCampusPassController.deleteOffCampusPassData(
                          data.id!);
                      snackBarService.showCustomSnackBar(
                        '외출증이 삭제 되었습니다.',
                        Colors.green[200]!,
                      );
                    } catch(e) {
                      snackBarService.showCustomSnackBar(
                        '오류 : $e',
                        Colors.orange[200]!,
                      );
                    }
                  },
                  background: Container(
                    padding: const EdgeInsets.only(right: 20.0),
                    alignment: Alignment.centerRight,
                    decoration: const BoxDecoration(
                      color:  Colors.deepOrange,
                      borderRadius:
                      BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: GestureDetector( // Card 위젯으로 변경하지 않고 기존 구조 유지
                    onTap: () async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Center(child: Text('외 출 증', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87))),
                            backgroundColor: Colors.blue[100], // 배경 투명
                            elevation: 20,
                            contentPadding: EdgeInsets.zero, // 컨텐츠 패딩 제거
                            content: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.20, // 이미지 투명도
                                    // 5. RotationTransition 사용 및 컨트롤러 연결
                                    child: RotationTransition(
                                      turns: _rotationController,
                                      child: Image.asset(
                                        'assets/images/logo.png', // GIF 이미지 경로
                                        fit: BoxFit.contain, // 이미지 채우기 방식
                                      ),
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0), // 내부 컨텐츠 패딩
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 20,), // 이전 코드에 20이었으나 통일성을 위해 10으로 변경된 부분들이 있어, 이 부분은 확인 필요. 일단 10으로.
                                        Text('${data.grade}학년 ${data.classNum}반 ${data.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                        const SizedBox(height: 20,),
                                        Text('사 유: ${data.reason}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                        const SizedBox(height: 10,),
                                        // 6. 텍스트 수정
                                        const Text('상기 학생의 외출을 허락함.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                        const SizedBox(height: 20,),
                                        Text('외출 시간: ${DateFormat('HH:mm', 'ko_KR').format(data.startTime!)} - ${DateFormat('HH:mm', 'ko_KR').format(data.endTime!)}', style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                        const SizedBox(height: 30,), // 이전 코드에 30이었으나 통일성을 위해 20으로 변경된 부분들이 있어, 이 부분은 확인 필요. 일단 20으로.
                                        Text(DateFormat('y년 M월 d일(E)', 'ko_KR').format(DateTime.now()),style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                        const SizedBox(height: 30,), // 이전 코드에 30이었으나 통일성을 위해 20으로 변경된 부분들이 있어, 이 부분은 확인 필요. 일단 20으로.
                                        Text('교사 ${data.issuerName} 확인', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                        const SizedBox(height: 20,), // 이전 코드에 20이었으나 통일성을 위해 10으로 변경된 부분들이 있어, 이 부분은 확인 필요. 일단 10으로.
                                        const Text('* 외출 후 학교에 들어오면 반드시 담임선생님께 보고해 주세요.', style: TextStyle(fontSize: 14,),),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder( // 다이얼로그 모서리 둥글게
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          );
                        },
                      );
                    },
                    child: Container( // 이 부분은 Card로 변경되지 않은 상태
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color:  Colors.blue[300]!,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(DateFormat('M월 d일(E)', 'ko_KR').format(data.startTime!)),
                              const SizedBox(height: 10,),
                              Text('${DateFormat('HH시 mm분', 'ko_KR').format(data.startTime!)} - ${DateFormat('HH시 mm분', 'ko_KR').format(data.endTime!)}'),
                            ],
                          ),
                          const SizedBox(width: 30,),
                          Column(
                            children: [
                              Text('${data.grade}학년 ${data.classNum}반 ${data.name!}', style: const TextStyle(fontSize: 18),),
                              const SizedBox(height: 10,),
                              Text(data.reason!, style: const TextStyle(fontSize: 15),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ) : Container( // 만료된 항목
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color:  Colors.blue[100],
                    borderRadius:
                    const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(DateFormat('M월 d일(E)', 'ko_KR').format(data.startTime!)),
                          const SizedBox(height: 10,),
                          Text('${DateFormat('HH시 mm분', 'ko_KR').format(data.startTime!)} - ${DateFormat('HH시 mm분', 'ko_KR').format(data.endTime!)}'),
                        ],
                      ),
                      const SizedBox(width: 50,),
                      Column(
                        children: [
                          Text(data.name!, style: const TextStyle(fontSize: 20),),
                          const SizedBox(height: 10,),
                          Text(data.reason!, style: const TextStyle(fontSize: 15),),
                        ],
                      )
                    ],
                  ),
                );
              });
            }
        }),
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
                  child: OffCampusPassWriteTeacher(),
                );});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
