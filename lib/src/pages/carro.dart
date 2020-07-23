import 'package:flutter/material.dart';
import 'package:supermarket/src/bloc/producto_bloc.dart';
import 'package:supermarket/src/models/ProductoCarrito_model.dart';
import 'package:supermarket/src/models/datos_basicos.dart';

class CarritoPage extends StatefulWidget {
  @override
  _ComprasState createState() => _ComprasState();
}

class _ComprasState extends State<CarritoPage> {
  DatosBasicos datosbasicos;
  ProductoBloc pbloc;
  @override
  Widget build(BuildContext context) {
     pbloc = new ProductoBloc();
    datosbasicos = ModalRoute.of(context).settings.arguments;
    // pbloc.setCarrito(datosbasicos.clienteId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Tu carrito'),
      ),
      body: _crear(context),
    );
  }

  Widget _crear(BuildContext context) {
    return StreamBuilder(
      stream: pbloc.productoStream,
      builder: (context, AsyncSnapshot<List<ProductoCarrito>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final productos = snapshot.data;
        if (productos.length == 0) {
          return Center(
            child: Text('No Tienes ningun producto en tu carrito.'),
          );
        }
        return _crearLista(productos);
      },
    );
  }

  Widget _crearLista(List<ProductoCarrito> productos) {
    return ListView.builder(
        itemCount: productos.length,
        itemBuilder: (BuildContext context, i) {
          return Dismissible(
              key: null,
              background: Container(
                color: Colors.red,
              ),
              onDismissed: (direction) =>
                  pbloc.borrarProductosCarrito(productos[i].id),
              child: ListTile(
                title: Text(productos[i].nombre),
                subtitle: Text(productos[i].descripcion),
                leading: FadeInImage(
                    placeholder: AssetImage('assets/images/noimage.png'),
                    image: AssetImage('assets/images/noimage.png')),
                trailing: Text(
                  '${productos[i].precio} Bs',
                  style: TextStyle(fontSize: 25.0, color: Colors.black),
                ),
              ));
        });
  }
}
