import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;

  // true - 시간 / false - 내용
  final bool isTime;
  final FormFieldSetter<String> onSaved;

  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.onSaved,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isTime) renderTextField(),
        if (!isTime)
          Expanded(
            child: renderTextField(),
          ),
      ],
    );
  }

  Widget renderTextField() {
    // Form 이라는걸 써서 모든 텍스트필드를 통합 관리함
    // TextField X => TextFormField O
    return TextFormField(
      // 상위 Form에서 Save를 했을 때 불리게 됨
      // [저장] 버튼을 눌렀을 때 사용할거니까 외부에서 가져올 예정!
      onSaved: onSaved,
      // validator는 검증용으로 사용함
      // null 이 return되면 에러가 없다.
      // 만약 에러가 있으면 에러를 String 값으로 리턴해준다.
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return '값을 입력해주세요.';
        }
        if (isTime) {
          int time = int.parse(val);

          if (time < 0) {
            return '0 이상의 숫자를 입력해주세요';
          }

          if (time > 24) {
            return '24 이하의 숫자를 입력해주세요';
          }
          // maxLength를 쓰면 아래처럼 글자 제한을 할 필요가 없음
          // else {
          //   if (val.length > 500) {
          //     return '500자 이하의 글자를 입력해주세요.';
          //   }
          //}
        }

        return null;
      },
      cursorColor: Colors.grey,
      // 1을 넣으면 1줄만 가능, null을 넣으면 줄을 무한히 생성 가능
      maxLines: isTime ? 1 : null,
      expands: !isTime,
      maxLength: 500,
      // 최대 글자 제한
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime
          ? [
              FilteringTextInputFormatter.digitsOnly,
            ]
          : [],
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}
