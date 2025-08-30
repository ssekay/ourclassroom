
import 'package:flutter/material.dart';

import '../controllers/lostitemcontroller.dart';
import 'package:get/get.dart';

class LostItemList extends StatefulWidget {
  const LostItemList({super.key});

  @override
  State<LostItemList> createState() => _LostItemListState();
}

class _LostItemListState extends State<LostItemList> {
  LostItemController lostItemController = Get.put(LostItemController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('분실물 목록'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (lostItemController.isLostDataLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (lostItemController.lostData.isEmpty) {
          return const Center(child: Text('분실 목록이 없습니다.'));
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: lostItemController.lostData.length,
              itemBuilder: (context, index) {
                final lostData = lostItemController.lostData[index];
                return Card(
                  color: Colors.blue[200],
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10,),
                        Center(child: Text('ID : ${lostData.id}',style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                        const SizedBox(height: 10,),
                        Text(' 분실물 : ${lostData.item}',style: const TextStyle(fontSize: 18),),
                        const SizedBox(height: 10,),
                        lostData.image != null ?
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            'http://61.83.221.128/aflhs_sdl/lostandfoundmanagement/${lostData.image}',
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
                              if (loadingProgress == null) {
                                return child;
                              }
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return const Center(child: Icon(Icons.broken_image_outlined, size:100));
                            },
                          ),
                        ) : const SizedBox(height: 200, child: Center(child: Text('이미지가 없습니다.')),),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}
