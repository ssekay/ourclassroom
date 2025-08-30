import 'package:flutter/material.dart';
import 'package:ourclassroom/screens/praiseallteacher.dart';
import 'package:ourclassroom/screens/praisemonthlyselectteacher.dart';

import '../utils/constants.dart';
import 'praiseallstudent.dart';
import 'praisegivestudent.dart';
import 'praisereceivestudent.dart';
import 'praiserelationshipstudent.dart';
import 'praiseadvicestudent.dart';

class PraiseScreen extends StatefulWidget {
  const PraiseScreen({super.key});

  @override
  State<PraiseScreen> createState() => _PraiseScreenState();
}

class _PraiseScreenState extends State<PraiseScreen> {
  @override
  Widget build(BuildContext context) {
    return Constants.currentUser.isHomeroomTeacher
        ? PageView(
            children: const [
              PraiseAllTeacher(),
              PraiseMonthlySelectTeacher()
            ],
          )
        : PageView(
            children: const [
              PraiseAllStudent(),
              PraiseGiveStudent(),
              PraiseReceiveStudent(),
              PraiseRelationshipStudent(),
              PraiseAdviceStudent(),
            ],
          );
  }
}
