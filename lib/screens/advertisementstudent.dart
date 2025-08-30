import 'package:flutter/material.dart';

class AdvertisementStudent extends StatefulWidget {
  const AdvertisementStudent({super.key});

  @override
  State<AdvertisementStudent> createState() => _AdvertisementStudentState();
}

class _AdvertisementStudentState extends State<AdvertisementStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('광 고'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 2 / 3,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueGrey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Image.asset(
                  'assets/images/AppIcon.png'),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('AI로 생성한 이미지입니다.', style: TextStyle(fontSize: 10),),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Text('앱 개발 동아리', style: TextStyle(fontSize: 20),),
                  const SizedBox(height: 10,),
                  const Text('회 원 모 집', style: TextStyle(fontSize: 18),),
                  const SizedBox(height: 10,),
                  const Text('관심있는 학생, 선생님은 윤건영선생님에게 문의하세요.', style: TextStyle(fontSize: 16),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
