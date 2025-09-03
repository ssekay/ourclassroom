
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/numberscontroller.dart';

class Numbers extends StatefulWidget {
  const Numbers({super.key});

  @override
  State<Numbers> createState() => _NumbersState();
}

class _NumbersState extends State<Numbers> {
  final NumbersController controller = Get.put(NumbersController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numbers'),
      ),
      body: Obx((){
        if(controller.isLoading.value){
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.zero,
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Text(controller.numbersText.value),
          );
        }
      })
    );
  }
}
