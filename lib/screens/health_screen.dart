import 'package:flutter/material.dart';
import 'package:ourclassroom/screens/healthstudentlistteacher.dart';

import '../utils/constants.dart';
import 'healthliststudent.dart';
import 'healthalllistteacher.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  @override
  Widget build(BuildContext context) {
    return  Constants.currentUser.isHomeroomTeacher ?
        PageView(
            children: const [
              HealthAllListTeacher(),
              HealthStudentListTeacher(),
            ]) :
        PageView(
            children: const [
              HealthListStudent(),
            ]
    );
  }
}
