import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ourclassroom/services/api_service.dart';

import '../models/models.dart';
import '../services/snackbar_service.dart';
import '../utils/constants.dart';

class SelfStudyController extends GetxController {
  final ApiService _apiService = ApiService();
  final SnackBarService snackBarService = SnackBarService();
  RxList<SelfStudyData> selfStudyData = <SelfStudyData>[].obs;
  RxList<SelfStudyDay> selfStudyDay = <SelfStudyDay>[].obs;
  RxList<Map<String, dynamic>> allStudents = <Map<String, dynamic>>[].obs;
  RxBool isLoadingSelfStudyData = false.obs;
  RxBool isLoadingSelfStudyDay = false.obs;
  RxBool isStudyDay = false.obs;
  RxBool isLoadingAllStudents = false.obs;

  RxString fetchMessage = ''.obs;
  RxString fetchTodayMessage = ''.obs;
  RxString fetchStudyDayMessage = ''.obs;
  Rxn<int> selected1 = Rxn<int>();
  Rxn<int> selected2 = Rxn<int>();
  Rxn<int> selected3 = Rxn<int>();
  Rxn<int> todaySelectedId = Rxn<int>();
  RxBool isTodayData = false.obs;
  RxString selectedChoiceString8 = '자습 신청하세요.'.obs;
  RxString selectedChoiceString1 = '자습 신청하세요.'.obs;
  RxString selectedChoiceString2 = '자습 신청하세요.'.obs;

  @override
  void onInit() async {
    super.onInit();
    if(!Constants.currentUser.isNonHomeroomTeacher) {
      await fetchAllStudents();
      await fetchSelfStudyData();
      await fetchSelfStudyDay();
    }
  }

  Future<void> fetchAllStudents() async {
    isLoadingAllStudents.value = true;
    Map<String, dynamic> postData = {
      'action': 'get_all_students',
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      allStudents.clear();
      for (var item in responseData['classStudents']) {
        allStudents.add(item);
      }
    } else {
      if (responseData.containsKey('error')) {
        snackBarService.showCustomSnackBar(
            responseData['error'], Colors.orange[200]!);
      } else {
        snackBarService.showCustomSnackBar(
            responseData['message'], Colors.orange[200]!);
      }
    }
    isLoadingAllStudents.value = false;
  }

  Future<void> fetchSelfStudyData() async {
    isLoadingSelfStudyData.value = true;
    isTodayData.value = false;
    fetchMessage.value = '';
    selfStudyData.clear();

    Map<String, dynamic> postData = {
      'action': 'get_selfstudy_data',
      'grade': Constants.currentUser.grade,
      'class': Constants.currentUser.classNum,
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      for (var item in responseData['selfStudyData']) {
        selfStudyData.add(SelfStudyData.fromJson(item));
      }
      var todayData = selfStudyData
          .where((e) =>
              DateFormat('M-d').format(e.time!) ==
                  DateFormat('M-d').format(DateTime.now()) &&
              e.number == Constants.currentUser.number)
          .toList();
      if (todayData.isNotEmpty) {
        selected1.value = todayData[0].term1;
        selected2.value = todayData[0].term2;
        selected3.value = todayData[0].term3;
        initChoice();
        isTodayData.value = true;
        todaySelectedId.value = todayData[0].id;
      }
    } else {
      if (responseData.containsKey('error')) {
        fetchMessage.value = responseData['error'];
      } else {
        fetchMessage.value = responseData['message'];
      }
    }
    isLoadingSelfStudyData.value = false;
  }

  Future<void> fetchSelfStudyDay() async {
    isLoadingSelfStudyDay.value = true;
    fetchStudyDayMessage.value = '';
    Map<String, dynamic> postData = {
      'action': 'get_selfstudyday_data',
      'day': DateTime.now().toIso8601String(),
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      for (var item in responseData['selfStudyDay']) {
        selfStudyDay.add(SelfStudyDay.fromJson(item));
      }
      if (Constants.currentUser.grade == 1) {
        isStudyDay.value = selfStudyDay[0].grade1!;
      }
      if (Constants.currentUser.grade == 2) {
        isStudyDay.value = selfStudyDay[0].grade2!;
      }
      if (Constants.currentUser.grade == 3) {
        isStudyDay.value = selfStudyDay[0].grade3!;
      }
    } else {
      if (responseData.containsKey('error')) {
        fetchStudyDayMessage.value = responseData['error'];
      } else {
        fetchStudyDayMessage.value = responseData['message'];
      }
    }
    isLoadingSelfStudyDay.value = false;
  }

