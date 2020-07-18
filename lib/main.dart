import 'package:flutter/material.dart';
import 'package:supermarket/src/pages/login.dart';
import 'package:supermarket/src/pages/mapa_page.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
      initialRoute: 'login',
      routes: <String, WidgetBuilder>{
        'mapa' : (BuildContext context) => Mapapage(),
        'login' : (BuildContext context) => LoginScreen(),
      },
    );
  }
}
