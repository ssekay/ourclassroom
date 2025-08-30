import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourclassroom/services/ai_service.dart';
import 'package:ourclassroom/services/speech_service.dart';

import '../controllers/praisecontroller.dart';
import '../utils/constants.dart';

class GeminiController extends GetxController {
  PraiseController praiseController = Get.put(PraiseController());
  final AIService _aiService = AIService();
  final SpeechService _speechService = SpeechService();

  RxString question = ''.obs;
  RxString answer = ''.obs;
  RxBool isListening = false.obs;
  RxString evaluationResult = ''.obs;
  RxString selectMonthStudentResult = ''.obs;
  RxBool isEvaluated = false.obs;
  RxBool isSelectMonthStudent = false.obs;
  RxBool isLoading = false.obs;
  RxBool isResultView = false.obs;

  final TextEditingController geminiTextEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _speechService.initialize();
  }

  @override
  void onClose() {
    geminiTextEditingController.dispose();
    super.onClose();
  }

  Future<void> askQuestion() async {
    String currentQuestion = geminiTextEditingController.text.trim();
    if (currentQuestion.isEmpty) {
      return;
    }
    isLoading.value = true;
    isResultView.value = false;
    question.value = currentQuestion;
    answer.value = await _aiService.generateContent(currentQuestion);
    isLoading.value = false;
    isResultView.value = true;
  }

  Future<void> toggleListening() async {
    if (isListening.value) {
      stopListening();
      isLoading.value=false;
    } else {
      startListening();
      isLoading.value=true;
    }
  }

  Future<void> startListening() async {
    isListening.value = true;
    isLoading.value = true;
    isResultView.value = false;
    String voiceInput = await _speechService.startListening();
    if (voiceInput.isNotEmpty) {
      geminiTextEditingController.text = voiceInput;
      question.value = voiceInput;
      answer.value = await _aiService.generateContent(question.value);
    }
    geminiTextEditingController.clear();
    isListening.value = false;
    isLoading.value = false;
    isResultView.value = true;
  }

  void stopListening() {
    _speechService.stopListening();
    isListening.value = false;
    isLoading.value = true;
  }

  void clearContent() {
    question.value = '';
    answer.value = '';
  }

  Future<void> evaluateCompliments() async {
    isEvaluated.value = true;
    evaluationResult.value = '';
    if (praiseController.praiseData.isNotEmpty) {
      final compliments1 = praiseController.praiseData
          .where((e) => e.name == Constants.currentUser.name
      ).toList();
      final compliments2 = praiseController.praiseData.where((e) =>
      e.toname ==  Constants.currentUser.name
      ).toList();
      if (compliments1.isEmpty && compliments2.isEmpty) {
        evaluationResult.value = '칭찬 자료가 없습니다.';
        isEvaluated.value = false;
        return;
      } else {
            final prompt = """
                  당신은 칭찬 평가의 전문가입니다.
            칭찬 목록을 알려 드리겠습니다.
            다음 기준에 따라 평가해 주세요.:
            1. 성실성: 칭찬은 얼마나 진실되고 진심 어린가?
            2. 구체성: 그 사람 행동에 대한 칭찬은 얼마나 구체적입니까?
            3. 영향: 칭찬이 상대방의 기분을 좋게 만들 가능성은 얼마나 됩니까?
            4. 적절성: 칭찬이 맥락과 관계에 얼마나 적합한가요?
            ${praiseController.praiseFriendData.length}명으로 구성된 학급에서 친구들 사이의 원만한 관계를 유지하고 다른 사람들을 존중하고 배려하는 생활습관을 기르고자 
            친구를 칭찬하는 활동을 하고 있습니다. 다른 사람들과 함께 살아가기 위한 의미 있고 효과적인 칭찬능력을 향상하고자 합니다.
            현재 ${praiseController.praiseData.length}건의 칭찬활동이 진행되었습니다. 
            칭찬 내용은 다음과 같습니다.:
            ${compliments1.map((c) => '- 내가 칭찬한 친구 이름 : ${c.toname}, 내가 칭찬한 내용 : ${c.content}').join('\n')}
            ${compliments2.map((c) => '- 나를 칭친한 친구 이름 : ${c.name}, 칭찬받은 내용 : ${c.content}').join('\n')}
           학급 인원수와 칭찬활동 건수를 참고하여 ${Constants.currentUser.name} 학생의 칭찬 활동과 학교 생활 모습에 대하여 평가를 해주고 조언을 해주세요.   
           귀하의 평가를 냉정하고 명확하게 제공해 주십시오.
        """;
        try {
          final response = await _aiService.generateContent(prompt);
          if (response.isNotEmpty) {
            evaluationResult.value = response;
          } else {
            evaluationResult.value = "AI로부터 답변이 없습니다.";
          }
        } catch (e) {
          evaluationResult.value = "오류: $e";
        }
      }
    } else {
      evaluationResult.value = "학급의 칭찬 자료가 없습니다.";
    }
    isEvaluated.value = false;
  }

  Future<void> selectMonthPraiseStudent(int month, String string) async {
    isSelectMonthStudent.value = true;
    selectMonthStudentResult.value ='';
    if (praiseController.praiseData.isNotEmpty) {
      final compliments = praiseController.praiseData
          .where((e) =>
      e.time!.month == month).toList();
      if (compliments.isEmpty) {
        selectMonthStudentResult.value = '칭찬 자료가 없습니다.';
        isSelectMonthStudent.value = false;
        return;
      } else {
        final prompt = """
       당신은 칭찬 평가 전문가 입니다.
       칭찬 목록을 알려 드리겠습니다.
       칭찬은 다음과 같습니다.:
        ${compliments.map((c) => '칭찬한 학생 :  ${c.name}, 칭찬반은 학생 : ${c.toname}, 칭찬 내용 : ${c.content}').join('\n')}
        $string
        """;
        try {
          final response = await _aiService.generateContent(prompt);
          if (response.isNotEmpty) {
            selectMonthStudentResult.value = response;
          } else {
            selectMonthStudentResult.value = "AI로부터 답변이 없습니다.";
          }
        } catch (e) {
          selectMonthStudentResult.value = "오류: $e";
        }
      }
    } else {
      selectMonthStudentResult.value = "칭찬자료가 없습니다.";
      isSelectMonthStudent.value = false;
    }
    isSelectMonthStudent.value = false;
  }
}
