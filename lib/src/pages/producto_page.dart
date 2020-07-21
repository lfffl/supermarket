import 'package:flutter/material.dart';
import 'package:supermarket/src/models/datos_basicos.dart';
import 'package:supermarket/src/providers/producto_provider.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  @override
  DatosBasicos datosbasicos;
  Widget build(BuildContext context) {
      datosbasicos = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(datosbasicos.supermercadoNombre),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, 'carrito', arguments: datosbasicos);
            },
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: _cargarlista2(),
    );
  }

  Widget _cargarlista(List<Producto> productos) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Text('${productos[index].nombre}',style: TextStyle(color: Colors.blue),),
              subtitle: Text('${productos[index].descripcion}'),
              
              trailing: Icon(Icons.add_shopping_cart,color: Colors.red,),
            ),
            Divider()
          ],
        );
      },
      itemCount: productos.length,
    );
  }

  Widget _cargarlista2() {
    final ProductoProvider ct = new ProductoProvider();
    // List<Producto> Productos = await ct.getAll();
    return FutureBuilder(
      future: ct.getProductosCategoria(datosbasicos.categoriaId),
      builder: (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
        if (snapshot.hasData) {
          return _cargarlista(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}