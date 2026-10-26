import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/controller/flow_controller.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/util/base_widget.dart';
import 'package:untitled/util/util.dart';

class AgeEnter extends StatefulWidget {
  const AgeEnter({super.key});

  @override
  State<AgeEnter> createState() => _AgeEnterState();
}

class _AgeEnterState extends State<AgeEnter> {
  User get user => FlowController.user.value;
  final TextEditingController age = TextEditingController(
    text: FlowController.user.value.age == null ? '' : FlowController.user.value.age.toString()
  );
  
  void valid(String text) {
    if (text.isEmpty) {
      ShowSnackerBar(context, Icons.error, '나이를 입력해주세요!');
      return;
    }
    if (int.tryParse(text) == null) {
      ShowSnackerBar(context, Icons.error, '나이는 숫자만 입력이 가능합니다!');
      return;
    }
    if (int.parse(text) < 1 || int.parse(text) > 120) {
      ShowSnackerBar(context, Icons.error, '나이는 최소 1살에서 120살이내여야합니다!');
      return;
    }

    FlowController.user.value.age = int.parse(text);

    if (FlowController.backIndex != null) {
      FlowController.back();
      return;
    }

    FlowController.pageIndex.value++;
  }
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 50,
      right: 50,
      top: 300,
      child: Column(children: [
        baseFiled(context, age, '나이를 입력해주세요.', () => valid(age.text))
      ]),
    );
  }
  
  Widget baseFiled(context, TextEditingController controller, label, valid) => TextFormField(
    controller: controller,
    style: TextStyle(
      color: Colors.white,
      fontFamily: noto,
      fontSize: 15,
      fontWeight: .w700
    ),
    keyboardType: TextInputType.number,
    onTapUpOutside: (event) {
      FocusScope.of(context).unfocus();
    },
    onEditingComplete: () {
      valid();
      FocusScope.of(context).unfocus();
    },
    cursorColor: Colors.white,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(' '))
    ],
    decoration: InputDecoration(
      border: .none,
      hintText: label,
      hintStyle: TextStyle(
          color: Colors.white.withAlpha(150),
          fontFamily: noto,
          fontSize: 15,
          fontWeight: .w600
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: .circular(50),
        borderSide: BorderSide(width: 1.3, color: Colors.white)
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: .circular(50),
          borderSide: BorderSide(width: 1.3, color: Colors.white.withAlpha(180))
      ),
      contentPadding: .symmetric(horizontal: 25, vertical: 15)
    ),
  );
}
