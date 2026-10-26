import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:untitled/controller/flow_controller.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/page/home.dart';
import 'package:untitled/util/base_widget.dart';
import 'package:untitled/util/util.dart';

class CheckEnter extends StatefulWidget {
  const CheckEnter({super.key});

  @override
  State<CheckEnter> createState() => _CheckEnterState();
}

class _CheckEnterState extends State<CheckEnter> {
  User get user => FlowController.user.value;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 50,
      right: 50,
      top: 300,
      child: Column(
        spacing: 12,
        children: [
          check(1, '이름 : ${user.name}'),
          Row(
            children: [
              Expanded(child: check(2, '나이 : ${user.age}세')),
              SizedBox(width: 12),
              SizedBox(width: 50, child: check(3, '', useIcon: true)),
            ],
          ),
          check(4, '${DateFormat('생일 : yyyy.MM.dd').format(user.birth)}'),
          check(5, '${DateFormat('태어난 시간 : HH:mm').format(user.birth)}'),
          SizedBox(height: 30),
          button(),
        ],
      ),
    );
  }

  Widget button() => Container(
    width: 200,
    height: 60,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: buttonColor,
        begin: .topLeft,
        end: .bottomCenter,
        stops: [0.1, 0.9],
      ),
      boxShadow: [
        BoxShadow(
          color: buttonColor.first.withAlpha(60),
          blurRadius: 10,
          offset: Offset(0, 12),
        ),
      ],
      borderRadius: .circular(60),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: .circular(60),
        onTap: () async {
          final bool success = await showDialog(
            context: context,
            builder: (context) =>
                baseAlertDialog(context, '정말 입력하신 정보로\n하시겠습니까?', '닫기', '시작하기'),
          );

          if (!success) return;

          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  FadeTransition(opacity: animation, child: HomePage()),
            ),
            (route) => false,
          );
        },
        child: Row(
          mainAxisAlignment: .center,
          children: [
            nanumText('시작하기', Colors.white, 18),
            SizedBox(width: 3),
            Transform.flip(
              flipX: true,
              child: SvgPicture.asset('assets/icons/arrow.svg', width: 25),
            ),
          ],
        ),
      ),
    ),
  );

  Widget check(page, text, {useIcon = false}) => GestureDetector(
    onTap: () {
      FlowController.pageIndex.value = page;
      FlowController.backIndex = 6;
    },
    child: Container(
      width: sizew(context),
      height: 50,
      padding: .symmetric(horizontal: useIcon ? 4 : 25),
      decoration: BoxDecoration(
        borderRadius: .circular(50),
        border: .all(width: 1.2, color: Colors.white.withAlpha(180)),
      ),
      alignment: .centerLeft,
      child: useIcon
          ? SvgPicture.asset(
              'assets/icons/${user.gender == 'F' ? 'fe' : ''}male.svg',
            )
          : noto600Text(text, Colors.white, 15),
    ),
  );
}
