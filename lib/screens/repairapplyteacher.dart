import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/repaircontroller.dart';
import '../models/models.dart';
import '../services/snackbar_service.dart';
import '../utils/constants.dart';

class RepairApplyTeacher extends StatefulWidget {
  final RepairData data;
  const RepairApplyTeacher({super.key, required this.data});

  @override
  State<RepairApplyTeacher> createState() => _RepairApplyTeacherState();
}

class _RepairApplyTeacherState extends State<RepairApplyTeacher> {
  final repairController = Get.put(RepairController());
  final statusExplainController = TextEditingController();
  final SnackBarService snackBarService = SnackBarService();

  @override
  void dispose() {
    statusExplainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('수리 신청 확인'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // 수리 대상
            Text('수리 대상 : ${widget.data.item}', style: const TextStyle(fontSize: 20)),
            const SizedBox(
              height: 10,
            ),
            // 수리 장소
            Text('장 소 : ${widget.data.location}', style: const TextStyle(fontSize: 20)),
            const SizedBox(
              height: 10,
            ),
            // 상태
            Text('상 태 : ${widget.data.itemState}', style: const TextStyle(fontSize: 20)),
            const SizedBox(
              height: 10,
            ),
            // 사진 입력
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                'http://61.83.221.128/aflhs_sdl/repair/${widget.data.imageName}',
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Center(
                      child: Icon(Icons.broken_image_outlined, size: 100));
                },
              ),
            ),
            const SizedBox(height: 10),
                TextField(
                  controller: statusExplainController,
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      labelText: '반려를 할 경우 이유를 써야합니다.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      )),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      widget.data.statusExplain = value;
                    }
                  },
                  textInputAction: TextInputAction.next,
                ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if(statusExplainController.text.isEmpty){
                      snackBarService.showCustomSnackBar('반려 이유를 입력해주세요.', Colors.orange[200]!);
                      return;
                    } else {
                      widget.data.teacherName = Constants.currentUser.name;
                      widget.data.status = 'return';
                      widget.data.statusExplain = statusExplainController.text;
                      widget.data.receptionTime = DateTime.now();
                      repairController.updateRepairData(widget.data.id!, widget.data);
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('반려'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.data.teacherName = Constants.currentUser.name;
                    widget.data.status = 'apply';
                    widget.data.appTime = DateTime.now();
                    repairController.updateRepairData(widget.data.id!, widget.data);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('신청'),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
