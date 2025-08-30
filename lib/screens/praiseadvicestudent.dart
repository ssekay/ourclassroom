import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/gemini_controller.dart';

class PraiseAdviceStudent extends StatefulWidget {
  const PraiseAdviceStudent({super.key});

  @override
  State<PraiseAdviceStudent> createState() => _PraiseAdviceStudentState();
}

class _PraiseAdviceStudentState extends State<PraiseAdviceStudent> {
  GeminiController geminiController = Get.put(GeminiController());
  bool isView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 칭찬에 관하여'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isView ? const SizedBox.shrink() :
          Center(
            child: ElevatedButton(
                onPressed:(){
                    geminiController.evaluateCompliments();
                    setState(() {
                      isView = true;
                    });
                },
                child: const Text('AI의 조언을 들어보세요.')),
          ),
          isView ? const Text('더블클릭하면 이전 화면으로 돌아갑니다.') : const SizedBox.shrink(),
          isView ? const SizedBox(height: 10) : const SizedBox.shrink(),
          isView ? Obx(() {
            if (geminiController.isEvaluated.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
                return  Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: GestureDetector(
                        onDoubleTap: (){
                          geminiController.evaluationResult.value='';
                          setState(() {
                            isView = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green[200],
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              geminiController.evaluationResult.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
          }
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
