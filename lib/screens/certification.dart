import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authcontroller.dart';

class CertificationScreen extends StatefulWidget {
  const CertificationScreen({super.key});

  @override
  State<CertificationScreen> createState() => _CertificationScreenState();
}

class _CertificationScreenState extends State<CertificationScreen> {
  final _certificationNumberController = TextEditingController();

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('울반'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50,),
              const Text('학교에서 받은 인증번호를 입력하세요.'),
              const SizedBox(height:20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: TextField(
                  controller: _certificationNumberController,
                  decoration: const InputDecoration(
                    labelText: '인증번호',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _authController.checkCertificationNumber(_certificationNumberController.text);
                },
                child: const Text('확인'),
              ),
              const SizedBox(height: 20,),
              Obx(() {
                if (_authController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (_authController.message.value.isNotEmpty) {
                  return Center(child: Text(_authController.message.value));
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}