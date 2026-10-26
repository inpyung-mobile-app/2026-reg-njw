import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:untitled/page/widget/soul_picker.dart';
import 'package:untitled/page/widget/soul_show.dart';

import '../controller/soul_controller.dart';
import '../util/base_widget.dart';
import '../util/util.dart';

class SoulPage extends StatefulWidget {
  const SoulPage({super.key});

  @override
  State<SoulPage> createState() => _SoulPageState();
}

class _SoulPageState extends State<SoulPage> {
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
      soulContent(),
      prev(),
    ],
  );

  Widget soulContent() => Center(
    child: Column(
      children: [
        title(),
        SizedBox(height: 20),
        texts(),
        SizedBox(height: 30),
        birthInput(),
        SizedBox(height: 50),
        button(),
        SizedBox(height: 10),
        notoText('소울카드에 사용되는 정보는', Colors.white.withAlpha(80), 11),
        notoText('카드 조합 용도 외에 사용되지 않습니다.', Colors.white.withAlpha(80), 11),
      ],
    ),
  );

  Widget button() => Container(
    width: 290,
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
          if (SoulController.birth.value == null) {
            ShowSnackerBar(context, Icons.calendar_today, '먼저 생년월일을 선택해주세요!');
            return;
          }
          if (SoulController.moon.value < 10) {
            ShowSnackerBar(
              context,
              Icons.motion_photos_on_rounded,
              '달이 부족합니다!',
            );
            return;
          }

          final date = SoulController.birth.value!;
          int sum = date.year + date.month + date.day;

          while (sum > 9) {
            sum = sum
                .toString()
                .split('')
                .map((e) => int.parse(e))
                .reduce((a, b) => a + b);
          }
          print(sum);

          SoulController.selected = sum - 1;

          await SoulController.saveMoon(-10);
          await SoulController.getMoon();

          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  FadeTransition(opacity: animation, child: SoulShow()),
            ),
            (route) => false,
          );
        },
        child: Row(
          mainAxisAlignment: .center,
          children: [
            SizedBox(width: 35, child: Image.asset('assets/images/moon.png')),
            SizedBox(width: 6),
            nanumText('달 10개로 소울카드 찾기', Colors.white, 18),
            SizedBox(width: 10),
          ],
        ),
      ),
    ),
  );

  Widget birthInput() => GestureDetector(
    onTap: () {
      showDialog(context: context, builder: (context) => SoulPicker());
    },
    child: ValueListenableBuilder(
      valueListenable: SoulController.birth,
      builder: (context, value, child) => Container(
        width: 230,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: .circular(52),
          border: .all(color: Colors.white.withAlpha(150), width: 1.2),
        ),
        padding: .only(left: 25, right: 15),
        child: Row(
          mainAxisAlignment: .start,
          children: [
            noto600Text(
              '${value == null ? '생년월일을 선택해주세요' : '생일 : ${value.year}년 ${value.month}월 ${value.day}일'}',
              Colors.white.withAlpha(150),
              15,
            ),
            value != null
                ? SizedBox()
                : Transform.translate(
                    offset: Offset(10, 0),
                    child: Transform.flip(
                      flipX: true,
                      child: SvgPicture.asset(
                        'assets/icons/arrow.svg',
                        width: 17,
                        colorFilter: ColorFilter.mode(
                          Colors.white.withAlpha(180),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    ),
  );

  Widget texts() {
    final TextStyle mainStyle = TextStyle(
      color: Colors.yellow.shade600,
      fontSize: 13,
      fontWeight: .w600,
      fontFamily: noto,
      height: 2.3,
    );

    final TextStyle subStyle = TextStyle(
      color: Colors.white,
      fontSize: 13,
      fontWeight: .w600,
      fontFamily: noto,
      height: 2.3,
    );

    return Text.rich(
      textAlign: .center,
      TextSpan(
        children: [
          TextSpan(text: '소울 넘버', style: mainStyle),
          TextSpan(
            text:
                '는 생년월일의 각 숫자를 모두 더해\n얻는 최종적인 한 자리 숫자로,\n당신의 핵십적인 에너지와 삶의 테마를 나타냅니다.\n이 소울 넘버에 해당하는\n메이저 아르카나 타로카드가 바로 ',
            style: subStyle,
          ),
          TextSpan(text: '소울 카드', style: mainStyle),
          TextSpan(
            text: '이며,\n이는 당신의 타고난 성격, 기질,\n그리고 삶의 목적을 상징합니다.\n즉,소울 넘버는 당신의 ',
            style: subStyle,
          ),
          TextSpan(text: '영혼의 번호', style: mainStyle),
          TextSpan(text: '이고,\n소울 카드는 그 번호가 의미하는\n', style: subStyle),
          TextSpan(text: '영혼의 본질', style: mainStyle),
          TextSpan(text: '을 보여주는 상징인 셈입니다.', style: subStyle),
        ],
      ),
    );
  }

  Widget title() => Column(
    children: [
      SizedBox(height: 100),
      SizedBox(width: 65, child: Image.asset('assets/images/graphic.png')),
      Transform.translate(
        offset: Offset(0, -10),
        child: nanumText('나의 생일로 알아보는 소울카드', Colors.white, 20),
      ),
    ],
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
