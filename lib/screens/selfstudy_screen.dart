
import 'package:flutter/material.dart';

import 'selfstudyliststudent.dart';
import 'selfstudylistteacher.dart';
import 'selfstudynonapplicantteacher.dart';
import 'selfstudytodaystatestudent.dart';
import 'selfstudyapplicationstudent.dart';
import 'selfstudytodaystateteacher.dart';
import '../utils/constants.dart';

class SelfStudyScreen extends StatefulWidget {
  const SelfStudyScreen({super.key});

  @override
  State<SelfStudyScreen> createState() => _SelfStudyScreenState();
}

class _SelfStudyScreenState extends State<SelfStudyScreen> {
  @override
  Widget build(BuildContext context) {
    return Constants.currentUser.isHomeroomTeacher ? PageView(
      children: const [
        SelfStudyTodayStateTeacher(),
        SelfStudyListTeacher(),
        SelfStudyNonApplicantTeacher(),
      ],
    ) : PageView(
      children: const [
        SelfStudyApplicationStudent(),
        SelfStudyListStudent(),
        SelfStudyTodayStateStudent(),
      ],
    );
  }
}
