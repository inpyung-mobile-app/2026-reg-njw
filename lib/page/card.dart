import 'package:flutter/material.dart';
import 'package:untitled/controller/card_controller.dart';
import 'package:untitled/page/home.dart';

import '../util/base_widget.dart';
import '../util/util.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  final cardInfo = CardController.type == .love
      ? CardController.loveList[CardController.selected]
      : CardController.fruitList[CardController.selected];
  bool change = false;

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
      card(),
      beforeButton(),
      afterContent(),
      afterButton(),
    ],
  );

  Widget afterButton() => Positioned(
    left: 0,
    right: 0,
    bottom: 80,
    child: IgnorePointer(
      ignoring: change ? false : true,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: change ? 1 : 0,
        child: Row(
          mainAxisAlignment: .center,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: .circular(50),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          FadeTransition(opacity: animation, child: HomePage()),
                    ),
                    (route) => false,
                  );
                },
                child: Container(
                  alignment: .center,
                  decoration: BoxDecoration(
                    borderRadius: .circular(50),
                    color: Colors.white.withAlpha(15),
                  ),
                  padding: .symmetric(horizontal: 35, vertical: 13),
                  child: noto600Text('돌아가기', Colors.white, 17),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget afterContent() => Positioned(
    left: 45,
    right: 45,
    top: 380,
    child: IgnorePointer(
      ignoring: change ? false : true,
      child: AnimatedOpacity(
        opacity: change ? 1 : 0,
        duration: Duration(milliseconds: 500),
        child: SizedBox(
          height: 310,
          child: SingleChildScrollView(
            physics: PageScrollPhysics(),
            child: Text(
              '${cardInfo.storytelling.split('.').map((e) => e.trim()).join('.\n\n')}',
              style: TextStyle(
                color: Colors.white.withAlpha(220),
                fontSize: 15,
                fontFamily: noto,
                fontWeight: .w600,
                height: 1.6,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget beforeButton() => Positioned(
    left: 0,
    right: 0,
    bottom: 180,
    child: IgnorePointer(
      ignoring: change ? true : false,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: change ? 0 : 1,
        child: Row(
          mainAxisAlignment: .center,
          children: [
            Container(
              width: 160,
              height: 60,
              alignment: .center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: buttonColor,
                  begin: .topLeft,
                  end: .bottomCenter,
                  stops: [0.0, 0.9],
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
                    change = true;
                    setState(() {});
                  },
                  child: nanumText('결과 확인', Colors.white, 18),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget card() => AnimatedPositioned(
    left: 0,
    right: 0,
    top: change ? 170 : 270,
    duration: Duration(milliseconds: 550),
    curve: Curves.easeOutCubic,
    child: Center(
      child: Column(
        children: [
          Hero(
            tag: CardController.selected,
            child: AnimatedContainer(
              width: change ? 100 : 135,
              height: change ? 160 : 215,
              clipBehavior: .hardEdge,
              decoration: BoxDecoration(borderRadius: .circular(8)),
              curve: Curves.easeOutCubic,
              duration: Duration(milliseconds: 550),
              child: Image.asset(
                'assets/images/tarot_cards/${cardInfo.image}',
                fit: .cover,
              ),
            ),
          ),

          SizedBox(height: 12),

          nanumText('${cardInfo.number}, ${cardInfo.name}', Colors.white, 18),
        ],
      ),
    ),
  );

  Widget title() => Center(
    child: Column(
      children: [
        SizedBox(height: 60),
        SizedBox(width: 65, child: Image.asset('assets/images/graphic.png')),
        Transform.translate(
          offset: Offset(0, -10),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Container(
              key: ValueKey(change),
              height: 60,
              child: Text(
                textAlign: .center,
                change ? "카드풀이" : '아래의 타로카드를 선택하셨군요\n결과를 확인해보세요',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: .w700,
                  fontSize: 18,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
