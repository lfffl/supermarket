

import 'package:flutter/material.dart';
import 'package:supermarket/src/bloc/producto_bloc.dart';
import 'package:supermarket/src/models/datos_basicos.dart';
import 'package:supermarket/src/providers/productoCarrito_provider.dart';
import 'package:supermarket/src/providers/producto_provider.dart';
import 'package:toast/toast.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  @override
  DatosBasicos datosbasicos;
  ProductoBloc pbloc = new ProductoBloc();
  Widget build(BuildContext context) {
    datosbasicos = ModalRoute.of(context).settings.arguments;
    pbloc.setCarrito(datosbasicos.clienteId);
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
              title: Text(
                '${productos[index].nombre}',
                style: TextStyle(color: Colors.blue),
              ),
              subtitle: RichText(
                  text: TextSpan(
                      text: '${productos[index].descripcion}',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                    TextSpan(
                        text: '\nPrecio: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(
                        text: '${productos[index].precio} Bs',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 15.0))
                  ])),
              isThreeLine: true,
              leading: FadeInImage(
                  placeholder: AssetImage('assets/images/noimage.png'),
                  image: AssetImage('assets/images/noimage.png')),
              trailing: IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  _insertarProductoCarritoBloc(
                      datosbasicos.clienteId, productos[index]);
                },
              ),
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

  _insertarProductoCarritoBloc(int cliente, Producto producto) {
    ProductoCarrito pc = new ProductoCarrito();
    pc.idcliente = cliente;
    pc.id = null;
    pc.nombre = producto.nombre;
    pc.precio = producto.precio;
    pc.descripcion = producto.descripcion;
    pc.imagen = producto.imagen;
    pc.idcategoria = producto.idcategoria;

    pbloc.agregarProductosCarrito(pc);
    Toast.show('${producto.nombre} agregado a tu carrito', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}
