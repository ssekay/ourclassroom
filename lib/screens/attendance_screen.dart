import 'package:flutter/material.dart';
import 'package:ourclassroom/screens/attendancewriteteacher.dart';

import '../utils/constants.dart';
import 'attendanceliststudent.dart';
import 'attendancealllistteacher.dart';
import 'attendancstudentlistteacher.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Constants.currentUser.isHomeroomTeacher
        ? PageView(
            children: const [
              AttendanceWriteTeacher(),
              AttendanceAllListTeacher(),
              AttendanceStudentListTeacher()
            ],
          )
        : PageView(
            children: const [
              AttendanceListStudent(),
            ],
          );
  }
}
