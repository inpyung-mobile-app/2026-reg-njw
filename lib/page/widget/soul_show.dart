import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:untitled/controller/soul_controller.dart';
import 'package:untitled/page/home.dart';
import 'package:untitled/util/base_widget.dart';

class SoulShow extends StatefulWidget {
  const SoulShow({super.key});

  @override
  State<SoulShow> createState() => _SoulShowState();
}

class _SoulShowState extends State<SoulShow> {
  final cardInfo = SoulController.soulList[SoulController.selected];
  final birth = SoulController.birth.value!;
  bool change = false;
  double angle = 0.0;
  bool opacity = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 1200));

      change = true;
      angle = -math.pi * 2;
      setState(() {});

      await Future.delayed(Duration(milliseconds: 100));
      opacity = true;
      setState(() {});
      await Future.delayed(Duration(milliseconds: 120));
      opacity = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: .symmetric(vertical: 55),
        child: Stack(
          children: [
            beforeTitle(),
            afterTitle(),
            card(),
            afterContent(),
            afterButton(),
          ],
        ),
      ),
    );
  }

  Widget afterButton() => Positioned(
    left: 0,
    right: 0,
    bottom: 25,
    child: IgnorePointer(
      ignoring: change ? false : true,
      child: AnimatedOpacity(
        opacity: change ? 1 : 0,
        duration: Duration(milliseconds: 350),
        child: GestureDetector(
          onTap: () {

            SoulController.birth.value = null;

            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    FadeTransition(opacity: animation, child: HomePage()),
              ),
              (route) => false,
            );
          },
          child: Center(
            child: Container(
              width: 55,
              height: 55,
              padding: .all(13),
              decoration: BoxDecoration(
                shape: .circle,
                border: .all(width: 1.2, color: Colors.white.withAlpha(100)),
              ),
              child: Stack(
                alignment: .center,
                children: [
                  Transform.rotate(
                    angle: math.pi / 4,
                    child: Container(width: 1.2, color: Colors.white),
                  ),
                  Transform.rotate(
                    angle: -math.pi / 4,
                    child: Container(width: 1.2, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget afterContent() => Positioned(
    left: 25,
    right: 25,
    top: 210,
    child: IgnorePointer(
      ignoring: change ? false : true,
      child: AnimatedOpacity(
        opacity: change ? 1 : 0,
        duration: Duration(milliseconds: 350),
        child: Container(
          height: 380,
          child: SingleChildScrollView(
            physics: PageScrollPhysics(),
            child: Text(
              textAlign: .center,
              '${cardInfo.storytelling.replaceAll('.', '.\n').replaceAll('관계,', '관계,\n').replaceAll('모습은', '모습은\n').replaceAll('따라', '따라\n').replaceAll('선택하고,', '선택하고,\n').replaceAll('발견하고', '발견하고\n').replaceAll('선택을 통해', '선택을 통해\n')}',
              style: TextStyle(
                letterSpacing: -0.8,
                color: Colors.white,
                fontWeight: .w700,
                fontSize: 16,
                height: 2,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget afterTitle() => Positioned(
    left: 155,
    top: -10,
    child: AnimatedOpacity(
      duration: Duration(milliseconds: 350),
      opacity: change ? 1 : 0,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Transform.translate(
            offset: Offset(-10, 10),
            child: SizedBox(
              width: 60,
              child: Image.asset('assets/images/graphic.png'),
            ),
          ),
          Transform.translate(
            offset: Offset(0, -5),
            child: nanumText(
              '${birth.year}년 ${birth.month}월 ${birth.day}일생,',
              Colors.white,
              16,
            ),
          ),
          SizedBox(height: 20),
          nanumText('당신의 소울카드는', Colors.white, 16),
          SizedBox(height: 10),
          nanumText(
            '${cardInfo.number}번 ${cardInfo.name} 입니다.',
            Colors.white,
            16,
          ),
        ],
      ),
    ),
  );

  Widget card() => AnimatedAlign(
    alignment: change ? .topLeft : .center,
    duration: Duration(milliseconds: 780),
    curve: Curves.easeOutCubic,
    child: TweenAnimationBuilder(
      duration: Duration(milliseconds: 700),
      curve: Curves.easeOut,
      tween: Tween<double>(begin: 0.0, end: angle),
      builder: (context, value, child) => Transform(
        alignment: .center,
        transform: .identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(value),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 120),
          opacity: opacity ? 0.4 : 1,
          child: AnimatedContainer(
            margin: .only(left: 25),
            width: change ? 115 : 220,
            height: change ? 160 : 315,
            clipBehavior: .hardEdge,
            decoration: BoxDecoration(borderRadius: .circular(14)),
            curve: Curves.easeOutCubic,
            duration: Duration(milliseconds: 700),
            child: Image.asset(
              'assets/images/tarot_cards/${cardInfo.image}',
              fit: .cover,
            ),
          ),
        ),
      ),
    ),
  );

  Widget beforeTitle() => Positioned(
    left: 0,
    right: 0,
    top: 15,
    child: AnimatedOpacity(
      opacity: change ? 0 : 1,
      duration: Duration(milliseconds: 350),
      child: Column(
        children: [
          SizedBox(width: 60, child: Image.asset('assets/images/graphic.png')),
          Transform.translate(
            offset: Offset(0, -10),
            child: nanumText(
              '${cardInfo.number}번 ${cardInfo.name}',
              Colors.white,
              20,
            ),
          ),
        ],
      ),
    ),
  );
}
