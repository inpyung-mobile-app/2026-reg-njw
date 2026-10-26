import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/controller/flow_controller.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/util/base_widget.dart';
import 'package:untitled/util/util.dart';

class GenderEnter extends StatefulWidget {
  const GenderEnter({super.key});

  @override
  State<GenderEnter> createState() => _GenderEnterState();
}

class _GenderEnterState extends State<GenderEnter> {
  User get user => FlowController.user.value;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 50,
      right: 50,
      top: 380,
      child: Row(
        mainAxisAlignment: .center,
        children: [genderButton('F'), SizedBox(width: 25), genderButton('M')],
      ),
    );
  }

  Widget genderButton(gender) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: .circular(16),
      onTap: () async {
        final bool success = await showDialog(
          context: context,
          builder: (context) => baseAlertDialog(
            context,
            '\'${gender == 'F' ? '여성' : '남성'}\'을 선택하시겠습니까?',
            '취소',
            '확인',
          ),
        );

        if (!success) return;

        FlowController.user.value.gender = gender;

        if (FlowController.backIndex != null) {
          FlowController.back();
          return;
        }

        FlowController.pageIndex.value++;
      },
      child: AnimatedContainer(
        padding: .all(9),
        decoration: BoxDecoration(
          color: user.gender == gender ? Colors.white : Colors.transparent,
          borderRadius: .circular(16),
          border: .all(width: 1.3, color: Colors.white.withAlpha(200)),
        ),
        duration: Duration(milliseconds: 200),
        width: 75,
        height: 75,
        child: SvgPicture.asset(
          'assets/icons/${gender == 'F' ? 'fe' : ''}male.svg',
          colorFilter: ColorFilter.mode(
            user.gender == gender ? background.last : Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    ),
  );
}
