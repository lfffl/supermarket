import 'package:flutter/material.dart';
import 'package:supermarket/src/bloc/producto_bloc.dart';
import 'package:supermarket/src/models/ProductoCarrito_model.dart';
import 'package:supermarket/src/models/datos_basicos.dart';
import 'package:supermarket/src/providers/categoria_provider.dart';

class CarritoPage extends StatefulWidget {
  @override
  _ComprasState createState() => _ComprasState();
}

class _ComprasState extends State<CarritoPage> {
  DatosBasicos datosbasicos;
  List<Categoria> categorias;
  ProductoBloc pbloc = new ProductoBloc();
  @override
  void initState() {
    super.initState();
    _getcategoriasall();
  }

  @override
  Widget build(BuildContext context) {
    datosbasicos = ModalRoute.of(context).settings.arguments;
    pbloc.setCarrito(datosbasicos.clienteId);
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
        if (snapshot.data == null) {
          return Center(
            child: Text('No Tienes ningun producto en tu carrito.'),
          );
        }

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
        itemCount: productos.length + 2,
        itemBuilder: (BuildContext context, i) {
          if (i == 0) {
            return Container(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Para eliminar un producto de su carrito deslizalo a la izquierda o derecha.",
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          i -= 1;

          if (i < productos.length) {
            String carp = _quitarSpacios(categorias[productos[i].idcategoria-1].nombre);
            print(carp);
            String dirImage = 'assets/productos/$carp/${productos[i].imagen}';
            print(dirImage);

            return Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                ),
                onDismissed: (direction) =>
                    pbloc.borrarProductosCarrito(productos[i].id),
                child: ListTile(
                  title: Text(productos[i].nombre),
                  subtitle: Text(productos[i].descripcion),
                  leading: FadeInImage(
                      width: MediaQuery.of(context).size.width*0.2,
                      height: MediaQuery.of(context).size.height*0.15,
                      placeholder: AssetImage('assets/images/noimage.png'),
                      image: AssetImage(dirImage)),
                  trailing: Text(
                    '${productos[i].precio} Bs',
                    style: TextStyle(fontSize: 25.0, color: Colors.black),
                  ),
                ));
          } else {
            double cont = 0;
            productos.forEach((element) {
              cont += element.precio;
            });

            return Column(
              children: <Widget>[
                Divider(),
                ListTile(
                  title: Text('Total',
                      style: TextStyle(fontSize: 30.0, color: Colors.black)),
                  trailing: Text(
                    '${cont.toStringAsFixed(2)} Bs',
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ),
                ),
                Divider()
              ],
            );
          }
        });
  }

  Future<List<Categoria>> _getcategoriasall() async {
    List<Categoria> cate;
    CategoriaProvider cp = new CategoriaProvider();
    cate = await cp.getAll();
    categorias = cate;
    return cate;
  }

  String _quitarSpacios(String nomb) {
    return nomb.replaceAll(new RegExp(r' '), '_');
  }
}
