import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authcontroller.dart';

class ErrorScreen extends StatefulWidget {
  final int errorCode;

  const ErrorScreen({super.key, required this.errorCode});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('접속 오류',style: TextStyle(fontSize: 24),),
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
              if (widget.errorCode == 1) const Text('서버에 접속할 수 없습니다.',style: TextStyle(fontSize: 20),),
              if (widget.errorCode == 2) const Text('네트워크를 확인해주세요.',style: TextStyle(fontSize: 20),),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () {
                    Get.to(() => AuthController.to.handleAuth());
                  },
                  child: const Text('다시 시도하기')),
            ],
          ),
        ));
  }
}
