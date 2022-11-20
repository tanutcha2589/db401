import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Shader(),
    );
  }
}

class Shader extends StatefulWidget {
  const Shader({super.key});

  @override
  State<Shader> createState() => _ShaderState();
}

class _ShaderState extends State<Shader> {
  int _shader = 854321; 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _paint(context, details);
          });
        },
        onVerticalDragUpdate: (details) {
          setState(() {
            _paint(context, details);
          });
        },
      child: Scaffold(
        backgroundColor: Color(0XFF000000 + _shader),
      ),
    );
  }
  void _paint(context, details) {
          double maxScr = MediaQuery.of(context).size.height;
          double yPos = details.globalPosition.dy;
          _shader = (yPos / maxScr * 16777215).round();
          if(_shader > 16777215) _shader = 16777215;
          print(_shader);
          
  }
}