import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_app/ui/main/today/viewmodel/today_page_viewmodel.dart';
import '../../../../_core/constants/constants.dart';
import '../../../../data/dtos/user/user_request.dart';

void showInputModal(BuildContext context,WidgetRef ref) {

  showModalBottomSheet(

    context: context,
    isScrollControlled: true, // 키보드가 모달을 가리지 않도록 설정

    builder: (BuildContext context) {
      final _formKey = GlobalKey<FormState>();
      final _fat = TextEditingController();
      final _muscle = TextEditingController();
      final _weight = TextEditingController();

      return Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: kAccentColor2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kAccentColor2, width: 2.0),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          textTheme: TextTheme(
            titleMedium: TextStyle(color: kAccentColor2),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // 키보드로 인한 여백 조정
            left: 30,
            right: 30,
            top: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _fat,
                decoration: InputDecoration(
                  labelText: '체지방 (%)',
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: TColor.grey),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _muscle,
                decoration: InputDecoration(
                  labelText: '골격근 (%)',
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: TColor.grey),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _weight,
                decoration: InputDecoration(
                  labelText: '체중 (kg)',
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: TColor.grey),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor2,
                  foregroundColor: Colors.white,
                ),
                child: Text('저장'),
                onPressed: () {
                  bool isOk = _formKey.currentState!.validate();

                  if (isOk) {
                    double fat = double.tryParse(_fat.text) ?? 0.0;
                    double muscle = double.tryParse(_muscle.text) ?? 0.0;
                    double weight = double.tryParse(_weight.text) ?? 0.0;

                    UpdateBodyDataRequestDTO requestDTO =
                    UpdateBodyDataRequestDTO(fat, muscle, weight);

                    // ref.read(TodayPageProvider.notifier).notifyAddBodyData(requestDTO);




                  }


                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}