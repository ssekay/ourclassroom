import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/repaircontroller.dart';
import '../models/models.dart';
import '../services/snackbar_service.dart';
import '../utils/constants.dart';

class RepairWriteStudent extends StatefulWidget {
  const RepairWriteStudent({super.key});

  @override
  State<RepairWriteStudent> createState() => _RepairWriteStudentState();
}

class _RepairWriteStudentState extends State<RepairWriteStudent> {
  final repairController = Get.put(RepairController());
  final SnackBarService snackBarService = SnackBarService();
  final GlobalKey<FormState> _repairFormKey = GlobalKey<FormState>();
  final itemController = TextEditingController();
  final locationController = TextEditingController();
  final itemStateController = TextEditingController();
  RepairData? repairData = RepairData();

  void _submitForm() async {
    if (_repairFormKey.currentState!.validate()) {
      _repairFormKey.currentState!.save();
      await repairController.insertRepairData(repairData!);
    } else {
      snackBarService.showCustomSnackBar('입력내용을 확인하세요.', Colors.orange[200]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('수리 신청'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _repairFormKey,
              child: Column(children: [
                // 수리 대상
                TextFormField(
                  controller: itemController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      labelText: '수리 대상',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '수대 대상을 입력하세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      repairData?.item = value;
                    }
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 10,
                ),
                // 수리 장소
                TextFormField(
                  controller: locationController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      labelText: '장 소',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '장소를 입력하세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      repairData?.location = value;
                    }
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 10,
                ),
                // 상태
                TextFormField(
                  controller: itemStateController,
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      labelText: '현재 상태를 구체적으로...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '현재 상태를 입력하세요..';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      repairData?.itemState = value;
                    }
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 10,
                ),
                // 사진 입력
                Obx(
                  () => Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                      color: repairController.selectedFile.value == null
                          ? Colors.white54
                          : Colors.transparent,
                    ),
                    child: repairController.selectedFile.value != null
                        ? Stack(
                            // 이미지를 표시하고, 위에 X 버튼을 추가하여 제거할 수 있도록 Stack 사용
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.file(
                                  repairController.selectedFile.value!,
                                  fit: BoxFit.cover,
                                  // 이미지가 잘리지 않게 Contain 또는 Cover 등 선택
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                // 이미지 제거 버튼
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: const Icon(Icons.close_rounded,
                                      color: Colors.white, size: 28),
                                  style: IconButton.styleFrom(
                                      backgroundColor: Colors.black),
                                  onPressed: () {
                                    repairController
                                        .clearSelectedFile(); // 선택된 이미지 제거 메서드 호출
                                  },
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  '수리 대상 사진',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      height: 50,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(
                                                double.infinity,
                                                double.infinity),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8), // 좌우 패딩 약간 주기
                                          ),
                                          onPressed: () {
                                            repairController.selectFile();
                                          },
                                          child: const Text(
                                            '사 진',
                                            style: TextStyle(fontSize: 16),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      height: 50,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(
                                                double.infinity,
                                                double.infinity),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8), // 좌우 패딩 약간 주기
                                          ),
                                          onPressed: () {
                                            repairController
                                                .pickImageFromCamera();
                                          },
                                          child: const Text(
                                            '카메라',
                                            style: TextStyle(fontSize: 16),
                                          )),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('취소'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (repairController.selectedFile.value != null) {
                          repairData?.teacherName = null;
                          repairData?.status = 'preapply';
                          repairData?.etc = Constants.currentUser.name;
                          _submitForm();
                          Get.back();
                        } else {
                          snackBarService.showCustomSnackBar(
                              '사진 파일을 선택해주세요.', Colors.orange[200]!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('신청'),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