  Future<void> submitSelfStudyData() async {
    Map<String, dynamic> postData = {
      'action': 'insert_selfstudy_data', // Pass action in the body
      'grade': Constants.currentUser.grade,
      'class': Constants.currentUser.classNum,
      'number': Constants.currentUser.number,
      'name': Constants.currentUser.name,
      'term1': selected1.value,
      'term2': selected2.value,
      'term3': selected3.value,
      'time': DateTime.now().toIso8601String()
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      await fetchSelfStudyData();
      snackBarService.showCustomSnackBar(
          responseData['message'], Colors.green[200]!);
    } else {
      if (responseData.containsKey('error')) {
        snackBarService.showCustomSnackBar(
            responseData['error'], Colors.orange[200]!);
      } else {
        snackBarService.showCustomSnackBar(
            responseData['message'], Colors.orange[200]!);
      }
    }
  }

  Future<void> nonApplicantSubmitSelfStudyData(int number, String name, int term1, int term2, int term3) async {
    Map<String, dynamic> postData = {
      'action': 'insert_selfstudy_data', // Pass action in the body
      'grade': Constants.currentUser.grade,
      'class': Constants.currentUser.classNum,
      'number': number,
      'name': name,
      'term1': term1,
      'term2': term2,
      'term3': term3,
      'time': DateTime.now().toIso8601String()
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      await fetchSelfStudyData();
      snackBarService.showCustomSnackBar(
          responseData['message'], Colors.green[200]!);
    } else {
      if (responseData.containsKey('error')) {
        snackBarService.showCustomSnackBar(
            responseData['error'], Colors.orange[200]!);
      } else {
        snackBarService.showCustomSnackBar(
            responseData['message'], Colors.orange[200]!);
      }
    }
  }

  Future<void> updateSelfStudyData() async {
    Map<String, dynamic> postData = {
      'action': 'update_selfstudy_data', // Pass action in the body
      'id': todaySelectedId.value,
      'term1': selected1.value,
      'term2': selected2.value,
      'term3': selected3.value,
      'time': DateTime.now().toIso8601String()
    };
    final responseData = await _apiService.postData(postData);
    if (responseData['success']) {
      await fetchSelfStudyData();
      snackBarService.showCustomSnackBar(
          responseData['message'], Colors.green[200]!);
    } else {
      if (responseData.containsKey('error')) {
        snackBarService.showCustomSnackBar(
            responseData['error'], Colors.orange[200]!);
      } else {
        snackBarService.showCustomSnackBar(
            responseData['message'], Colors.orange[200]!);
      }
    }
  }

  // 첫 번째 선택: 자습 또는 귀가
  RxString firstChoice8 = ''.obs;
  RxString firstChoice1 = ''.obs;
  RxString firstChoice2 = ''.obs;

  // 두 번째 선택: 자습 선택 시, 교실 또는 이동
  RxString secondChoiceStudy8 = ''.obs;
  RxString secondChoiceStudy1 = ''.obs;
  RxString secondChoiceStudy2 = ''.obs;

  // 두 번째 선택: 귀가 선택 시, 학교밖 자습, 학원 또는 과외, 학교활동, 기타
  RxString secondChoiceReturn1 = ''.obs;
  RxString secondChoiceReturn2 = ''.obs;

  // 세 번째 선택: 이동 선택 시, 상담 또는 학교활동, 학원/과외 선택시 국어, 수학, 영어, 전공어, 기타과목
  RxString thirdChoiceMove8 = ''.obs;
  RxString thirdChoiceMove1 = ''.obs;
  RxString thirdChoiceMove2 = ''.obs;
  RxString thirdChoiceReturn1 = ''.obs;
  RxString thirdChoiceReturn2 = ''.obs;

