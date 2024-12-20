import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
        panEnabled: false, // Set it to false
        boundaryMargin: EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 2,
        child: Image(image: AssetImage('assets/plattegrond.png')));
  }
}
