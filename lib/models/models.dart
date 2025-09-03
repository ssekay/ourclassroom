import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HealthData {
  int? id;
  int? grade;
  int? classNum;
  int? number;
  String? name;
  String? symptoms;
  String? therapy;
  String? medication1;
  String? medication2;
  String? medication3;
  DateTime? app_time;
  DateTime? iss_time;

  HealthData(
      {this.id,
      this.grade,
      this.classNum,
      this.number,
      this.name,
      this.symptoms,
      this.therapy,
      this.medication1,
      this.medication2,
      this.medication3,
      this.app_time,
      this.iss_time});

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
        id: int.parse(json['id']),
        grade: int.parse(json['grade']),
        classNum: int.parse(json['class']),
        number: int.parse(json['number']),
        name: json['name'],
        symptoms: json['symptoms'],
        therapy: json['therapy'] as String?,
        medication1: json['medication1'] as String?,
        medication2: json['medication2'] as String?,
        medication3: json['medication3'] as String?,
        app_time: DateTime.parse(json['app_time']),
        iss_time:
            json['iss_time'] == null ? null : DateTime.parse(json['iss_time']));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'grade': grade,
        'class': classNum,
        'number': number,
        'name': name,
        'symptoms': symptoms,
        'therapy': therapy,
        'medication1': medication1,
        'medication2': medication2,
        'medication3': medication3,
        'app_time': app_time!.toIso8601String(),
        'iss_time': iss_time!.toIso8601String()
      };
}

// 칭찬 자료
class PraiseData {
  int? id;
  int? grade;
  int? classNum;
  int? number;
  String? name;
  String? toname;
  String? content;
  DateTime? time;

  PraiseData(
      {this.id,
      this.grade,
      this.classNum,
      this.number,
      this.name,
      this.toname,
      this.content,
      this.time});

  factory PraiseData.fromJson(Map<String, dynamic> json) {
    return PraiseData(
      id: int.parse(json['id']),
      grade: int.parse(json['grade']),
      classNum: int.parse(json['class']),
      number: int.parse(json['number']),
      name: json['name'],
      toname: json['toname'],
      content: json['content'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'grade': grade,
        'class': classNum,
        'number': number,
        'name': name,
        'toname': toname,
        'content': content,
        'time': time!.toIso8601String()
      };
}

// 출결 자료
class AttendanceData {
  int? id;
  int? grade;
  int? classNum;
  int? number;
  String? name;
  String? division1;
  String? division2;
  bool? etc;
  DateTime? date;

  AttendanceData(
      {this.id,
      this.grade,
      this.classNum,
      this.number,
      this.name,
      this.division1,
      this.division2,
      this.etc,
      this.date});

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      id: int.parse(json['id']),
      grade: int.parse(json['grade']),
      classNum: int.parse(json['class']),
      number: int.parse(json['number']),
      name: json['name'],
      division1: json['division1'],
      division2: json['division2'],
      etc: '1' == json['etc'].toString() ? true : false,
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'grade': grade,
        'class': classNum,
        'number': number,
        'name': name,
        'division1': division1,
        'division2': division2,
        'etc': etc! ? '1' : '0',
        'date': date!.toIso8601String()
      };
}

// 자습 자료
class SelfStudyData {
  int? id;
  int? grade;
  int? classNum;
  int? number;
  String? name;
  int? term1;
  int? term2;
  int? term3;
  DateTime? time;

  SelfStudyData(
      {this.id,
      this.grade,
      this.classNum,
      this.number,
      this.name,
      this.term1,
      this.term2,
      this.term3,
      this.time});

  factory SelfStudyData.fromJson(Map<String, dynamic> json) {
    return SelfStudyData(
      id: int.parse(json['id']),
      grade: int.parse(json['grade']),
      classNum: int.parse(json['class']),
      number: int.parse(json['number']),
      name: json['name'],
      term1: int.parse(json['term1']),
      term2: int.parse(json['term2']),
      term3: int.parse(json['term3']),
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'grade': grade,
        'class': classNum,
        'number': number,
        'name': name,
        'term1': term1,
        'term2': term2,
        'term3': term3,
        'time': time!.toIso8601String()
      };
}

// 자습 여부 자료
class SelfStudyDay {
  DateTime? day;
  bool? grade1;
  bool? grade2;
  bool? grade3;

