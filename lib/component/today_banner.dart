import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class TodayBanner extends StatelessWidget {
  final DateTime SelectedDay;
  final int scheduleCount;

  const TodayBanner({
    required this.SelectedDay,
    required this.scheduleCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${SelectedDay.year}년 ${SelectedDay.month}월 ${SelectedDay.day}일',
              style: textStyle,
            ),
            Text(
              '$scheduleCount개',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
