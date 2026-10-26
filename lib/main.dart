import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/page/flow.dart';
import 'package:untitled/util/util.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: nanum,
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const FlowPage(),
    );
  }
}