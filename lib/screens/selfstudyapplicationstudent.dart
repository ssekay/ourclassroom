import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/selfstudycontroller.dart';
import '../services/snackbar_service.dart';

class SelfStudyApplicationStudent extends StatefulWidget {
  const SelfStudyApplicationStudent({super.key});

  @override
  State<SelfStudyApplicationStudent> createState() => _SelfStudyApplicationStudentState();
}

class _SelfStudyApplicationStudentState extends State<SelfStudyApplicationStudent> {
  final selfStudyController = Get.put(SelfStudyController());
  final SnackBarService snackBarService = SnackBarService();
  final textStyle = const TextStyle(
    fontSize: 16,
  );
  final secondTextStyle = const TextStyle(
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자습신청'),
        centerTitle: true,
        actions: [
          Text(
            DateFormat('M월 d일(E)', 'ko_KR').format(DateTime.now()),
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            onPressed: () {
              setState(() {
                selfStudyController.fetchSelfStudyDay();
              });
            },
            icon: const Icon(Icons.refresh_rounded),
            iconSize: 30,
          ),
        ],
      ),
      body: Obx(() {
        if(selfStudyController.isLoadingSelfStudyDay.value || selfStudyController.isLoadingSelfStudyData.value) {
          return const Center(child: CircularProgressIndicator(),);
        } else {
          return !selfStudyController.isStudyDay.value
              ? const Center(child: Text('자습하지 않는 날입니다.'))
              : Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '8교시',
                          style: textStyle,
                        )),
                    const SizedBox(width: 40),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          selfStudyController.selectedChoiceString8.value,
                          style: textStyle,
                        )),
                  ],
                ),
                const SizedBox(height: 5),
                // 8교시 학교 / 귀가 선택
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    children: [
                      ChoiceChip(
                        showCheckmark: false,
                        label: Text('학교', style: textStyle),
                        color: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                              // Your logic to determine the color based on the states
                              if (states.contains(WidgetState.selected)) {
                                return Colors
                                    .blue[100]!; // Example: Blue when pressed
                              } else {
                                return Colors.white; // Example: Default color
                              }
                            }),
                        selected: selfStudyController.firstChoice8.value ==
                            '학교',
                        onSelected: (selected) {
                          if (selected) {
                            selfStudyController.updateFirstChoice8('학교');
                          } else {
                            selfStudyController.updateFirstChoice8('');
                          }
                         setState(() {
                           selfStudyController.selectedChoice8();
                         });
                        },
                      ),
                      ChoiceChip(
                        showCheckmark: false,
                        label: Text('귀가', style: textStyle),
                        color: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                              // Your logic to determine the color based on the states
                              if (states.contains(WidgetState.selected)) {
                                return Colors
                                    .blue[100]!; // Example: Blue when pressed
                              } else {
                                return Colors.white; // Example: Default color
                              }
                            }),
                        selected: selfStudyController.firstChoice8.value ==
                            '귀가',
                        onSelected: (selected) {
                          if (selected) {
                            selfStudyController.updateFirstChoice8('귀가');
                          } else {
                            selfStudyController.updateFirstChoice8('');
                          }
                          setState(() {
                            selfStudyController.selectedChoice8();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // 8교시 학교 선택 시
                selfStudyController.showSecondChoiceStudy8()
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: [
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('교실자습', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceStudy8.value ==
                                '교실자습',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceStudy8('교실자습');
                              setState(() {
                                selfStudyController.selectedChoice8();
                              });
                            },
                          ),
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('이동', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceStudy8.value ==
                                '이동',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceStudy8('이동');
                              setState(() {
                                selfStudyController.selectedChoice8();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                // 8교시 학교 선택 후 이동 선택 시
                selfStudyController.showThirdChoiceMove8()
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: [
                          // 상담
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('상담', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceMove8.value ==
                                '상담',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceMove8('상담');
                              setState(() {
                                selfStudyController.selectedChoice8();
                              });
                            },
                          ),
                          // 학교활동
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('학교활동', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceMove8.value ==
                                '학교활동',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceMove8('학교활동');
                              setState(() {
                                selfStudyController.selectedChoice8();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '야자 1차시',
                          style: textStyle,
                        )),
                    const SizedBox(width: 20),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          selfStudyController.selectedChoiceString1.value,
                          style: textStyle,
                        )),
                  ],
                ),
                const SizedBox(height: 5),
                // 야자 1차시 학교 / 귀가 선택
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    children: [
                      ChoiceChip(
                        showCheckmark: false,
                        label: Text('학교', style: textStyle),
                        color: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                              // Your logic to determine the color based on the states
                              if (states.contains(WidgetState.selected)) {
                                return Colors
                                    .blue[100]!; // Example: Blue when pressed
                              } else {
                                return Colors.white; // Example: Default color
                              }
                            }),
                        selected: selfStudyController.firstChoice1.value ==
                            '학교',
                        onSelected: (selected) {
                          if (selected) {
                            selfStudyController.updateFirstChoice1('학교');
                          } else {
                            selfStudyController.updateFirstChoice1('');
                          }
                          setState(() {
                            selfStudyController.selectedChoice1();
                          });
                        },
                      ),
                      ChoiceChip(
                        showCheckmark: false,
                        label: Text('귀가', style: textStyle),
                        color: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                              // Your logic to determine the color based on the states
                              if (states.contains(WidgetState.selected)) {
                                return Colors
                                    .blue[100]!; // Example: Blue when pressed
                              } else {
                                return Colors.white; // Example: Default color
                              }
                            }),
                        selected: selfStudyController.firstChoice1.value ==
                            '귀가',
                        onSelected: (selected) {
                          if (selected) {
                            selfStudyController.updateFirstChoice1('귀가');
                          } else {
                            selfStudyController.updateFirstChoice1('');
                          }
                          setState(() {
                            selfStudyController.selectedChoice1();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // 야자 1차시 학교 선택 시
                selfStudyController.showSecondChoiceStudy1()
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: [
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('교실자습', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceStudy1.value ==
                                '교실자습',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceStudy1('교실자습');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('이동', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceStudy1.value ==
                                '이동',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceStudy1('이동');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                // 야자 1차시 귀가 선택 시
                selfStudyController.showSecondChoiceReturn1()
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: [
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('학교 밖 자습', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceReturn1.value ==
                                '학교 밖 자습',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceReturn1('학교 밖 자습');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('학원/과외', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceReturn1.value ==
                                '학원/과외',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceReturn1('학원/과외');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('학교활동', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceReturn1.value ==
                                '학교활동',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceReturn1('학교활동');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('기타', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceReturn1.value ==
                                '기타',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceReturn1('기타');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                // 야자 1차시 학교 선택 후 이동 선택 시
                selfStudyController.showThirdChoiceMove1()
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: [
                          //상담
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('상담', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceMove1.value ==
                                '상담',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceMove1('상담');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                          // 학교활동
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('학교활동', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceMove1.value ==
                                '학교활동',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceMove1('학교활동');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                          // PMP실 이용
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('PMP실 이용', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceMove1.value ==
                                'PMP실 이용',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceMove1('PMP실 이용');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                          // 기타
                        ],
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                // 야자 1차시 귀가 선택 후 학원/과외 선택 시
                selfStudyController.showThirdChoiceReturn1()
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: [
                          //국어
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('국어', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceReturn1.value ==
                                '국어',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceReturn1('국어');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                          //영어
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('영어', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceReturn1.value ==
                                '영어',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceReturn1('영어');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                          //수학
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('수학', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceReturn1.value ==
                                '수학',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceReturn1('수학');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                          //전공어
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('전공어', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceReturn1.value ==
                                '전공어',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceReturn1('전공어');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                          //기타과목
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('기타과목', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceReturn1.value ==
                                '기타과목',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceReturn1('기타과목');
                              setState(() {
                                selfStudyController.selectedChoice1();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '야자 2차시',
                          style: textStyle,
                        )),
                    const SizedBox(width: 20),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          selfStudyController.selectedChoiceString2.value,
                          style: textStyle,
                        )),
                  ],
                ),
                const SizedBox(height: 5),
                // 야자 2차시 학교 / 귀가 선택
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    children: [
                      ChoiceChip(
                        showCheckmark: false,
                        label: Text('학교', style: textStyle),
                        color: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                              // Your logic to determine the color based on the states
                              if (states.contains(WidgetState.selected)) {
                                return Colors
                                    .blue[100]!; // Example: Blue when pressed
                              } else {
                                return Colors.white; // Example: Default color
                              }
                            }),
                        selected: selfStudyController.firstChoice2.value ==
                            '학교',
                        onSelected: (selected) {
                          if (selected) {
                            selfStudyController.updateFirstChoice2('학교');
                          } else {
                            selfStudyController.updateFirstChoice2('');
                          }
                          setState(() {
                            selfStudyController.selectedChoice2();
                          });
                        },
                      ),
                      ChoiceChip(
                        showCheckmark: false,
                        label: Text('귀가', style: textStyle),
                        color: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                              // Your logic to determine the color based on the states
                              if (states.contains(WidgetState.selected)) {
                                return Colors
                                    .blue[100]!; // Example: Blue when pressed
                              } else {
                                return Colors.white; // Example: Default color
                              }
                            }),
                        selected: selfStudyController.firstChoice2.value ==
                            '귀가',
                        onSelected: (selected) {
                          if (selected) {
                            selfStudyController.updateFirstChoice2('귀가');
                          } else {
                            selfStudyController.updateFirstChoice2('');
                          }
                          setState(() {
                            selfStudyController.selectedChoice2();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // 야자 2차시 학교 선택 시
                selfStudyController.showSecondChoiceStudy2()
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: [
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('교실자습', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceStudy2.value ==
                                '교실자습',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceStudy2('교실자습');
                              setState(() {
                                selfStudyController.selectedChoice2();
                              });
                            },
                          ),
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('이동', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceStudy2.value ==
                                '이동',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceStudy2('이동');
                              setState(() {
                                selfStudyController.selectedChoice2();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                // 야자 2차시 귀가 선택 시
                selfStudyController.showSecondChoiceReturn2()
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: [
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('학교 밖 자습', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceReturn2.value ==
                                '학교 밖 자습',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceReturn2('학교 밖 자습');
                              setState(() {
                                selfStudyController.selectedChoice2();
                              });
                            },
                          ),
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('학원/과외', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceReturn2.value ==
                                '학원/과외',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceReturn2('학원/과외');
                              setState(() {
                                selfStudyController.selectedChoice2();
                              });
                            },
                          ),
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('학교활동', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceReturn2.value ==
                                '학교활동',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceReturn2('학교활동');
                              setState(() {
                                selfStudyController.selectedChoice2();
                              });
                            },
                          ),
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('기타', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .secondChoiceReturn2.value ==
                                '기타',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateSecondChoiceReturn2('기타');
                              setState(() {
                                selfStudyController.selectedChoice2();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                // 야자 2차시 학교 선택 후 이동 선택 시
                selfStudyController.showThirdChoiceMove2()
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: [
                          //상담
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('상담', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceMove2.value ==
                                '상담',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceMove2('상담');
                              setState(() {
                                selfStudyController.selectedChoice2();
                              });
                            },
                          ),
                          // 학교활동
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('학교활동', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceMove2.value ==
                                '학교활동',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceMove2('학교활동');
                              setState(() {
                                selfStudyController.selectedChoice2();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                // 야자 2차시 귀가 선택 후 학원/과외 선택 시
                selfStudyController.showThirdChoiceReturn2()
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: [
                          //국어
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('국어', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceReturn2.value ==
                                '국어',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceReturn2('국어');
                              setState(() {
                                selfStudyController.selectedChoice2();
                              });
                            },
                          ),
                          //영어
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('영어', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceReturn2.value ==
                                '영어',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceReturn2('영어');
                              setState(() {
                                selfStudyController.selectedChoice2();
                              });
                            },
                          ),
                          //수학
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('수학', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceReturn2.value ==
                                '수학',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceReturn2('수학');
                              setState(() {
                                selfStudyController.selectedChoice2();
                              });
                            },
                          ),
                          //전공어
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('전공어', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceReturn2.value ==
                                '전공어',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceReturn2('전공어');
                              setState(() {
                                selfStudyController.selectedChoice2();
                              });
                            },
                          ),
                          //기타과목
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text('기타과목', style: secondTextStyle),
                            color: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Your logic to determine the color based on the states
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue[
                                    100]!; // Example: Blue when pressed
                                  } else {
                                    return Colors
                                        .white; // Example: Default color
                                  }
                                }),
                            selected: selfStudyController
                                .thirdChoiceReturn2.value ==
                                '기타과목',
                            onSelected: (selected) {
                              selfStudyController
                                  .updateThirdChoiceReturn2('기타과목');
                              setState(() {
                                selfStudyController.selectedChoice2();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (validateChoice()) {
                        // 자습 내용 저장 코드
                        if (DateTime
                            .now()
                            .hour >= 16) {
                          snackBarService.showCustomSnackBar(
                              '오후 4시 이후에 저장할 수 없습니다.', Colors.orange[200]!);
                          selfStudyController.fetchSelfStudyData();
                        } else {
                          if (selfStudyController.isTodayData.value) {
                            selectedCode();
                            selfStudyController.updateSelfStudyData();
                          } else {
                            selectedCode();
                            selfStudyController.submitSelfStudyData();
                            selfStudyController.isTodayData.value = true;
                          }
                        }
                      } else {
                        // 신청내용 확인 코드
                        snackBarService.showCustomSnackBar(
                            '빠진 항목이 있습니다. 신청내용을 확인하세요.', Colors.orange[200]!);
                      }
                    },
                    child: const Text('저 장'),
                  ),
                ),
              ],
            ),
          ),
        );
      }}),
    );
  }

  bool validateChoice() {
    // 8교시 확인
    if (selfStudyController.firstChoice8.value == '') {
      return false;
    } else if (selfStudyController.firstChoice8.value == '학교') {
      if (selfStudyController.secondChoiceStudy8.value == '') {
        return false;
      } else if (selfStudyController.secondChoiceStudy8.value == '이동') {
        if (selfStudyController.thirdChoiceMove8.value == '') {
          return false;
        }
      }
    }
    // 야자 1차시 확인
    if (selfStudyController.firstChoice1.value == '') {
      return false;
    } else if (selfStudyController.firstChoice1.value == '학교') {
      if (selfStudyController.secondChoiceStudy1.value == '') {
        return false;
      } else if (selfStudyController.secondChoiceStudy1.value == '이동') {
        if (selfStudyController.thirdChoiceMove1.value == '') {
          return false;
        }
      }
    } else if (selfStudyController.firstChoice1.value == '귀가') {
      if (selfStudyController.secondChoiceReturn1.value == '') {
        return false;
      } else if (selfStudyController.secondChoiceReturn1.value == '학원/과외') {
        if (selfStudyController.thirdChoiceReturn1.value == '') {
          return false;
        }
      }
    }
    // 야자2차시 확인
    if (selfStudyController.firstChoice2.value == '') {
      return false;
    } else if (selfStudyController.firstChoice2.value == '학교') {
      if (selfStudyController.secondChoiceStudy2.value == '') {
        return false;
      } else if (selfStudyController.secondChoiceStudy2.value == '이동') {
        if (selfStudyController.thirdChoiceMove2.value == '') {
          return false;
        }
      }
    } else if (selfStudyController.firstChoice2.value == '귀가') {
      if (selfStudyController.secondChoiceReturn2.value == '') {
        return false;
      } else if (selfStudyController.secondChoiceReturn2.value == '학원/과외') {
        if (selfStudyController.thirdChoiceReturn2.value == '') {
          return false;
        }
      }
    }
    return true;
  }

  void selectedCode() {
    selfStudyController.selected1.value = selfStudyController.selfStudyStringToCode[selfStudyController.selectedChoiceString8.value];
    selfStudyController.selected2.value = selfStudyController.selfStudyStringToCode[selfStudyController.selectedChoiceString1.value];
    selfStudyController.selected3.value = selfStudyController.selfStudyStringToCode[selfStudyController.selectedChoiceString2.value];
  }
}
