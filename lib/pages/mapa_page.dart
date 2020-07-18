import 'package:flutter/material.dart';

class Mapapage extends StatefulWidget {
  @override
  _MapapageState createState() => _MapapageState();
}

class _MapapageState extends State<Mapapage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supermecados cercanos"),
      ),
    );
  }
}