  void initChoice() {
    // 8교시 코드에서 설정 추출
    final fullChoice8 = selfStudyCodeToString[selected1.value]!;
    final parts8 = fullChoice8.split(' > ');

    firstChoice8.value = parts8[0];
    secondChoiceStudy8.value = parts8.length > 1 ? parts8[1] : '';
    thirdChoiceMove8.value = parts8.length > 2 ? parts8[2] : '';

    // 야자 1차시 코드에서 설정 추출
    final fullChoice1 = selfStudyCodeToString[selected2.value]!;
    final parts1 = fullChoice1.split(' > ');

    if (parts1[0] == '학교') {
      firstChoice1.value = parts1[0];
      secondChoiceStudy1.value = parts1.length > 1 ? parts1[1] : '';
      thirdChoiceMove1.value = parts1.length > 2 ? parts1[2] : '';
    } else {
      firstChoice1.value = parts1[0];
      secondChoiceReturn1.value = parts1.length > 1 ? parts1[1] : '';
      thirdChoiceReturn1.value = parts1.length > 2 ? parts1[2] : '';
    }

    // 야자 2차시 코드에서 설정 추출
    final fullChoice2 = selfStudyCodeToString[selected3.value]!;
    final parts2 = fullChoice2.split(' > ');
    if (parts2[0] == '학교') {
      firstChoice2.value = parts2[0];
      secondChoiceStudy2.value = parts2.length > 1 ? parts2[1] : '';
      thirdChoiceMove2.value = parts2.length > 2 ? parts2[2] : '';
    } else {
      firstChoice2.value = parts2[0];
      secondChoiceReturn2.value = parts2.length > 1 ? parts2[1] : '';
      thirdChoiceReturn2.value = parts2.length > 2 ? parts2[2] : '';
    }
    selectedChoice8();
    selectedChoice1();
    selectedChoice2();
  }

  void selectedChoice8() {
    if (firstChoice8.value == '학교') {
      if (secondChoiceStudy8.value == '교실자습') {
        selectedChoiceString8.value = '학교 > 교실자습';
      } else if (secondChoiceStudy8.value == '이동') {
        if (thirdChoiceMove8.value == '상담') {
          selectedChoiceString8.value = '학교 > 이동 > 상담';
        } else if (thirdChoiceMove8.value == '학교활동') {
          selectedChoiceString8.value = '학교 > 이동 > 학교활동';
        } else if (thirdChoiceMove8.value == 'PMP실 이용') {
          selectedChoiceString8.value = '학교 > 이동 > PMP실 이용';
        } else {
          selectedChoiceString8.value = '학교 > 이동 >';
        }
      } else {
        selectedChoiceString8.value = '학교 >';
      }
    } else if (firstChoice8.value == '귀가') {
      selectedChoiceString8.value = '귀가';
    } else{
      selectedChoiceString8.value = '자습 신청하세요.';
    }
  }

  void selectedChoice1() {
    if (firstChoice1.value == '학교') {
      if (secondChoiceStudy1.value == '교실자습') {
        selectedChoiceString1.value = '학교 > 교실자습';
      } else if (secondChoiceStudy1.value == '이동') {
        if (thirdChoiceMove1.value == '상담') {
          selectedChoiceString1.value = '학교 > 이동 > 상담';
        } else if (thirdChoiceMove1.value == '학교활동') {
          selectedChoiceString1.value = '학교 > 이동 > 학교활동';
        } else if (thirdChoiceMove1.value == 'PMP실 이용') {
          selectedChoiceString1.value = '학교 > 이동 > PMP실 이용';
        } else {
        selectedChoiceString1.value = '학교 > 이동 >';
        }
      } else {
      selectedChoiceString1.value = '학교 >';
      }
    } else if (firstChoice1.value == '귀가') {
      if (secondChoiceReturn1.value == '학교 밖 자습') {
        selectedChoiceString1.value = '귀가 > 학교 밖 자습';
      } else if (secondChoiceReturn1.value == '학원/과외') {
        if (thirdChoiceReturn1.value == '국어') {
          selectedChoiceString1.value = '귀가 > 학원/과외 > 국어';
        } else if (thirdChoiceReturn1.value == '수학') {
          selectedChoiceString1.value = '귀가 > 학원/과외 > 수학';
        } else if (thirdChoiceReturn1.value == '영어') {
          selectedChoiceString1.value = '귀가 > 학원/과외 > 영어';
        } else if (thirdChoiceReturn1.value == '전공어') {
          selectedChoiceString1.value = '귀가 > 학원/과외 > 전공어';
        } else if (thirdChoiceReturn1.value == '기타과목') {
          selectedChoiceString1.value = '귀가 > 학원/과외 > 기타과목';
        } else {
        selectedChoiceString1.value = '귀가 > 학원/과외 >';
        }
      } else if (secondChoiceReturn1.value == '학교활동') {
        selectedChoiceString1.value = '귀가 > 학교활동';
      } else if (secondChoiceReturn1.value == '기타') {
        selectedChoiceString1.value = '귀가 > 기타';
      } else {
        selectedChoiceString1.value = '귀가 >';
      }
    } else {
      selectedChoiceString1.value = '자습 신청하세요.';
    }
  }

