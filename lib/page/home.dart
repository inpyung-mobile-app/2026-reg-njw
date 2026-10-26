import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/controller/soul_controller.dart';
import 'package:untitled/page/moon.dart';
import 'package:untitled/page/soul.dart';
import 'package:untitled/util/base_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Widget content() => Stack(children: [scroll(), moon()]);

  Widget scroll() => SingleChildScrollView(
    physics: RangeMaintainingScrollPhysics(),
    child: Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: -40,
          child: Transform.flip(flipY: true, child: cloudWidget()),
        ),
        Positioned(left: 0, right: 0, bottom: -40, child: cloudWidget()),
        scrollContent(),
      ],
    ),
  );

  Widget scrollContent() => Column(
    children: [
      title(),
      soulCard(),
      SizedBox(height: 40),
      tarotList(),
      SizedBox(height: 40),
      masterCard(),
      SizedBox(height: 120),
    ],
  );

  Widget tarotList() => Column(
    crossAxisAlignment: .start,
    children: [
      Padding(
        padding: .symmetric(horizontal: 20),
        child: nanumText('Daily Tarot List', Colors.white, 22),
      ),
      SizedBox(height: 12),
      SingleChildScrollView(
        padding: .symmetric(horizontal: 20),
        physics: RangeMaintainingScrollPhysics(),
        scrollDirection: .horizontal,
        child: Row(
          children: [tarotItem(.love), SizedBox(width: 15), tarotItem(.fruit)],
        ),
      ),
    ],
  );

  Widget tarotItem(TarotType type) {
    final img = type == .fruit ? 'fruit' : 'love';
    final title = type == .fruit ? '열매타로' : '인연타로';
    final subTitle1 = type == .fruit ? '지금 생각하고 있는 일은' : '지금은 힘들지만 그래도,';
    final subTitle2 = type == .fruit ? '어떤 결과로 이어질까?' : '그 사람과 인연이 될 수 있을까?';

    return Container(
      width: 200,
      clipBehavior: .hardEdge,
      decoration: BoxDecoration(borderRadius: .circular(16)),
      child: Stack(
        children: [
          Image.asset('assets/images/${img}_tarot.png'),
          Positioned(
            left: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                noto800Text(title, Colors.white, 19),
                SizedBox(height: 3),
                noto600Text(subTitle1, Colors.white, 13),
                noto600Text(subTitle2, Colors.white, 13),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await SoulController.massage('아직 준비중인 기능입니다!');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget masterCard() => Padding(
    padding: .symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: .start,
      children: [
        nanumText('Daily Master', Colors.white, 22),
        SizedBox(height: 12),
        Container(
          width: sizew(context),
          height: 200,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: buttonColor.first.withAlpha(100),
                blurRadius: 12,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: .circular(16),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/daily_master.png',
                    fit: .cover,
                  ),
                ),
                masterCardText(),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        try {
                          final success = await launchUrl(
                            Uri.parse('https://ko.wikipedia.org/wiki/타로'),
                          );

                          if (!success) {
                            ShowSnackerBar(
                              context,
                              Icons.wifi_off,
                              '페이지를 열지 못했습니다. 다시 시도해주세요.',
                            );
                            return;
                          }
                        } catch (e) {
                          ShowSnackerBar(
                            context,
                            Icons.wifi_off,
                            '연결을 확인하고 다시 시도해주세요.',
                          );
                          return;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget masterCardText() => Positioned(
    left: 15,
    top: 15,
    child: Column(
      crossAxisAlignment: .start,
      children: [
        nanumText('당신만을 위한 상담', Colors.white, 22),
        nanum600Text('당신을 위해 모인 \'데일리마스터\'와', Colors.white.withAlpha(220), 17),
        nanum600Text('직접 이야기를 나누어 보세요.', Colors.white.withAlpha(220), 17),
      ],
    ),
  );

  Widget soulCard() => Padding(
    padding: .symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: .start,
      children: [
        nanumText('Daily Tarot Soul Card', Colors.white, 20),
        SizedBox(height: 12),
        Container(
          width: sizew(context),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: buttonColor.first.withAlpha(100),
                blurRadius: 12,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: .circular(16),
            child: Stack(
              children: [
                Image.asset('assets/images/daily_tarot_soul_card.png'),
                soulCardText(),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(builder: (context) => SoulPage()),
                          (route) => true,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget soulCardText() => Positioned(
    right: 15,
    bottom: 15,
    child: Column(
      crossAxisAlignment: .end,
      children: [
        nanumText('Soul Card', Colors.white, 20),
        nanum600Text('운명적인 나만의 데일리 카드!', Colors.white.withAlpha(220), 14),
        nanum600Text('매일 하루를 카운셀링 받으세요.', Colors.white.withAlpha(220), 14),
      ],
    ),
  );

  Widget title() => Column(
    children: [
      SizedBox(height: 110),
      SizedBox(width: 220, child: Image.asset('assets/images/Daily Tarot.png')),
      Transform.translate(
        offset: Offset(0, -12),
        child: SizedBox(
          width: 60,
          child: Image.asset('assets/images/graphic.png'),
        ),
      ),
    ],
  );

  Widget moon() => Positioned(
    right: 20,
    top: 5,
    child: GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => MoonPage()),
          (route) => true,
        );
      },
      child: ValueListenableBuilder(
        valueListenable: SoulController.moon,
        builder: (context, value, child) => SafeArea(
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: .circular(35),
                  boxShadow: [
                    BoxShadow(color: moonColor.withAlpha(30), blurRadius: 12),
                  ],
                ),
                child: Image.asset('assets/images/moon.png'),
              ),
              notoText('${value}', Colors.white, 16),
            ],
          ),
        ),
      ),
    ),
  );
}
