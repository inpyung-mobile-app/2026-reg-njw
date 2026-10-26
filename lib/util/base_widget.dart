import 'package:flutter/material.dart';
import 'package:untitled/util/util.dart';

AlertDialog baseAlertDialog(context, text, closeText, okText) => AlertDialog(
  title: Center(
    child: SizedBox(
      width: 180,
      child: Image.asset('assets/images/Daily Tarot.png'),
    ),
  ),
  backgroundColor: background.first.withAlpha(220),
  content: Column(
    mainAxisSize: .min,
    children: [
      Text(
        textAlign: .center,
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: .w700,
          fontSize: 18,
          fontFamily: noto,
        ),
      ),
    ],
  ),
  actionsAlignment: .center,
  actions: [
    alterButton(context, false, closeText),
    SizedBox(width: 10),
    alterButton(context, true, okText),
  ],
);

Widget alterButton(context, success, text) => Container(
  width: 110,
  height: 45,
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: .circular(8),
      onTap: () {
        Navigator.pop(context, success);
      },
      child: Center(child: noto600Text(text, Colors.white, 15)),
    ),
  ),
  decoration: BoxDecoration(
    color: success ? buttonColor.first : null,
    borderRadius: .circular(8),
    boxShadow: [
      BoxShadow(
        color: buttonColor.first.withAlpha(100),
        offset: Offset(0, 8),
        blurRadius: 8,
      ),
    ],
    gradient: success
        ? null
        : LinearGradient(
            colors: background,
            begin: .topLeft,
            end: .bottomRight,
          ),
  ),
);

Text nanumText(text, color, double size) => Text(
  text,
  style: TextStyle(color: color, fontSize: size, fontWeight: .w700),
);

Text nanum600Text(text, color, double size) => Text(
  text,
  style: TextStyle(color: color, fontSize: size, fontWeight: .w600),
);

Text notoText(text, color, double size) => Text(
  text,
  style: TextStyle(
    color: color,
    fontSize: size,
    fontWeight: .w700,
    fontFamily: noto,
  ),
);

Text noto600Text(text, color, double size) => Text(
  text,
  style: TextStyle(
    color: color,
    fontSize: size,
    fontWeight: .w600,
    fontFamily: noto,
  ),
);

Text noto500Text(text, color, double size) => Text(
  text,
  style: TextStyle(
    color: color,
    fontSize: size,
    fontWeight: .w500,
    fontFamily: noto,
  ),
);

ShowSnackerBar(context, icon, text) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: .only(topLeft: .circular(30), topRight: .circular(30)),
        ),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 25),
            SizedBox(width: 10),
            noto600Text(text, Colors.white, 12),
          ],
        ),
      ),
    );

Widget cloudWidget() => SizedBox(
  height: 300,
  child: Stack(
    children: [
      cloudItem(-30, 100),
      cloudItem(-90, 60),
      cloudItem(185, 90, flip: true),
      cloudItem(175, 20, flip: true),
      cloudItem(0, -5),
    ],
  ),
);

Widget cloudItem(double right, double bottom, {flip = false}) => Positioned(
  right: right,
  bottom: bottom,
  child: Transform.flip(
    flipX: flip,
    child: SizedBox(width: 245, child: Image.asset('assets/images/cloud.png')),
  ),
);