  void selectedChoice2() {
    if (firstChoice2.value == '학교') {
      if (secondChoiceStudy2.value == '교실자습') {
        selectedChoiceString2.value = '학교 > 교실자습';
      } else if (secondChoiceStudy2.value == '이동') {
        if (thirdChoiceMove2.value == '상담') {
          selectedChoiceString2.value = '학교 > 이동 > 상담';
        } else if (thirdChoiceMove2.value == '학교활동') {
          selectedChoiceString2.value = '학교 > 이동 > 학교활동';
        } else {
        selectedChoiceString2.value = '학교 > 이동 >';
        }
      } else {
      selectedChoiceString2.value = '학교 >';
      }
    } else if (firstChoice2.value == '귀가') {
      if (secondChoiceReturn2.value == '학교 밖 자습') {
        selectedChoiceString2.value = '귀가 > 학교 밖 자습';
      } else if (secondChoiceReturn2.value == '학원/과외') {
        if (thirdChoiceReturn2.value == '국어') {
          selectedChoiceString2.value = '귀가 > 학원/과외 > 국어';
        } else if (thirdChoiceReturn2.value == '수학') {
          selectedChoiceString2.value = '귀가 > 학원/과외 > 수학';
        } else if (thirdChoiceReturn2.value == '영어') {
          selectedChoiceString2.value = '귀가 > 학원/과외 > 영어';
        } else if (thirdChoiceReturn2.value == '전공어') {
          selectedChoiceString2.value = '귀가 > 학원/과외 > 전공어';
        } else if (thirdChoiceReturn2.value == '기타과목') {
          selectedChoiceString2.value = '귀가 > 학원/과외 > 기타과목';
        } else {
        selectedChoiceString2.value = '귀가 > 학원/과외 >';}
      } else if (secondChoiceReturn2.value == '학교활동') {
        selectedChoiceString2.value = '귀가 > 학교활동';
      } else if (secondChoiceReturn2.value == '기타') {
        selectedChoiceString2.value = '귀가 > 기타';
      } else {
      selectedChoiceString2.value = '귀가 >'; }
    } else {
    selectedChoiceString2.value = '자습을 신청하세요.';
    }
  }

  Map<int, String> selfStudyCodeToString =
    {0: '학교 > 교실자습',
    1: '귀가',
    10: '학교 > 이동 > 상담',
    11: '학교 > 이동 > 학교활동',
    12: '학교 > 이동 > PMP실 이용',
    20: '귀가 > 학교 밖 자습',
    21: '귀가 > 학원/과외 > 국어',
    22: '귀가 > 학원/과외 > 수학',
    23: '귀가 > 학원/과외 > 영어',
    24: '귀가 > 학원/과외 > 전공어',
    25: '귀가 > 학원/과외 > 기타과목',
    26: '귀가 > 학교활동',
    27: '귀가 > 기타'};
  Map<String, int> selfStudyStringToCode =
    {'학교 > 교실자습': 0,
    '귀가': 1,
    '학교 > 이동 > 상담': 10,
    '학교 > 이동 > 학교활동': 11,
    '학교 > 이동 > PMP실 이용': 12,
    '귀가 > 학교 밖 자습': 20,
    '귀가 > 학원/과외 > 국어': 21,
    '귀가 > 학원/과외 > 수학': 22,
    '귀가 > 학원/과외 > 영어': 23,
    '귀가 > 학원/과외 > 전공어': 24,
    '귀가 > 학원/과외 > 기타과목': 25,
    '귀가 > 학교활동': 26,
    '귀가 > 기타': 27};

