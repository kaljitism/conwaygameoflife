import 'package:conwaygameoflife/world.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ConwayGameOfLife());
}

class ConwayGameOfLife extends StatelessWidget {
  const ConwayGameOfLife({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const World(),
    );
  }
}
