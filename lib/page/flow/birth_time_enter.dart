import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:untitled/controller/flow_controller.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/util/base_widget.dart';
import 'package:untitled/util/util.dart';

class BirthTimeEnter extends StatefulWidget {
  const BirthTimeEnter({super.key});

  @override
  State<BirthTimeEnter> createState() => _BirthTimeEnterState();
}

class _BirthTimeEnterState extends State<BirthTimeEnter> {
  User get user => FlowController.user.value;

  DateTime get birth => FlowController.user.value.birth;
  final DateTime now = DateTime.now();

  bool timeChange = false;

  bool get isAM => birth.hour < 12;

  void APChange(bool toAM) {
    final h = birth.hour;
    final newHour = (h < 12 == toAM) ? h : (toAM ? h - 12 : h + 12);
    FlowController.user.value = FlowController.user.value.setDate(
      hour: newHour,
    );
    setState(() {});
  }

  double size = 190;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 25,
      right: 25,
      top: 300,
      child: Column(
        children: [
          title(),
          SizedBox(height: 30),
          clock(),
          SizedBox(height: 20),
          minute(),
        ],
      ),
    );
  }

  Widget minute() => IgnorePointer(
    ignoring: timeChange ? false : true,
    child: AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: timeChange ? 1 : 0,
      child: Column(
        children: [
          nanumText('분을 선택해주세요.', Colors.white, 20),
          SizedBox(height: 10),
          Row(
            spacing: 10,
            mainAxisAlignment: .center,
            children: .generate(6, (index) => minuteItem(index * 10)),
          ),
        ],
      ),
    ),
  );

  Widget minuteItem(value) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: .circular(45),
      onTap: () {
        FlowController.user.value = FlowController.user.value.setDate(minute: value);

        if (FlowController.backIndex != null) {
          FlowController.back();
          return;
        }

        FlowController.pageIndex.value++;
      },
      child: AnimatedContainer(
        width: 45,
        height: 45,
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: .circular(45),
          border: .all(
            width: 1.2,
            color: value == birth.minute ? Colors.white : Colors.transparent,
          ),
        ),
        child: Center(
          child: nanum600Text('${value}', Colors.white, 20),
        ),
      ),
    ),
  );

  Widget clock() => IgnorePointer(
    ignoring: timeChange ? true : false,
    child: AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: timeChange ? 0.5 : 1,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: .all(width: 1.2, color: Colors.white),
          shape: .circle,
        ),
        child: clockBody(),
      ),
    ),
  );

  Widget clockBody() => Stack(
    alignment: .center,
    children: [
      CircleAvatar(radius: 4, backgroundColor: Colors.white),
      hand(),
      numbers(),
    ],
  );

  Widget hand() {
    final h = birth.hour % 12 == 0 ? 12 : birth.hour % 12;
    final angle = (h / 12) * math.pi * 2 - (math.pi / 2);

    return Transform.rotate(
      angle: angle,
      child: Container(
        width: size,
        height: 1.2,
        padding: .symmetric(horizontal: 38),
        alignment: .centerRight,
        child: Container(width: size / 2 - 40, color: Colors.white),
      ),
    );
  }

  Widget numbers() => Stack(
    children: .generate(12, (index) {
      final angle = -(math.pi / 2) + index * (math.pi * 2 / 12);

      final center = size / 2;
      final radius = size / 2 - 20;

      final x = center + radius * math.cos(angle) - 21;
      final y = center + radius * math.sin(angle) - 21;
      final number = index == 0 ? 12 : index;

      return HourItem(number, x, y);
    }),
  );

  Widget HourItem(value, double x, double y) {
    final h = birth.hour % 12 == 0 ? 12 : birth.hour % 12;
    final newHour = isAM
        ? (value == 12 ? 0 : value)
        : (value == 12 ? 12 : value + 12);

    return Positioned(
      left: x,
      top: y,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: .circular(40),
          onTap: () {
            FlowController.user.value = FlowController.user.value.setDate(
              hour: newHour,
            );
            timeChange = true;
            setState(() {});
          },
          child: AnimatedContainer(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: .all(
                width: 1.2,
                color: value == h ? Colors.white : Colors.transparent,
              ),
              borderRadius: .circular(40),
            ),
            duration: Duration(milliseconds: 200),
            child: Center(child: nanum600Text('${value}', Colors.white, 18)),
          ),
        ),
      ),
    );
  }

  Widget title() => Row(
    mainAxisAlignment: .center,
    children: [changeTitle(), SizedBox(width: 10), toggle()],
  );

  Widget toggle() => ToggleButtons(
    children: [apItem(isAM, 'AM'), apItem(!isAM, 'PM')],
    isSelected: [isAM, !isAM],
    borderRadius: .circular(14),
    constraints: BoxConstraints(maxHeight: 26, maxWidth: 40),
    splashColor: Colors.white.withAlpha(80),
    borderColor: Colors.white.withAlpha(100),
    borderWidth: 1.2,
    direction: .vertical,
    disabledBorderColor: Colors.white.withAlpha(100),
    selectedBorderColor: Colors.white,
    onPressed: (index) {
      APChange(index == 0);
    },
  );

  Widget apItem(ap, text) => Center(
    child: nanum600Text(
      text,
      ap ? Colors.white : Colors.white.withAlpha(100),
      15,
    ),
  );

  Widget changeTitle() => Row(
    spacing: 15,
    children: [
      changeItem(false, '${DateFormat('hh').format(birth)}'),
      nanumText(':', Colors.white, 30),
      changeItem(true, '${DateFormat('mm').format(birth)}'),
    ],
  );

  Widget changeItem(change, text) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: .circular(14),
      onTap: () {
        timeChange = change;
        setState(() {});
      },
      child: AnimatedContainer(
        padding: .symmetric(
          horizontal: change == timeChange ? 14 : 0,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: .circular(14),
          border: .all(
            color: change == timeChange
                ? Colors.white.withAlpha(100)
                : Colors.transparent,
            width: 1.2,
          ),
        ),
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: nanum600Text(
          text,
          change == timeChange ? Colors.white : Colors.white.withAlpha(100),
          30,
        ),
      ),
    ),
  );
}