  // 첫 번째 선택 상태 변경
  void updateFirstChoice8(String choice) {
    firstChoice8.value = choice;
    secondChoiceStudy8.value = ''; // 이전 선택 초기화
    thirdChoiceMove8.value = ''; // 이전 선택 초기화
  }

  void updateFirstChoice1(String choice) {
    firstChoice1.value = choice;
    secondChoiceStudy1.value = ''; // 이전 선택 초기화
    secondChoiceReturn1.value = ''; // 이전 선택 초기화
    thirdChoiceMove1.value = ''; // 이전 선택 초기화
    thirdChoiceReturn1.value ='';
  }

  void updateFirstChoice2(String choice) {
    firstChoice2.value = choice;
    secondChoiceStudy2.value = ''; // 이전 선택 초기화
    secondChoiceReturn2.value = ''; // 이전 선택 초기화
    thirdChoiceMove2.value = ''; // 이전 선택 초기화
    thirdChoiceReturn2.value ='';
  }

  // 두 번째 선택 (자습) 상태 변경
  void updateSecondChoiceStudy8(String choice) {
    secondChoiceStudy8.value = choice;
    thirdChoiceMove8.value = ''; // 이전 선택 초기화
  }

  void updateSecondChoiceStudy1(String choice) {
    secondChoiceStudy1.value = choice;
    thirdChoiceMove1.value = ''; // 이전 선택 초기화
  }

  void updateSecondChoiceStudy2(String choice) {
    secondChoiceStudy2.value = choice;
    thirdChoiceMove2.value = ''; // 이전 선택 초기화
  }

  // 두 번째 선택 (귀가) 상태 변경
  void updateSecondChoiceReturn1(String choice) {
    secondChoiceReturn1.value = choice;
    thirdChoiceReturn1.value = ''; // 이전 선택 초기화
  }

  void updateSecondChoiceReturn2(String choice) {
    secondChoiceReturn2.value = choice;
    thirdChoiceReturn2.value = ''; // 이전 선택 초기화
  }

  // 세 번째 선택 (이동) 상태 변경
  void updateThirdChoiceMove8(String choice) {
    thirdChoiceMove8.value = choice;
  }

  void updateThirdChoiceMove1(String choice) {
    thirdChoiceMove1.value = choice;
  }

  void updateThirdChoiceMove2(String choice) {
    thirdChoiceMove2.value = choice;
  }

  void updateThirdChoiceReturn1(String choice) {
    thirdChoiceReturn1.value = choice;
  }

  void updateThirdChoiceReturn2(String choice) {
    thirdChoiceReturn2.value = choice;
  }

  // 선택 상태에 따른 다음 단계의 칩들을 보여주는지 여부를 결정하는 메소드
  bool showSecondChoiceStudy8() => firstChoice8.value == '학교';

  bool showThirdChoiceMove8() => secondChoiceStudy8.value == '이동';

  bool showSecondChoiceStudy1() => firstChoice1.value == '학교';

  bool showSecondChoiceReturn1() => firstChoice1.value == '귀가';

  bool showThirdChoiceMove1() => secondChoiceStudy1.value == '이동';

  bool showThirdChoiceReturn1() => secondChoiceReturn1.value == '학원/과외';

  bool showSecondChoiceStudy2() => firstChoice2.value == '학교';

  bool showSecondChoiceReturn2() => firstChoice2.value == '귀가';

  bool showThirdChoiceMove2() => secondChoiceStudy2.value == '이동';

  bool showThirdChoiceReturn2() => secondChoiceReturn2.value == '학원/과외';
}
