import 'package:flutter/material.dart';
import 'package:untitled/controller/flow_controller.dart';
import 'package:untitled/controller/soul_controller.dart';
import 'package:untitled/util/base_widget.dart';
import 'package:untitled/util/util.dart';

class SoulPicker extends StatefulWidget {
  const SoulPicker({super.key});

  @override
  State<SoulPicker> createState() => _SoulPickerState();
}

class _SoulPickerState extends State<SoulPicker> {
  final DateTime now = DateTime.now();
  DateTime selected = DateTime(DateTime.now().year, 1, 1);

  final FixedExtentScrollController yearController =
      FixedExtentScrollController(initialItem: 100);

  int getDayCount(DateTime nowMonth) {
    return DateTime(nowMonth.year, nowMonth.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: sizew(context),
        padding: .symmetric(horizontal: 25),
        height: 310,
        decoration: BoxDecoration(
          borderRadius: .circular(16),
          gradient: LinearGradient(
            colors: background,
            begin: .topLeft,
            end: .bottomRight,
            stops: [0.1, 0.7],
          ),
        ),
        child: content(),
      ),
    );
  }

  Widget content() => Column(
    crossAxisAlignment: .start,
    children: [
      SizedBox(height: 20),
      noto600Text('생년월일 선택', Colors.white, 20),
      picker(),
      SizedBox(height: 15,),
      buttons()
    ],
  );

  Widget buttons() => Row(
    mainAxisAlignment: .end,
    children: [
      GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: noto600Text('취소', Colors.white, 18),
      ),
      SizedBox(width: 25,),
      GestureDetector(
        onTap: ()  {
          if (selected.isAfter(now)) {
            showDialog(context: context, builder: (context) => baseDialog(context, '생년월일은 오늘 이후의 날짜로 입력하실 수 없습니다.', '확인'),);
            return;
          }

          SoulController.birth.value = selected;
          Navigator.pop(context);
        },
        child: noto600Text('선택', Colors.white, 18),
      )
    ],
  );

  Widget picker() => Container(
    width: sizew(context),
    height: 190,
    margin: .only(top: 12),
    decoration: BoxDecoration(
      border: .symmetric(
        horizontal: BorderSide(width: 1.2, color: Colors.white.withAlpha(40)),
      ),
    ),
    child: Row(children: [Expanded(child: yearPicker()), Expanded(child: monthPicker()), Expanded(child: dayPicker())]),
  );

  Widget dayPicker() => basePicker(
    ListWheelChildLoopingListDelegate(
      children: .generate(
        getDayCount(selected),
            (index) => Center(
          child: noto600Text(
            '${(index + 1).toString().padLeft(2, '0')}',
            selected.day == index + 1
                ? Colors.white
                : Colors.white.withAlpha(100),
            22,
          ),
        ),
      ),
    ),
        (value) {
      selected = DateTime(selected.year, selected.month, value + 1);
      setState(() {});
    },
  );

  Widget monthPicker() => basePicker(
    ListWheelChildLoopingListDelegate(
      children: .generate(
        12,
            (index) => Center(
          child: noto600Text(
            '${(index + 1).toString().padLeft(2, '0')}',
            selected.month == index + 1
                ? Colors.white
                : Colors.white.withAlpha(100),
            22,
          ),
        ),
      ),
    ),
        (value) {
      selected = DateTime(selected.year, value + 1, selected.day);
      setState(() {});
    },
  );

  Widget yearPicker() => basePicker(
    ListWheelChildLoopingListDelegate(
      children: .generate(
        101,
        (index) => Center(
          child: noto600Text(
            '${now.year - 100 + index}',
            selected.year == now.year - 100 + index
                ? Colors.white
                : Colors.white.withAlpha(100),
            22,
          ),
        ),
      ),
    ),
    (value) {
      selected = DateTime((now.year - 100 + value).toInt(), selected.month, selected.day);
      setState(() {});
    },
    controller: yearController,
  );

  Widget basePicker(child, onChange, {controller}) =>
      Stack(
        alignment: .center,
        children: [
          ListWheelScrollView.useDelegate(
            itemExtent: 60,
            childDelegate: child,
            physics: FixedExtentScrollPhysics(),
            controller: controller,
            diameterRatio: 1000,
            perspective: 0.0001,
            onSelectedItemChanged: onChange,
          ),
          overlay()
        ],
      );

  Widget overlay() => IgnorePointer(
    ignoring: true,
    child: Container(
      height: 60,
      width: 15,
      decoration: BoxDecoration(
        border: .symmetric(horizontal: BorderSide(color: Colors.white.withAlpha(120), width: 2))
      ),
    ),
  );
}
