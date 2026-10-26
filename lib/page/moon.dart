import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../controller/soul_controller.dart';
import '../util/base_widget.dart';
import '../util/util.dart';

class MoonPage extends StatefulWidget {
  const MoonPage({super.key});

  @override
  State<MoonPage> createState() => _MoonPageState();
}

class _MoonPageState extends State<MoonPage> {
  final List<int> count = [25, 50, 75, 100, 200, 300];
  final List<int> discount = [750, 2600, 4750, 8000, 17000, 32000];
  final List<int> price = [7500, 9900, 14750, 17000, 33000, 55000];

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
      shopContent(),
      prev(),
    ],
  );

  Widget shopContent() => Center(child: Column(children: [title(), SizedBox(height: 20,), buy()]));

  Widget title() => Column(
    children: [
      SizedBox(height: 100),
      SizedBox(width: 65, child: Image.asset('assets/images/graphic.png')),
      Transform.translate(
        offset: Offset(0, -10),
        child: nanumText('달 충전', Colors.white, 20),
      ),
      SizedBox(height: 12),
      noto600Text('현재 보유중인 달', Colors.white, 18),
      SizedBox(height: 6),
      ValueListenableBuilder(
        valueListenable: SoulController.moon,
        builder: (context, value, child) => Row(
          mainAxisAlignment: .center,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(borderRadius: .circular(35)),
              child: Image.asset('assets/images/moon.png'),
            ),
            SizedBox(width: 5),
            notoText('${value}', Colors.white, 23),
          ],
        ),
      ),
    ],
  );

  Widget buy() => Padding(
    padding: .symmetric(horizontal: 20),
    child: Column(children: .generate(6, (index) => buyItem(index))),
  );

  Widget buyItem(index) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () async {
        final bool success = await showDialog(context: context, builder: (context) => baseAlertDialog(context, '달 ${count[index]}개를 구매하시겠습니까?', '취소', '구매하기'),);

        if (!success) return;

        await SoulController.saveMoon(count[index]);
        await SoulController.getMoon();
        await SoulController.massage('달 ${count[index]}개가 충전 되었습니다!');
      },
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          border: .fromLTRB(
            bottom: BorderSide(
              color: index >= 5
                  ? Colors.transparent
                  : Colors.white.withAlpha(60),
              width: 1.2,
            ),
          ),
        ),
        child: Row(
          children: [
            moonIcon(index),
            SizedBox(width: 15),
            priceItem(index),
            SizedBox(
              child: noto600Text(
                '${NumberFormat('#,###').format(price[index])}원',
                Colors.white.withAlpha(220),
                17,
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    ),
  );

  Widget priceItem(index) => Expanded(
    child: Column(
      crossAxisAlignment: .start,
      mainAxisAlignment: .center,
      children: [
        noto600Text('달 ${count[index]}개', Colors.white, 17),
        SizedBox(height: 2),
        noto500Text(
          '약 ${NumberFormat('#,###').format(discount[index])}원 할인',
          Colors.yellow.shade600,
          13,
        ),
      ],
    ),
  );

  Widget moonIcon(index) => Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      borderRadius: .circular(55),
      boxShadow: [BoxShadow(color: moonColor.withAlpha(30), blurRadius: 12)],
    ),
    child: Stack(
      alignment: .center,
      children: [
        index >= 4
            ? Positioned(
                right: 5,
                bottom: 5,
                child: Image.asset('assets/images/moon.png', width: 12),
              )
            : SizedBox(),
        index >= 2
            ? Positioned(
                right: 0,
                top: 2,
                child: Image.asset('assets/images/moon.png', width: 30),
              )
            : SizedBox(),
        Image.asset('assets/images/moon.png'),
      ],
    ),
  );

  Widget prev() => Positioned(
    left: 0,
    top: 0,
    child: SafeArea(
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: SvgPicture.asset('assets/icons/arrow.svg', width: 30),
      ),
    ),
  );
}
