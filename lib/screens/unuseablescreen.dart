import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authcontroller.dart';

class UnUseAbleScreen extends StatefulWidget {

  const UnUseAbleScreen({super.key});

  @override
  State<UnUseAbleScreen> createState() => _UnUseAbleScreenState();
}

class _UnUseAbleScreenState extends State<UnUseAbleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('사용 권한 없음',style: TextStyle(fontSize: 24),),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/images/AppIcon.png',
                width: MediaQuery.of(context).size.width/ 2,
                height: MediaQuery.of(context).size.width/ 2,
              ),
              const SizedBox(height: 50),
              const Text('사용권한이 없습니다.',style: TextStyle(fontSize: 20),),
              const Text('관리자에게 문의하세요.',style: TextStyle(fontSize: 20),),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () {
                    Get.to(() => AuthController.to.handleAuth());
                  },
                  child: const Text('돌아가기')),
            ],
          ),
        ));
  }
}
