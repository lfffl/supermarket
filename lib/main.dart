import 'package:flutter/material.dart';

import 'package:supermarket/src/pages/mapa_page.dart';
import 'package:supermarket/src/pages/login.dart';
import 'package:supermarket/src/pages/compras.dart';
import 'package:supermarket/src/pages/carro.dart';
import 'package:supermarket/src/pages/producto_page.dart';



void main() {
runApp(MyApp());
} 

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
        'mapa' : (BuildContext context) => MapaPage(),
        'login' : (BuildContext context) => LoginScreen(),
        'compras' : (BuildContext context)=>ComprasPage(),
        'carrito' : (BuildContext context)=> CarritoPage(),
        'producto':(BuildContext context)=> ProductoPage() 

      },
    );
  }



}
