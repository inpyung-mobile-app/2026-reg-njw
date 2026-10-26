import 'package:flutter/material.dart';

import '../controller/card_controller.dart';
import '../util/base_widget.dart';
import '../util/util.dart';
import 'card.dart';

class FruitPage extends StatefulWidget {
  const FruitPage({super.key});

  @override
  State<FruitPage> createState() => _FruitPageState();
}

class _FruitPageState extends State<FruitPage> {
  List<int> cardValues = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  int? selected;
  bool cardShuffle = false;
  bool ignore = false;
  Duration time = Duration(milliseconds: 600);

  final List<Alignment> baseAlignment = [
    .topLeft,
    .topCenter,
    .topRight,
    .centerLeft,
    .center,
    .centerRight,
    .bottomLeft,
    .bottomCenter,
    .bottomRight,
  ];

  late List<Alignment> currentAlignment;

  @override
  void initState() {
    super.initState();
    currentAlignment = baseAlignment;
    cardValues.shuffle();
  }

  Future<void> shuffleCards() async {
    cardValues.shuffle();
    cardShuffle = true;
    selected = null;
    ignore = true;

    currentAlignment = .generate(currentAlignment.length, (index) => .center,);
    setState(() {});
    await Future.delayed(Duration(milliseconds: 750));

    time = Duration(milliseconds: 350);
    for (int i = 0; i < currentAlignment.length; i++) {
      currentAlignment[i] = baseAlignment[i];
      setState(() {});
      await Future.delayed(Duration(milliseconds: i == 4 ? 0 : 420));
    }
    time = Duration(milliseconds: 600);
    ignore = false;
    setState(() {});
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
      fruitContent(),
    ],
  );

  Widget fruitContent() =>
      Column(children: [title(), SizedBox(height: 30), tarot(), SizedBox(height: 60,), button()]);

  Widget button() => Row(
    mainAxisAlignment: .center,
    children: [
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: .circular(50),
          onTap: () async {
            await shuffleCards();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: .circular(50),
              color: Colors.white.withAlpha(15),
            ),
            alignment: .center,
            padding: .symmetric(horizontal: 30, vertical: 12),
            child: noto600Text('셔플', Colors.white, 18),
          ),
        ),
      ),
    ],
  );

  Widget tarot() => Padding(
    padding: .symmetric(horizontal: 60),
    child: IgnorePointer(
      ignoring: ignore,
      child: Container(
        height: 420,
        child: Stack(
          children: .generate(cardValues.length, (index) => card(index)),
        ),
      ),
    ),
  );

  Widget card(index) => AnimatedAlign(
    curve: Curves.easeOutCubic,
    alignment: currentAlignment[index],
    duration: time,
    child: GestureDetector(
      onTap: () {
        if (!cardShuffle) {
          ShowSnackerBar(context, Icons.touch_app_outlined, '먼저 셔플을 해주세요!');
          return;
        }

        if (selected == cardValues[index]) {
          CardController.selected = selected!;
          CardController.type = .fruit;

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
          transform: .translationValues(0, selected == cardValues[index] ? -30 : 0, 0),
          clipBehavior: .hardEdge,
          decoration: BoxDecoration(borderRadius: .circular(6)),
          width: 85,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          child: Image.asset('assets/images/tarot_card_back.png'),
        ),
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
          child: Column(
            children: [
              nanumText('열매 타로를 선택하셨네요.', Colors.white, 18),
              nanumText('신중하게 카드 1장을 선택해주세요.', Colors.white, 18),
              SizedBox(height: 6,),
              notoText('지금 생각하고 있는 일은 어떤 결과로 이어질까요?', Colors.white.withAlpha(180), 13)
            ],
          ),
        ),
      ],
    ),
  );
}
