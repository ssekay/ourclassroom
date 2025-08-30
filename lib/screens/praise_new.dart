import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/controllers/praisecontroller.dart';
import 'package:ourclassroom/models/models.dart';

import '../utils/constants.dart';

class NewPraise extends StatefulWidget {
  const NewPraise({super.key});

  @override
  State<NewPraise> createState() => _NewPraiseState();
}

class _NewPraiseState extends State<NewPraise> {
  // 폼 키
  final _praiseNewFormKey = GlobalKey<FormState>();

  // 칭찬자료
  late PraiseData newPraise = PraiseData();

  // 학급 명단변수
  List<String> praiseFriendName = [];

  // 칭찬한 학생 명단변수
  List<String> praisedFriendName = [];

  // 입력 값 검증
  bool _tryValidation() {
    final isValid = _praiseNewFormKey.currentState!.validate();
    if (isValid) {
      _praiseNewFormKey.currentState!.save();
      return isValid;
    } else {
      return isValid;
    }
  }

  @override
  Widget build(BuildContext context) {
    PraiseController praiseController = Get.put(PraiseController());
    final bottomInsert = MediaQuery.of(context).viewInsets.bottom;
    return Obx(() {
      if (praiseController.praiseFriendData.isEmpty) {
        return const Center(
          child: Text('칭찬할 친구가 없습니다.'),
        );
      } else {
        // 칭찬 데이터 설정
        newPraise.grade = Constants.currentUser.grade;
        newPraise.name = Constants.currentUser.name;
        newPraise.classNum = Constants.currentUser.classNum;
        newPraise.number = Constants.currentUser.number;

        // 칭찬한 친구 명단 추출
        var praiseList = praiseController.praiseData
            .where((e) =>
                e.time!.day == DateTime.now().day &&
                    e.time!.month == DateTime.now().month &&
                e.name == Constants.currentUser.name)
            .toList();
        praisedFriendName.clear();
        for (var data in praiseList) {
          praisedFriendName.add(data.toname!);
        }

        // 칭찬할 친구 이름
        praiseFriendName.clear();
        for (var data in praiseController.praiseFriendData) {
          praiseFriendName.add(data['name']);
        }
        return Container(
          height: MediaQuery.of(context).size.height * 0.45 + bottomInsert,
          decoration: BoxDecoration(
              color: Colors.grey[40],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )),
          child: Padding(
            padding: EdgeInsets.only(
                left: 10, right: 10, top: 10, bottom: bottomInsert),
            child: Form(
              key: _praiseNewFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('행동과 그 과정을 칭찬하세요.',style: TextStyle(fontSize: 16),),
                    const Text('의지와 노력을 칭찬하세요.     ',style: TextStyle(fontSize: 16),),
                    const Text('칭찬은 구체적으로 쓰세요.     ',style: TextStyle(fontSize: 16),),
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: TextFormField(
                        key: const ValueKey(1),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '칭찬할 친구 이름을 입력하세요.';
                          }
                          if (!praiseFriendName.contains(value) ||
                              value == Constants.currentUser.name) {
                            return '칭찬할 친구이름을 확인하세요.';
                          } else if (praisedFriendName.contains(value)) {
                            return '한 친구에게 칭찬은 하루에 한번 만 하세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          newPraise.toname = value!; // 친구이름 입력
                        },
                        onChanged: (value) {
                          newPraise.toname = value; // 친구이름 입력
                        },
                        // 입력창 디자인
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: '친구이름을 입력하세요.',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      child: TextFormField(
                        key: const ValueKey(2),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '칭찬 내용을 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          newPraise.content = value!;
                        },
                        onChanged: (value) {
                          newPraise.content = value;
                        },
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '칭찬 내용을 입력하세요.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 16)),
                      onPressed: () async {
                        if (_tryValidation()) {
                          newPraise.time = DateTime.now();
                          praiseController.submitPraiseData(newPraise);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        '확인',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });
  }
}
