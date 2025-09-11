
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For inputFormatters
import 'package:get/get.dart';

import '../controllers/numberscontroller.dart';
import '../services/snackbar_service.dart';

enum SelectionType {
  number,
  date,
}

extension SelectionTypeExtension on SelectionType {
  String get displayName {
    switch (this) {
      case SelectionType.number:
        return '수';
      case SelectionType.date:
        return '날짜';
    }
  }
}

class Numbers extends StatefulWidget {
  const Numbers({super.key});

  @override
  State<Numbers> createState() => _NumbersState();
}

class _NumbersState extends State<Numbers> {
  final NumbersController numbersController = Get.put(NumbersController());
  final SnackBarService snackBarService = SnackBarService();
  SelectionType _selectedType = SelectionType.number; // 기본 선택

  final TextEditingController _numberTextController = TextEditingController();
  final TextEditingController _monthTextController = TextEditingController();
  final TextEditingController _dayTextController = TextEditingController();

  bool isValid = false;

  @override
  void dispose() {
    _numberTextController.dispose();
    _monthTextController.dispose();
    _dayTextController.dispose();
    super.dispose();
  }

  Widget _buildNumberTextField() {
    return TextField(
      textAlign: TextAlign.center,
      controller: _numberTextController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4), // 1-9999
      ],
      decoration: const InputDecoration(
        labelText: '숫자 (1-9999)',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          int? num = int.tryParse(value);
          if (num != null) {
            if (num < 1 && value.length == 1) {
              _numberTextController.clear();
            } else if (num > 9999) {
              _numberTextController.text = '9999';
              _numberTextController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _numberTextController.text.length));
            }
          }
        }
      },
    );
  }

  Widget _buildMonthTextField() {
    return TextField(
      textAlign: TextAlign.center,
      controller: _monthTextController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2), // 1-12
      ],
      decoration: const InputDecoration(
        labelText: '월 (1-12)',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          int? month = int.tryParse(value);
          if (month != null) {
            if (month < 1 && value.length <= 2) { // Allow '0' temporarily for typing '01' etc.
               if(value != '0') _monthTextController.clear();
            } else if (month > 12) {
              _monthTextController.text = '12';
               _monthTextController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _monthTextController.text.length));
            }
          }
        }
      },
    );
  }

  Widget _buildDayTextField() {
    return TextField(
      textAlign: TextAlign.center,
      controller: _dayTextController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2), // 1-31
      ],
      decoration: const InputDecoration(
        labelText: '일 (1-31)',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          int? day = int.tryParse(value);
          if (day != null) {
            if (day < 1 && value.length <=2) { // Allow '0' temporarily
              if(value != '0') _dayTextController.clear();
            } else if (day > 31) {
              _dayTextController.text = '31';
              _dayTextController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _dayTextController.text.length));
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( 
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Numbers'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('흥미로운 숫자 사실을 통해 의미를 부여하고 날짜에 스토리를 추가하세요.'),
                const SizedBox(height: 30),
                ToggleButtons(
                  isSelected: [
                    _selectedType == SelectionType.number,
                    _selectedType == SelectionType.date,
                  ],
                  onPressed: (int index) {
                    setState(() {
                      _selectedType = SelectionType.values[index];
                      _numberTextController.clear();
                      _monthTextController.clear();
                      _dayTextController.clear();
                    });
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  selectedBorderColor: Colors.blue,
                  selectedColor: Colors.white,
                  fillColor: Colors.blue,
                  color: Colors.blue,
                  constraints: BoxConstraints(
                    minHeight: 40.0,
                    minWidth: (MediaQuery.of(context).size.width - 48) / 2,
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(SelectionType.number.displayName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(SelectionType.date.displayName, style: const TextStyle(fontSize:16, fontWeight: FontWeight.bold),
                    ),),
                  ],
                ),
                const SizedBox(height: 30),
                if (_selectedType == SelectionType.number)
                  SizedBox(width : 200, child: _buildNumberTextField())
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 100, child: _buildMonthTextField()),
                      const SizedBox(width: 16),
                      SizedBox(width: 100, child: _buildDayTextField()),
                    ],
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus(); // 버튼 클릭 시 포커스 아웃
                    String valueToProcess = '';
                    if (_selectedType == SelectionType.number) {
                      if (_numberTextController.text.isEmpty) {
                        snackBarService.showCustomSnackBar('숫자를 입력해주세요.', Colors.orange[200]!);
                        isValid = false;
                      } else {
                        valueToProcess = _numberTextController.text;
                        isValid = true;
                      }
                    } else { // SelectionType.date
                      if (_monthTextController.text.isEmpty) {
                        snackBarService.showCustomSnackBar('월을 입력해주세요.', Colors.orange[200]!);
                        isValid = false;
                      } else if (_dayTextController.text.isEmpty) {
                        snackBarService.showCustomSnackBar('일을 입력해주세요.', Colors.orange[200]!);
                        isValid = false;
                      } else {
                        valueToProcess = '${_monthTextController.text}/${_dayTextController.text}';
                        isValid = true;
                      }
                    }
                    if (isValid) {
                      if(_selectedType == SelectionType.number) {
                        await numbersController.fetchNumbersData('$valueToProcess/math');
                        _numberTextController.clear();
                      } else{
                        await numbersController.fetchNumbersData('$valueToProcess/date');
                        _monthTextController.clear();
                        _dayTextController.clear();
                      }
                    }
                  },
                  child: const Text('확인'),
                ),
                const SizedBox(height: 50),
                if(isValid) Obx((){
                  if(numbersController.isLoading.value){
                    return const CircularProgressIndicator();
                  } else{
                    return Column(
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            Clipboard.setData(ClipboardData(text : numbersController.numbersText.value));
                          },
                          onDoubleTap: () {
                            setState(() {
                              isValid = false;
                              numbersController.numbersText.value = '';
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue[200],
                                borderRadius: const BorderRadius.all(Radius.circular(
                                    15)),
                              ),
                            child: Text(numbersController.numbersText.value, style: const TextStyle(fontSize: 18))
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('길게 누르면 클립보드에 복사됩니다.', style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
                        const SizedBox(height: 10),
                        const Text('더블탭하면 처음 화면으로 돌아갑니다.', style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
                      ],
                    );
                  }
                })

              ],
            ),
          )),
    );
  }
}
