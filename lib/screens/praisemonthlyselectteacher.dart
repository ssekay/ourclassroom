import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/gemini_controller.dart';
import '../controllers/praisecontroller.dart';
import '../services/snackbar_service.dart';

class PraiseMonthlySelectTeacher extends StatefulWidget {
  const PraiseMonthlySelectTeacher({super.key});

  @override
  State<PraiseMonthlySelectTeacher> createState() => _PraiseMonthlySelectTeacherState();
}

class _PraiseMonthlySelectTeacherState extends State<PraiseMonthlySelectTeacher> {
  final PraiseController praiseController = Get.put(PraiseController());
  final GeminiController _geminiController = Get.put(GeminiController());
  final SnackBarService snackBarService = SnackBarService();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textEditingFocusNode = FocusNode();
  TextStyle textStyle = const TextStyle(fontSize: 20);
  int month = 0;
  String explain = '';
  bool isView = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    month = DateTime.now().month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('칭찬 학생 선정 하기'),
        centerTitle: true,
      ),
      body: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (DateTime(2025,month).isAfter(DateTime(2025,3))) {
                            setState(() {
                              month = month-1;
                            });
                          }
                        },
                        child: const Icon(Icons.arrow_back_ios)),
                    Text(
                      DateFormat('M월', 'ko_KR')
                          .format(DateTime(2025, month)),
                      style: textStyle,
                    ),
                    TextButton(
                        onPressed: () {
                          if (DateTime(2025,month).isBefore(DateTime(2025,DateTime.now().month, 1))) {
                            setState(() {
                              month = month+1;
                            });
                          }
                        },
                        child: const Icon(Icons.arrow_forward_ios)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                isView ? const SizedBox.shrink() : TextField(
                  controller: _textEditingController,
                  focusNode: _textEditingFocusNode,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  maxLines: 2,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[200]!, width: 1.5),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                    labelText: '칭찬능력이 가장 뛰어난 학생을 두 명 선정해줘',
                  ),
                  onTapOutside: (event) {
                    _textEditingFocusNode.unfocus();
                  },
                  onSubmitted: (value) {
                    if(value.isNotEmpty) {
                      setState(() {
                        _geminiController.selectMonthPraiseStudent(
                            month, value);
                        explain = value;
                        _textEditingController.clear();
                        isView = true;
                      });
                    } else {
                      snackBarService.showCustomSnackBar('내용을 입력해주세요.', Colors.red[200]!);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Obx(() {
                  if (_geminiController.isSelectMonthStudent.value) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  } else {
                    return isView
                        ? Expanded(
                      child: SingleChildScrollView(
                        child: GestureDetector(
                          onDoubleTap: (){
                            setState(() {
                              explain ='';
                              isView = false;
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width - 36,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[200],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Text(explain)),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onLongPress: () {
                                  Clipboard.setData(ClipboardData(text : _geminiController.selectMonthStudentResult.value));
                                  snackBarService.showCustomSnackBar('자료가 클립보드에 복사되었습니다.', Colors.green[200]!);
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width - 36,
                                    decoration: BoxDecoration(
                                      color: Colors.green[200],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Text(_geminiController.selectMonthStudentResult.value)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : const SizedBox.shrink();
                  }
                }),
              ],
            ),
          ),
    );
  }
}
