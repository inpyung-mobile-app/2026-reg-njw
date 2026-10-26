import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/controller/flow_controller.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/util/base_widget.dart';
import 'package:untitled/util/util.dart';

class BirthEnter extends StatefulWidget {
  const BirthEnter({super.key});

  @override
  State<BirthEnter> createState() => _BirthEnterState();
}

class _BirthEnterState extends State<BirthEnter> {
  User get user => FlowController.user.value;

  DateTime get birth => FlowController.user.value.birth;
  final DateTime now = DateTime.now();

  List<DateTime> getDate(DateTime dates) {
    final first = DateTime(dates.year, dates.month, 1);
    final last = DateTime(dates.year, dates.month + 1, 0);
    final weekDays = first.weekday % 7;

    final total = weekDays + last.day;
    final totalSize = total > 35 ? 42 : 35;
    final nextDays = totalSize - total;

    List<DateTime> date = [];

    List.generate(
      weekDays,
      (index) => date.add(first.subtract(Duration(days: weekDays - index))),
    );
    List.generate(
      last.day,
      (index) => date.add(DateTime(dates.year, dates.month, index + 1)),
    );
    List.generate(
      nextDays,
      (index) => date.add(DateTime(dates.year, dates.month + 1, index + 1)),
    );

    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 25,
      right: 25,
      top: 300,
      child: Column(children: [title(), SizedBox(height: 10), calender()]),
    );
  }

  Widget calender() {
    final date = getDate(birth);

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 350),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child,),
      child: Container(
        key: ValueKey(birth.year + birth.month),
        height: 400,
        child: GridView(
          padding: .zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 2,
          ),
          children: .generate(date.length, (index) => days(date[index])),
        ),
      ),
    );
  }

  Widget days(DateTime value) {
    final selected =
        value.year == birth.year &&
        value.month == birth.month &&
        value.day == birth.day;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: .circular(50),
        onTap: () {
          if (value.year != now.year - user.age! + 1) {
            ShowSnackerBar(context, Icons.calendar_today, '날짜는 태어난 년도인 ${now.year - user.age! + 1}년도와 같아야합니다!');
            return;
          }
          if (value.isAfter(now)) {
            ShowSnackerBar(context, Icons.calendar_today, '날짜는 오늘 이후의 날짜를 선택하실 수 없습니다!');
            return;
          }

          FlowController.user.value = FlowController.user.value.setDate(year: value.year, month: value.month, day: value.day);

          if (FlowController.backIndex != null) {
            FlowController.back();
            return;
          }

          FlowController.pageIndex.value++;
        },
        child: AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: .circular(50),
            border: .all(
              width: 1.3,
              color: selected ? Colors.white : Colors.transparent,
            ),
          ),
          duration: Duration(milliseconds: 200),
          child: Center(
            child: nanum600Text(
              '${value.day}',
              value.month == birth.month
                  ? Colors.white
                  : Colors.white.withAlpha(100),
              19,
            ),
          ),
        ),
      ),
    );
  }

  Widget title() =>
      Row(mainAxisAlignment: .center, children: [year(), month(), Icon(Icons.arrow_drop_down, color: Colors.white, size: 25,)]);

  Widget year() => basePopUp(
    List.generate(119, (index) => item(now.year - index)),
    -10,
    (value) {
      FlowController.user.value = FlowController.user.value.setDate(
        year: value,
      );
      setState(() {});
    },
    '${birth.year}.',
  );

  Widget month() =>
      basePopUp(List.generate(12, (index) => item(index + 1)), 20, (value) {
        FlowController.user.value = FlowController.user.value.setDate(
          month: value,
        );
        setState(() {});
      }, '${birth.month}');

  PopupMenuItem item(value) => PopupMenuItem(
    value: value,
    child: Center(child: nanum600Text('${value}', Colors.white, 20)),
  );

  Widget basePopUp(list, double x, change, text) => PopupMenuButton(
    clipBehavior: .hardEdge,
    itemBuilder: (context) => list,
    offset: Offset(x, 38),
    color: background.first,
    constraints: BoxConstraints(maxWidth: 80, maxHeight: 300),
    onSelected: change,
    child: nanum600Text(text, Colors.white, 28),
  );
}
