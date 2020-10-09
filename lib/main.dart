import 'package:flutter/material.dart';
import 'package:supermarket/src/pages/historias_compras.dart';

import 'package:supermarket/src/pages/mapa_page.dart';
import 'package:supermarket/src/pages/login.dart';
import 'package:supermarket/src/pages/categorias.dart';
import 'package:supermarket/src/pages/carro.dart';
import 'package:supermarket/src/pages/lista_productos_page.dart';



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
        'catergorias' : (BuildContext context)=>CategoriasPage(),
        'carrito' : (BuildContext context)=> CarritoPage(),
        'listaproductos':(BuildContext context)=> ListaProductosPage(),
        'HistorialCompras':(BuildContext context)=> HistorialCompras() 

      },
    );
  }



}
