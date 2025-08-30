
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/mealcontroller.dart';

class MealTable extends StatefulWidget {
  const MealTable({super.key});

  @override
  State<MealTable> createState() => _MealTableState();
}

class _MealTableState extends State<MealTable> {
  final MealController mealController = Get.put(MealController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 급식'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
      child: Obx((){
        if(mealController.isLoading.value){
          return const Center(child: CircularProgressIndicator());
        }
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '중식 (${DateFormat('M월 d일 E요일','ko_KR').format( DateTime.now())})',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    mealController.lunch.value.calories,
                    style: TextStyle(fontSize: 16, color: Colors.amber.shade800, fontWeight: FontWeight.w600),
                  ),
                ),
                const Divider(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.restaurant_menu, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: '[메뉴] ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        children: [
                          TextSpan(
                            text: mealController.lunch.value.menu,
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
                const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.eco, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: '[원산지] ',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      children: [
                        TextSpan(
                          text: mealController.lunch.value.origin,
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
                const Divider(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.priority_high_outlined, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: '[알레르기 유발 식재료 번호] ',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          children: [
                            if( mealController.lunch.value.menu != '정보 없음')
                           const TextSpan(
                              text: '1.난류, 2.우유, 3.메밀, 4.땅콩, 5.대두, 6.밀, 7.고등어, 8.게, 9.새우, 10.돼지고기, 11.복숭아, 12.토마토, 13.아황산류, 14.호두, 15.닭고기, 16.쇠고기, 17.오징어, 18.조개류(굴, 전복, 홍합 포함), 19.잣',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            if( mealController.lunch.value.menu == '정보 없음')
                              const TextSpan(
                                text: '',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

      }),)
    );
  }
}
