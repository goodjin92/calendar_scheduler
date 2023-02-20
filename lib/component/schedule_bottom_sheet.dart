import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  // null이 들어올 수 있는 이유? 처음에 아무 값도 안 넣었을때는 null이니까...
  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context)
        .viewInsets
        .bottom; // 시스템(키보드)이 가리고 있는 부분의 크기를 알 수 있음(double)

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Container(
            height:
                MediaQuery.of(context).size.height / 2 + bottomInset, // 화면의 반
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 8.0,
                ),
                // Form으로 감싸서 안에 있는 모든 것을 관리할 수 있음
                child: Form(
                  key: formKey,
                  // 사용자가 글씨를 한글자 한글자 쓸때마다 검증을 진행함
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Time(
                        onStartSaved: (String? val) {
                          // val! 을 줘서 null 값이 들어올수도 있게 하는 이유는
                          // 이미 validator에서 null이 들어오면 저장이 안되도록 설정했으니
                          // 절대 null이 들어올수가 없기 때문에
                          startTime = int.parse(val!);
                        },
                        onEndSaved: (String? val) {
                          endTime = int.parse(val!);
                        },
                      ),
                      SizedBox(height: 16.0),
                      _Content(
                        onSaved: (String? val) {
                          content = val;
                        },
                      ),
                      SizedBox(height: 16.0),
                      _ColorPicker(),
                      SizedBox(height: 8.0),
                      _SaveButton(
                        onPressed: onSavePressed,
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  void onSavePressed() {
    // formKey는 생성을 했는데, 위젯과 결합을 안 했을 때
    if (formKey.currentState == null) {
      return;
    }
    // validate가 실행되면 안에 있는 모든 validator가 실행되면서
    // 모두 null이 되었을 때 (= 에러가 없을 때), true를 내보냄
    // 그 중 하나라도 텍스트를 내보내면 (= 에러가 있을 때), false를 내보냄
    if (formKey.currentState!.validate()) {
      print('에러가 없습니다');
      formKey.currentState!.save();

      print('-------------------------');
      print('startTime : $startTime');
      print('endTime : $endTime');
      print('content : $content');
    } else {
      print('에러가 있습니다.');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;

  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: '시작 시간',
            isTime: true,
            onSaved: onStartSaved,
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: CustomTextField(
              label: '마감 시간', isTime: true, onSaved: onEndSaved),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;

  const _Content({
    required this.onSaved,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        isTime: false,
        onSaved: onSaved,
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Row를 쓰면 내용이 가득 차도 일자로 쭉 나아가지만,
    // Wrap을 쓰면 내용이 가득찰 때 아랫줄로 자동으로 내려감.
    return Wrap(
      spacing: 8.0, // 가로 간격
      runSpacing: 10.0, // 세로 간격
      children: [
        renderColor(Colors.red),
        renderColor(Colors.orange),
        renderColor(Colors.yellow),
        renderColor(Colors.green),
        renderColor(Colors.blue),
        renderColor(Colors.indigo),
        renderColor(Colors.purple),
      ],
    );
  }

  Widget renderColor(Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 32.0,
      height: 32.0,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            child: Text(
              '저장',
            ),
          ),
        ),
      ],
    );
  }
}
