import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/controller/flow_controller.dart';
import 'package:untitled/page/flow/age_enter.dart';
import 'package:untitled/page/flow/birth_enter.dart';
import 'package:untitled/page/flow/birth_time_enter.dart';
import 'package:untitled/page/flow/check_enter.dart';
import 'package:untitled/page/flow/gender_enter.dart';
import 'package:untitled/page/flow/name_enter.dart';
import 'package:untitled/page/flow/start_enter.dart';
import 'package:untitled/util/util.dart';

import '../util/base_widget.dart';

class FlowPage extends StatefulWidget {
  const FlowPage({super.key});

  @override
  State<FlowPage> createState() => _FlowPageState();
}

class _FlowPageState extends State<FlowPage> {
  int prevIndex = 0;
  final List<String> titleText = [
    '운명을 엿볼 시간이에요.',
    '이름을 입력해주세요.',
    '나이를 입력해주세요.',
    '성별을 선택해주세요.',
    '태어난 날짜를 입력해주세요.',
    '태어난 시간을 입력해주세요.',
    '입력한 정보가 맞는지 확인해주세요.',
  ];

  bool showMoon = false;
  bool showCloud = false;
  bool showLogo = false;
  bool showGraphic = false;
  bool showText = false;
  bool showButton = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 1));

      showMoon = true;
      setState(() {});
      await Future.delayed(Duration(milliseconds: 700));

      showCloud = true;
      setState(() {});
      await Future.delayed(Duration(milliseconds: 900));

      showLogo = true;
      setState(() {});
      await Future.delayed(Duration(milliseconds: 700));

      showGraphic = true;
      setState(() {});
      await Future.delayed(Duration(milliseconds: 500));

      showText = true;
      setState(() {});
      await Future.delayed(Duration(milliseconds: 700));

      showButton = true;
      setState(() {});
    });
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

  Widget content() => ValueListenableBuilder(
    valueListenable: FlowController.pageIndex,
    builder: (context, value, child) => Stack(
      children: [
        moon(),
        cloud(),
        title(value),
        pages(value),
        gauge(value),
        prev(value),
      ],
    ),
  );

  Widget prev(value) => Positioned(
    left: 0,
    right: 0,
    bottom: 70,
    child: IgnorePointer(
      ignoring: value == 0 || value == 6 ? true : false,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 150),
        opacity: value == 0 || value == 6 ? 0 : 1,
        child: Row(
          mainAxisAlignment: .center,
          spacing: 15,
          children: FlowController.backIndex != null
              ? [
                  button(
                    () => FlowController.back(),
                    '정보 확인하기',
                    leftIcon: false,
                  ),
                ]
              : [
                  button(() => FlowController.pageIndex.value--, '이전'),
                  value == 5
                      ? button(
                          () => FlowController.pageIndex.value++,
                          '잘 모르겠어요',
                          leftIcon: false,
                        )
                      : SizedBox(),
                ],
        ),
      ),
    ),
  );

  Widget button(ontap, text, {leftIcon = true}) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: .circular(50),
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: .circular(50),
          color: Colors.white.withAlpha(15),
        ),
        padding: .only(
          left: leftIcon ? 12 : 22,
          right: leftIcon ? 22 : 12,
          bottom: 12,
          top: 12,
        ),
        child: Row(
          spacing: 4,
          mainAxisAlignment: .center,
          children: [
            leftIcon
                ? SvgPicture.asset('assets/icons/arrow.svg', width: 25)
                : SizedBox(),
            noto600Text(text, Colors.white, 18),
            !leftIcon
                ? Transform.flip(
                    flipX: true,
                    child: SvgPicture.asset(
                      'assets/icons/arrow.svg',
                      width: 25,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    ),
  );

  Widget gauge(value) => Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: Opacity(
      opacity: value == 0 || value == 6 ? 0 : 1,
      child: SafeArea(
        child: Container(
          height: 9,
          color: Colors.white.withAlpha(150),
          child: Row(
            spacing: 2,
            children: .generate(
              5,
              (index) => Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: index < value ? Colors.white : Colors.transparent,
                    borderRadius: .circular(9),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget pages(value) {
    final widget = [
      const StartEnter(),
      const NameEnter(),
      const AgeEnter(),
      const GenderEnter(),
      const BirthEnter(),
      const BirthTimeEnter(),
      const CheckEnter()
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      prevIndex = value;
    });

    return IgnorePointer(
      ignoring: showButton ? false : true,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 600),
        opacity: showButton ? 1 : 0,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 400),
          transitionBuilder: (child, animation) =>
              (value == 0 && prevIndex == 1) || (value == 1 && prevIndex == 0)
              ? FadeTransition(opacity: animation, child: child)
              : SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: Offset(0.12, 0),
                        end: Offset(0, 0),
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                  child: FadeTransition(opacity: animation, child: child),
                ),
          child: Stack(key: ValueKey(value), children: [widget[value]]),
        ),
      ),
    );
  }

  Widget title(value) => AnimatedPositioned(
    left: 0,
    right: 0,
    top: value == 0 ? 255 : 145,
    child: Column(
      children: [
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: showLogo ? 1 : 0,
          child: SizedBox(
            width: 210,
            child: Image.asset('assets/images/Daily Tarot.png'),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          transform: .translationValues(0, showGraphic ? -15 : 0, 0),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 150),
            opacity: showGraphic ? 1 : 0,
            child: SizedBox(
              width: 60,
              child: Image.asset('assets/images/graphic.png'),
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 450),
          transform: .translationValues(showText ? 0 : 15, -25, 0),
          curve: Curves.easeOutCirc,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 150),
            opacity: showText ? 1 : 0,
            child: nanumText(titleText[value], Colors.white, 18),
          ),
        ),
      ],
    ),
    duration: Duration(milliseconds: 400),
    curve: Curves.easeOutBack,
  );

  Widget cloud() => AnimatedPositioned(
    duration: Duration(milliseconds: 550),
    curve: Curves.easeOutCubic,
    left: 0,
    right: 0,
    bottom: showCloud ? 0 : -40,
    child: AnimatedOpacity(
      duration: Duration(milliseconds: 150),
      opacity: showCloud ? 1 : 0,
      child: cloudWidget(),
    ),
  );

  Widget moon() => Positioned(
    left: 0,
    top: 0,
    child: AnimatedOpacity(
      duration: Duration(milliseconds: 400),
      opacity: showMoon ? 1 : 0,
      child: SizedBox(width: 145, child: Image.asset('assets/images/moon.png')),
    ),
  );
}
