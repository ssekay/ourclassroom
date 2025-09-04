
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For inputFormatters
import 'package:get/get.dart';

import '../controllers/numberscontroller.dart';

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
  final NumbersController controller = Get.put(NumbersController());
  SelectionType _selectedType = SelectionType.number; // 기본 선택

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  Widget _buildNumberTextField() {
    return TextField(
      textAlign: TextAlign.center,
      controller: _numberController,
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
              _numberController.clear();
            } else if (num > 9999) {
              _numberController.text = '9999';
              _numberController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _numberController.text.length));
            }
          }
        }
      },
    );
  }

  Widget _buildMonthTextField() {
    return Expanded(
      child: TextField(
        textAlign: TextAlign.center,
        controller: _monthController,
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
                 if(value != '0') _monthController.clear();
              } else if (month > 12) {
                _monthController.text = '12';
                 _monthController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _monthController.text.length));
              }
            }
          }
        },
      ),
    );
  }

  Widget _buildDayTextField() {
    return Expanded(
      child: TextField(
        textAlign: TextAlign.center,
        controller: _dayController,
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
                if(value != '0') _dayController.clear();
              } else if (day > 31) {
                _dayController.text = '31';
                _dayController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _dayController.text.length));
              }
            }
          }
        },
      ),
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
                      _numberController.clear();
                      _monthController.clear();
                      _dayController.clear();
                    });
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  selectedBorderColor: Theme.of(context).primaryColor,
                  selectedColor: Colors.white,
                  fillColor: Theme.of(context).primaryColor,
                  color: Theme.of(context).primaryColor,
                  constraints: BoxConstraints(
                    minHeight: 40.0,
                    minWidth: (MediaQuery.of(context).size.width - 48) / 2,
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(SelectionType.number.displayName),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(SelectionType.date.displayName),
                    ),
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
                  onPressed: () {
                    FocusScope.of(context).unfocus(); // 버튼 클릭 시 포커스 아웃
                    String valueToProcess = '';
                    bool isValid = true;
                    if (_selectedType == SelectionType.number) {
                      if (_numberController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('숫자를 입력해주세요.')),
                        );
                        isValid = false;
                      } else {
                        valueToProcess = '숫자: ${_numberController.text}';
                      }
                    } else { // SelectionType.date
                      if (_monthController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('월을 입력해주세요.')),
                        );
                        isValid = false;
                      } else if (_dayController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('일을 입력해주세요.')),
                        );
                        isValid = false;
                      } else {
                        valueToProcess = '날짜: ${_monthController.text}월 ${_dayController.text}일';
                      }
                    }

                    if (isValid) {
                      // For demonstration, show a snackbar with the processed value
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('입력된 값: $valueToProcess')),
                      );
                      // 여기에 controller.someMethod(valueToProcess) 와 같이 데이터 처리 로직 추가 가능
                    }
                  },
                  child: const Text('확인'),
                )
              ],
            ),
          )),
    );
  }
}
