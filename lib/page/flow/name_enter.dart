import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/controller/flow_controller.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/util/base_widget.dart';
import 'package:untitled/util/util.dart';

class NameEnter extends StatefulWidget {
  const NameEnter({super.key});

  @override
  State<NameEnter> createState() => _NameEnterState();
}

class _NameEnterState extends State<NameEnter> {
  User get user => FlowController.user.value;
  final TextEditingController name = TextEditingController(
    text: FlowController.user.value.name
  );

  void valid(String text) {
    if (text.isEmpty) {
      ShowSnackerBar(context, Icons.error, '이름을 입력해주세요!');
      return;
    }
    if (text.length < 3 || text.length > 20) {
      ShowSnackerBar(context, Icons.error, '이름은 최소 3자에서 최대 20자여야합니다!');
      return;
    }

    FlowController.user.value.name = text;

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
        baseFiled(context, name, '이름을 입력해주세요.', () => valid(name.text))
      ]),
    );
  }
  
  Widget baseFiled(context, TextEditingController controller, label, valid) => TextFormField(
    controller: controller,
    style: TextStyle(
      color: Colors.white,
      fontFamily: noto,
      fontSize: 15,
      fontWeight: .w600
    ),
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
