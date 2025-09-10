
import 'package:flutter/material.dart';
import 'package:ourclassroom/screens/volunteeractivityalllistteacher.dart';
import 'package:ourclassroom/screens/volunteeractivityliststudent.dart';
import 'package:ourclassroom/screens/volunteeractivitystudentlistteacher.dart';

import '../utils/constants.dart';

class VolunteerActivityScreen extends StatefulWidget {
  const VolunteerActivityScreen({super.key});

  @override
  State<VolunteerActivityScreen> createState() => _VolunteerActivityScreenState();
}

class _VolunteerActivityScreenState extends State<VolunteerActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Constants.currentUser.isHomeroomTeacher ? PageView(
      children: const [
        VolunteerActivityAllListTeacher(),
        VolunteerActivityStudentListTeacher()
      ],
    ) : PageView(
      children: const [
        VolunteerActivityListStudent(),
      ],
    );
  }
}