  SelfStudyDay({this.day, this.grade1, this.grade2, this.grade3});

  factory SelfStudyDay.fromJson(Map<String, dynamic> json) {
    return SelfStudyDay(
      day: DateTime.parse(json['day']),
      grade1: json['grade1'] == '1' ? true : false,
      grade2: json['grade2'] == '1' ? true : false,
      grade3: json['grade3'] == '1' ? true : false,
    );
  }
}

// 분실물 자료
class LostItemData {
  int? id;
  int? ownerGrade;
  int? ownerClass;
  int? ownerNumber;
  String? ownerName;
  String? item;
  String? location;
  String? description;
  int? finderGrade;
  int? finderClass;
  int? finderNumber;
  String? finderName;
  DateTime? handleTime;
  DateTime? registerTime;
  String? status;
  String? image;

  LostItemData(
      {this.id,
      this.ownerGrade,
      this.ownerClass,
      this.ownerNumber,
      this.ownerName,
      this.item,
      this.location,
      this.description,
      this.finderGrade,
      this.finderClass,
      this.finderNumber,
      this.finderName,
      this.handleTime,
      this.registerTime,
      this.status,
      this.image});

  factory LostItemData.fromJson(Map<String, dynamic> json) {
    return LostItemData(
      id: int.parse(json['id']),
      ownerGrade:
          json['ownergrade'] == null ? null : int.parse(json['ownergrade']),
      ownerClass:
          json['ownerclass'] == null ? null : int.parse(json['ownerclass']),
      ownerNumber:
          json['ownernumber'] == null ? null : int.parse(json['ownernumber']),
      ownerName: json['ownername'],
      item: json['item'],
      location: json['location'],
      description: json['description'],
      finderGrade: int.parse(json['findergrade']),
      finderClass: int.parse(json['finderclass']),
      finderNumber: int.parse(json['findernumber']),
      finderName: json['findername'],
      handleTime: json['handletime'] == null
          ? null
          : DateTime.parse(json['handletime']),
      registerTime: DateTime.parse(json['registertime']),
      status: json['status'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ownergrade': ownerGrade,
        'ownerclass': ownerClass,
        'ownernumber': ownerNumber,
        'ownername': ownerName,
        'item': item,
        'location': location,
        'description': description,
        'findergrade': finderGrade,
        'finderclass': finderClass,
        'findernumber': finderNumber,
        'findername': finderName,
        'handletime': handleTime!.toIso8601String(),
        'registertime': registerTime!.toIso8601String(),
        'status': status,
        'image': image,
      };
}

// 시간표 자료
class TimeTableData {
  int? id;
  int? grade;
  int? classNum;
  int? number;
  String? name;
  String? category;
  int? dayOfWeek;
  String? one;
  String? two;
  String? three;
  String? four;
  String? five;
  String? six;
  String? seven;

  TimeTableData(
      {this.id,
        this.grade,
        this.classNum,
        this.number,
        this.name,
        this.category,
        this.dayOfWeek,
        this.one,
        this.two,
        this.three,
        this.four,
        this.five,
        this.six,
        this.seven});

  factory TimeTableData.fromJson(Map<String, dynamic> json) {
    return TimeTableData(
      id: int.parse(json['id']),
      grade: int.parse(json['grade']),
      classNum: int.parse(json['class']),
      number: int.parse(json['number']),
      name: json['name'],
      category: json['category'],
      dayOfWeek: int.parse(json['dayofweek']),
      one: json['one'],
      two: json['two'],
      three: json['three'],
      four: json['four'],
      five: json['five'],
      six: json['six'],
      seven: json['seven'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'grade': grade,
    'class': classNum,
    'number': number,
    'name': name,
    'category': category,
    'dayofweek': dayOfWeek,
    'one': one,
    'two': two,
    'three': three,
    'four': four,
    'five': five,
    'six': six,
    'seven': seven,
  };

  List<String> toValueList() => [
    one == null ? '' : one!.replaceAll('.', ''),
    two == null ? '' : two!.replaceAll('.', ''),
    three == null ? '' : three!.replaceAll('.', ''),
    four == null ? '' : four!.replaceAll('.', ''),
    five == null ? '' : five!.replaceAll('.', ''),
    six == null ? '' : six!.replaceAll('.', ''),
    seven == null ? '' : seven!.replaceAll('.', ''),
  ];
}

// 수리 신청 자료
class RepairData {
  int? id;
  int? grade;
  int? classNum;
  String? teacherName;
  String? item;
  String? location;
  String? itemState;
  String? imageName;
  String? status;
  String? statusExplain;
  DateTime? appTime;
  DateTime? receptionTime;
  DateTime? completionTime;
  String? etc;

  RepairData(
      {this.id,
      this.grade,
      this.classNum,
      this.teacherName,
      this.item,
      this.location,
      this.itemState,
      this.imageName,
      this.status,
      this.statusExplain,
      this.appTime,
      this.receptionTime,
      this.completionTime,
      this.etc});

  factory RepairData.fromJson(Map<String, dynamic> json) {
    return RepairData(
      id: int.parse(json['id']),
      grade: int.parse(json['grade']),
      classNum: int.parse(json['class']),
      teacherName: json['teachername'],
      item: json['item'],
      location: json['location'],
      itemState: json['itemstate'],
      imageName: json['imagename'],
      status: json['status'],
      statusExplain: json['statusexplain'],
      appTime: DateTime.parse(json['apptime']),
      receptionTime: json['receptiontime'] == null
          ? null
          : DateTime.parse(json['receptiontime']),
      completionTime: json['completiontime'] == null
          ? null
          : DateTime.parse(json['completiontime']),
      etc: json['etc'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'grade': grade,
        'class': classNum,
        'teachername': teacherName,
        'item': item,
        'location': location,
        'itemstate': itemState,
        'imagename': imageName,
        'status': status,
        'statusexplain': statusExplain,
        'apptime': appTime!.toIso8601String(),
        'receptiontime': receptionTime!.toIso8601String(),
        'completiontime': completionTime!.toIso8601String(),
        'etc': etc
      };
}

// 외출증 자료
class OffCampusPassData {
  int? id;
  int? grade;
  int? classNum;
  int? number;
  String? name;
  String? reason;
  DateTime? startTime;
  DateTime? endTime;
  int? issuerGrade;
  int? issuerClass;
  int? issuerNumber;
  String? issuerName;

  OffCampusPassData(
      {this.id,
        this.grade,
        this.classNum,
        this.number,
        this.name,
        this.reason,
        this.startTime,
        this.endTime,
        this.issuerGrade,
        this.issuerClass,
        this.issuerNumber,
        this.issuerName});

  factory OffCampusPassData.fromJson(Map<String, dynamic> json) {
    return OffCampusPassData(
      id: int.parse(json['id']),
      grade: int.parse(json['grade']),
      classNum: int.parse(json['class']),
      number: int.parse(json['number']),
      name: json['name'],
      reason: json['reason'],
      startTime: DateTime.parse(json['starttime']),
      endTime: DateTime.parse(json['endtime']),
      issuerGrade: int.parse(json['issuergrade']),
      issuerClass: int.parse(json['issuerclass']),
      issuerNumber: int.parse(json['issuernumber']),
      issuerName: json['issuername'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'grade': grade,
    'class': classNum,
    'number': number,
    'name': name,
    'reason': reason,
    'starttime': startTime!.toIso8601String(),
    'endtime': endTime!.toIso8601String(),
    'issuergrade': issuerGrade,
    'issuerclass': issuerClass,
    'issuernumber': issuerNumber,
    'issuername': issuerName,
  };
}

// 좌석표 정보
class SeatingChartData {
  int id;
  int grade;
  int classNum;
  int number;
  String name;
  RxDouble x;
  RxDouble y;

  SeatingChartData(
      {required this.id,
        required this.grade,
        required this.classNum,
        required this.number,
        required this.name,
        double x=0,
        double y=0}): x=x.obs, y=y.obs;

  Map<String, dynamic> toJson() => {
    'id': id,
    'grade': grade,
    'class': classNum,
    'number': number,
    'name': name,
    'x': x.value,
    'y': y.value,
  };

  factory SeatingChartData.fromJson(Map<String, dynamic> json) =>
      SeatingChartData(
        id: int.parse(json['id']),
        grade: int.parse(json['grade']),
        classNum: int.parse(json['class']),
        number: int.parse(json['number']),
        name: json['name'],
        x: double.parse(json['x']),
        y: double.parse(json['y']),
      );
}

// 학습 태도  자료
class StudyAttitudeData {
  int? id;
  int? grade;
  int? classNum;
  int? number;
  String? name;
  int? studentGrade;
  int? studentClass;
  int? studentNumber;
  String? studentName;
  int? attitude;
  DateTime? time;

  StudyAttitudeData(
      {this.id,
        this.grade,
        this.classNum,
        this.number,
        this.name,
        this.studentGrade,
        this.studentClass,
        this.studentNumber,
        this.studentName,
        this.attitude,
        this.time});

  factory StudyAttitudeData.fromJson(Map<String, dynamic> json) {
    return StudyAttitudeData(
      id: int.parse(json['id']),
      grade: int.parse(json['grade']),
      classNum: int.parse(json['class']),
      number: int.parse(json['number']),
      name: json['name'],
      studentGrade: int.parse(json['studentgrade']),
      studentClass: int.parse(json['studentclass']),
      studentNumber: int.parse(json['studentnumber']),
      studentName: json['studentname'],
      attitude: int.parse(json['attitude']),
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'grade': grade,
    'class': classNum,
    'number': number,
    'name': name,
    'studentgrade': studentGrade,
    'studentclass': studentClass,
    'studentnumber': studentNumber,
    'studentname': studentName,
    'attitude': attitude,
    'time': time!.toIso8601String(),
  };
}

// 학습 태도 코드  자료
class StudyAttitudeCodeData {
  int? id;
  String? type;
  int? code;
  String? explain;

  StudyAttitudeCodeData(
      {this.id,
        this.type,
        this.code,
        this.explain
      });

  factory StudyAttitudeCodeData.fromJson(Map<String, dynamic> json) {
    return StudyAttitudeCodeData(
      id: int.parse(json['id']),
      type: json['type'],
      code: int.parse(json['code']),
      explain: json['explain'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'code': code,
    'explain': explain,
  };
}

class MealData {
  final String menu; // 요리명
  final String origin; // 원산지 정보
  final String calories;

  MealData({
    required this.menu,
    required this.origin,
    required this.calories,
  });

  // 빈 데이터를 표현하기 위한 팩토리 생성자
  factory MealData.empty() {
    return MealData(
      menu: '정보 없음',
      origin: '정보 없음',
      calories: '정보 없음',
    );
  }
}

// 네이버 뉴스 데이터
class News {
  final String title;
  final String originalLink;
  final String link;
  final String description;
  final DateTime pubDate;

  News({
    required this.title,
    required this.originalLink,
    required this.link,
    required this.description,
    required this.pubDate,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'].toString().replaceAll(RegExp(r'</?b>'), ''),
      originalLink: json['originallink'],
      link: json['link'],
      description: json['description'].toString().replaceAll(RegExp(r'</?b>'), ''),
      pubDate: DateFormat('EEE, dd MMM yyyy HH:mm:ss Z').parse(json['pubDate']),
    );
  }
}

// 사용자 정보
class CurrentUser {
  int? grade;
  int? classNum;
  int? number;
  String? name;
  String? usedApp;
  bool isNonHomeroomTeacher;
  bool isHomeroomTeacher;

  CurrentUser(
      {this.grade,
      this.classNum,
      this.number,
      this.name,
      this.usedApp,
      this.isNonHomeroomTeacher = false,
      this.isHomeroomTeacher = false});

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      grade: int.parse(json['grade']),
      classNum: int.parse(json['class']),
      number: int.parse(json['number']),
      name: json['name'] as String,
      usedApp: json['usedapp'] as String?
    );
  }
}
