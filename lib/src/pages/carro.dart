import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supermarket/src/bloc/producto_bloc.dart';
import 'package:supermarket/src/models/ProductoCarrito_model.dart';
import 'package:supermarket/src/models/datos_basicos.dart';
import 'package:supermarket/src/providers/categoria_provider.dart';
import 'package:supermarket/src/providers/productoCarrito_provider.dart';

class CarritoPage extends StatefulWidget {
  @override
  _ComprasState createState() => _ComprasState();
}

class _ComprasState extends State<CarritoPage> {
  List<ProductoCarrito> listap;
  DatosBasicos datosbasicos;
  double totalPagar = 0;
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
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.fromLTRB(0.0, 0, 10, 10.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () {
            DateTime now = new DateTime.now();

            String date =
                DateFormat("yyyy-MM-dd H:mm:ss").format(DateTime.now());

            //String date = DateFormat("yyyy-MM-dd H:mm:ss").format(DateTime.now());

            print(date);

            print("en carrito confirm pago");
            _confirmacionPago();
          },
          label: Text("Pagar"),
          icon: Icon(Icons.monetization_on),
        ),
      ),
    );
  }

  void _confirmacionPago() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text(' Metodo de pago'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(children: <TextSpan>[
                        new TextSpan(
                            text: 'El total de su compra es : ',
                            style: TextStyle(color: Colors.black)),
                        new TextSpan(
                            text: totalPagar.toStringAsFixed(2),
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                        new TextSpan(
                            text: ' Bs', style: TextStyle(color: Colors.black))
                      ]),
                    )
                  ],
                ),
                actions: <Widget>[
                  RaisedButton(
                      child: Text('Tarjeta'),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        _realizarPago();
                      }),
                  RaisedButton(
                      child: Text('Efectivo'),
                      color: Colors.green,
                      onPressed: () => Navigator.of(context).pop(true)),
                  RaisedButton(
                      child: Text('Cancelar'),
                      color: Colors.red,
                      onPressed: () => Navigator.of(context).pop(false)),
                ]));
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
        listap = snapshot.data;
        return _crearLista(productos);
      },
    );
  }

  Widget _crearLista(List<ProductoCarrito> productos) {
    String tex = 'No Tienes ningun producto en tu carrito.';
    productos.forEach((element) {
      if (element.estado == 0) {
        tex = "Para eliminar un producto de su carrito deslizalo a la izquierda o derecha.";
      }
    });

    return ListView.builder(
        itemCount: productos.length + 2,
        itemBuilder: (BuildContext context, i) {
          if (i == 0) {
            return Container(
              padding: EdgeInsets.all(15.0),
              child: Text(
                tex,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          i -= 1;

          if (i < productos.length && productos[i].estado == 0) {
            String carp =
                _quitarSpacios(categorias[productos[i].idcategoria - 1].nombre);
            //print(carp);
            String dirImage = 'assets/productos/$carp/${productos[i].imagen}';
            // print(dirImage);

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
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.15,
                      placeholder: AssetImage('assets/images/noimage.png'),
                      image: AssetImage(dirImage)),
                  trailing: Text(
                    '${productos[i].precio} Bs',
                    style: TextStyle(fontSize: 25.0, color: Colors.black),
                  ),
                ));
          }
          if (i < productos.length && productos[i].estado == 1) {
            return Container();
          }
          if (i >= productos.length) {
            double cont = 0;
            productos.forEach((element) {
              if (element.estado == 0) {
                cont += element.precio;
              }
            });
            totalPagar = cont;
            if (totalPagar == 0) {
              tex = 'No Tienes ningun producto en tu carrito.';
            } else {
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
          }
          return Container();
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

  void _realizarPago() {
    //ProductoCarritoProvider pc = new ProductoCarritoProvider();
    String date = DateFormat("yyyy-MM-dd H:mm:ss").format(DateTime.now());
    listap.forEach((element) {
      if (element.estado == 0) {
        element.fecha = date;
        element.estado = 1;
        element.idcliente = datosbasicos.clienteId;
        pbloc.updateProductoCarrito(element);
      }
    });
    //pbloc.obtenerProductosCarrito();
  }
}
