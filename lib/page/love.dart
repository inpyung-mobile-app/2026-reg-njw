import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:untitled/controller/card_controller.dart';
import 'package:untitled/page/card.dart';

import '../util/base_widget.dart';
import '../util/util.dart';

class LovePage extends StatefulWidget {
  const LovePage({super.key});

  @override
  State<LovePage> createState() => _LovePageState();
}

class _LovePageState extends State<LovePage> {
  List<int> cardValues = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  int? selected;

  double center = 4;

  @override
  void initState() {
    super.initState();
    cardValues.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: back(),
    );
  }

  Widget back() => SizedBox.expand(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: background,
          begin: .topCenter,
          end: .bottomCenter,
          stops: [0.3, 0.7],
        ),
      ),
      child: content(),
    ),
  );

  Widget content() => Stack(
    children: [
      Positioned(
        left: 0,
        right: 0,
        top: -40,
        child: Transform.flip(flipY: true, child: cloudWidget()),
      ),
      Positioned(left: 0, right: 0, bottom: -40, child: cloudWidget()),
      title(),
      tarot(),
    ],
  );

  Widget tarot() => Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: SizedBox(height: 350, child: cardScroll()),
  );

  Widget cardScroll() => GestureDetector(
    onHorizontalDragUpdate: (details) {
      selected = null;
      center -= details.delta.dx / 70;
      center = center.clamp(0, 8);
      setState(() {});
    },
    child: SizedBox(
      height: 320,
      child: Stack(
        alignment: .bottomCenter,
        children: .generate(cardValues.length, (index) {
          final radius = index - center;
          final double angle = radius * 0.125;
          final double offsetY = math.pow(radius.abs(), 2) * 0.2;

          return card(index, angle, offsetY);
        }),
      ),
    ),
  );

  Widget card(index, double angle, double offsetY) => GestureDetector(
    onTap: () {
      if (selected == cardValues[index]) {
        CardController.selected = selected!;
        CardController.type = .love;

        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                FadeTransition(opacity: animation, child: CardPage()),
          ),
          (route) => false,
        );
        return;
      }

      selected = cardValues[index];
      setState(() {});
    },
    child: Hero(
      tag: cardValues[index],
      child: AnimatedContainer(
        width: 160,
        clipBehavior: .hardEdge,
        decoration: BoxDecoration(
          borderRadius: .circular(6),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 15),
          ],
        ),
        child: Image.asset('assets/images/tarot_card_back.png'),
        transform: .identity()
          ..translate(
            0.0,
            720.0 + offsetY + (selected == cardValues[index] ? -60.0 : 0.0),
          )
          ..rotateZ(angle)
          ..translate(0.0, -720.0),
        duration: Duration(milliseconds: 350),
        curve: Curves.easeOutCirc,
      ),
    ),
  );

  Widget title() => Center(
    child: Column(
      children: [
        SizedBox(height: 80),
        SizedBox(width: 65, child: Image.asset('assets/images/graphic.png')),
        Transform.translate(
          offset: Offset(0, -10),
          child: Column(
            children: [
              nanumText('인연 타로를 선택하셨군요.', Colors.white, 18),
              nanumText('신중하게 카드 1장을 선택해주세요.', Colors.white, 18),
              SizedBox(height: 6),
              notoText(
                '생각하고 있는 그 사람과 인연이 될 수 있을까요?',
                Colors.white.withAlpha(180),
                13,
              ),
            ],
          ),
        ),
        SizedBox(height: 150),
        noto600Text('좌우로 스크롤하여', Colors.white.withAlpha(200), 17),
        SizedBox(height: 6),
        noto600Text('카드 한 장을 골라보세요!', Colors.white.withAlpha(200), 17),
      ],
    ),
  );
}
