import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/controller/flow_controller.dart';
import 'package:untitled/util/base_widget.dart';
import 'package:untitled/util/util.dart';

class StartEnter extends StatefulWidget {
  const StartEnter({super.key});

  @override
  State<StartEnter> createState() => _StartEnterState();
}

class _StartEnterState extends State<StartEnter> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 290,
      child: Column(children: [button()]),
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
        onTap: () {
          if (FlowController.pageIndex.value == 0) {
            FlowController.pageIndex.value++;
          }
        },
        child: Row(
          mainAxisAlignment: .center,
          children: [
            nanumText('시작하기', Colors.white, 18),
            SizedBox(width: 3),
            Transform.flip(
              flipX: true,
              child: SvgPicture.asset('assets/icons/arrow.svg', width: 25,),
            ),
          ],
        ),
      ),
    ),
  );
}
