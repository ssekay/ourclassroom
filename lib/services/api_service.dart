import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import '../models/models.dart'; // NewsData는 여기서 사용하지 않으므로, News만 import해도 무방

class ApiService {
  final String baseUrl = 'http://61.83.221.128/aflhs_sdl/ourclassroom.php';
  final String uploadUrl = 'http://61.83.221.128/aflhs_sdl/ourclassroomupload.php';
  final String authUrl = 'http://61.83.221.128/aflhs_sdl/auth_ssekay_new.php';

  ////////// 교육청 공공 데이터 정보 ////////
  static final String? _niceApiKey = dotenv.env['NICE_API_KEY'];
  static const String _niceATPTOfCdcScCode = 'J10';
  static const String _niceSdSchulCode = '7530187';
  static const String _niceMealBaseUrl = 'https://open.neis.go.kr/hub/mealServiceDietInfo';

  ////////// 네이버 공공 데이터 정보 ////////
  static final String? _naverClientId = dotenv.env['NAVER_CLIENT_ID'];
  static final String? _naverClientSecret = dotenv.env['NAVER_CLIENT_SECRET'];
  static const String _naverNewsBaseUrl = 'https://openapi.naver.com/v1/search/news.json';

  // HTML 태그 (br 제외), amp; 제거. 단, 숫자와 점만 있는 괄호는 유지
  static final _htmlTagRegex = RegExp(r'<(?!\/?br\s*\/?>)[^>]*>|amp;');
  // 숫자와 점, 괄호로만 구성된 패턴 (알레르기 정보)을 제외하고 괄호와 내용을 제거하는 정규식
  static final _allergyInfoKeepRegex = RegExp(r'\s*\((?!\d+[\d\.]*\))[^)]*\)');

  // 텍스트를 정리하는 헬퍼 함수
  static String _cleanupText(String? text) {
    if(text == null) {
      return '';
    }
    String cleanedText = text.replaceAll(RegExp(r'<br\s*\/?>', caseSensitive: false), '\n'); // <br/> 태그를 \n으로 변경
    cleanedText = cleanedText.replaceAll(_htmlTagRegex, ''); // HTML 태그 (br 제외) 및 amp; 제거
    cleanedText = cleanedText.replaceAll(_allergyInfoKeepRegex, ''); // 알레르기 정보 형태가 아닌 괄호와 그 내용 제거
    cleanedText = cleanedText.replaceAll(RegExp(r'\s+'), ' ').trim(); // 연속된 공백을 단일 공백으로, 앞뒤 공백 제거
    return cleanedText.replaceAll('\n', ', ').trim();  // \n을 ', '로 변경
  }

  // 나이스에서 식사정보 가져오기
  static Future<MealData?> mealData() async {
    final today = DateFormat('yyyyMMdd').format(DateTime.now());
    final url = Uri.parse('$_niceMealBaseUrl?KEY=$_niceApiKey&Type=json'
        '&ATPT_OFCDC_SC_CODE=$_niceATPTOfCdcScCode&SD_SCHUL_CODE=$_niceSdSchulCode&MLSV_YMD=$today');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('RESULT')) {
          return null;
        }

        final List<dynamic> mealDataList = data['mealServiceDietInfo'][1]['row'];

        for (var mealData in mealDataList) {
          if(mealData['MMEAL_SC_NM'] == '중식') {
            return MealData(
              menu: _cleanupText(mealData['DDISH_NM']),
              origin: _cleanupText(mealData['ORPLC_INFO']),
              calories: _cleanupText(mealData['CAL_INFO']),
            );
          }
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch meal data: $e');
    }
  }

  // 네이버 뉴스 요청 - 반환 타입을 List<News>? 로 변경
  static Future<dynamic> naverNewsData(String query) async {
    final url = Uri.parse('$_naverNewsBaseUrl?query=$query&display=10&sort=date'); // display=10 추가
    try {
      final response = await http.get(
        url,
        headers: {
          'X-Naver-Client-Id': _naverClientId!,
          'X-Naver-Client-Secret': _naverClientSecret!,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['items'] != null) {
          return data['items'];
        } else {
          return []; // items가 없으면 빈 리스트 반환
        }
      } else {
        return null; // 오류 발생 시 null 반환
      }
    } catch (e) {
      // Get.snackbar나 다른 방식으로 오류를 사용자에게 알릴 수 있습니다.
      // print('Failed to fetch news data: $e'); 
      throw Exception('Failed to fetch news data: $e');
    }
  }

  // 네이버 뉴스 요청 - 반환 타입을 List<News>? 로 변경
  static Future<dynamic> numbersApi(String numbers) async {
    final url = Uri.parse('http://numbersapi.com/$numbers?json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data;
        } else {
          return []; // items가 없으면 빈 리스트 반환
        }
      } else {
        return null; // 오류 발생 시 null 반환
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  // 학교서버로 자료 전송
  Future<Map<String, dynamic>> postData(Map<String, dynamic> data) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json', // Set the header
    };
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'success' : false, 'error' : response.statusCode};
    }
  }

  // 학교서버로 파일 업로드
  Future<Map<String, dynamic>> uploadFile(Rx<File?> selectedFile, Map<String, dynamic> postData) async {
    final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    try {
      request.files.add(
        await http.MultipartFile.fromPath(
          'uploaded_file',
          selectedFile.value!.path,
          filename: p.basename(selectedFile.value!.path),
        ),
      );
      request.fields['body'] = jsonEncode(postData);
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody);
      } else {
        return {'success': false, 'message': response.statusCode};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // 인증정보 확인
  Future<Map<String, dynamic>> checkCertificationNumber(String certificationNumber) async {
    final response = await http.post(
      Uri.parse(authUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'certification_number': certificationNumber}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'success' : false, 'error' : response.statusCode};
    }
  }
}
