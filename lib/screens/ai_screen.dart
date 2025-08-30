import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/gemini_controller.dart';
import '../services/snackbar_service.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final GeminiController _geminiController = Get.put(GeminiController());
  final SnackBarService snackBarService = SnackBarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI챗봇'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _geminiController.geminiTextEditingController,
                    decoration: const InputDecoration(
                      labelText: '챗봇에게 물어보세요.',
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _geminiController.askQuestion();
                        _geminiController.geminiTextEditingController.clear();
                      });
                    },
                  ),
                ),
                Obx(
                  () => IconButton(
                    icon: Icon(_geminiController.isListening.value
                        ? Icons.stop
                        : Icons.mic),
                    onPressed: () {
                      setState(() {
                        _geminiController.toggleListening();
                        _geminiController.geminiTextEditingController.clear();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (_geminiController.isLoading.value) {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              } else {
                return _geminiController.isResultView.value
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: GestureDetector(
                            onDoubleTap: (){
                              setState(() {
                                _geminiController.isResultView.value = false;
                                _geminiController.clearContent();
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
                                    child: Text(_geminiController.question.value)),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onLongPress: () {
                                    Clipboard.setData(ClipboardData(text : _geminiController.answer.value));
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
                                      child: Text(_geminiController.answer.value)),
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
