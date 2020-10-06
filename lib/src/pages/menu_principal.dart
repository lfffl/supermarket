import 'package:flutter/material.dart';
import 'package:supermarket/src/models/datos_basicos.dart';

class MenuP extends StatelessWidget {
  @override
  DatosBasicos datosBasicos;

  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text("Usuario"),
            accountEmail: new Text("User@email.com"),
            decoration: new BoxDecoration(color: Colors.blue),
            currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/nouser.png')),
            onDetailsPressed: () {},
          ),
          new ListTile(
              leading: Icon(Icons.format_list_numbered),
              title: new Text("Lista de compras"),
              onTap: () {
                Navigator.pop(context);
              }),
          new ListTile(
              leading: Icon(Icons.shopping_cart),
              title: new Text("Mi carrito"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'carrito', arguments: datosBasicos);
              }),
          new ListTile(
              leading: Icon(Icons.close),
              title: new Text("Cerrar sesión"),
              onTap: () {
                Navigator.pop(context);
                salida(context);
              }),
        ],
      ),
    );
  }

  void setDatosbasicos(DatosBasicos db) {
    datosBasicos = db;
  }

  void salida(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Esta seguro que quiere cerrar sesión?'),
                actions: <Widget>[
                  RaisedButton(
                      color: Colors.blue,
                      child: Text('Si'),
                      onPressed: () => Navigator.pushNamed(context, 'login')),
                  RaisedButton(
                      color: Colors.red,
                      child: Text('No'),
                      onPressed: () => Navigator.of(context).pop(false)),
                ]));
  }
}
