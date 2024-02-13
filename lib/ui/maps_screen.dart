import 'package:flutter/material.dart';

import '../widgets/float_back_widget.dart';

class MapsScreen extends StatefulWidget {
  final Function() onHome;

  const MapsScreen({super.key, required this.onHome});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Ini adalah Map Screen'),
        ),
        floatingActionButton: FloatBackButton(onBack: widget.onHome),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      ),
    );
  }
}
