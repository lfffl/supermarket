import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:supermarket/src/bloc/producto_bloc.dart';
import 'package:supermarket/src/models/datos_basicos.dart';
import 'package:supermarket/src/providers/productoCarrito_provider.dart';
import 'package:supermarket/src/providers/producto_provider.dart';

class DataSearch extends SearchDelegate {
  ProductoBloc pbloc = new ProductoBloc();
  SpeechRecognition _speech;
  bool _isAvailable = false;
  bool _isListening = false;
  DatosBasicos datosBasicos;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.mic), onPressed: null),
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _cargarlista2();
  }

  Widget _cargarlista2() {
    final ProductoProvider ct = new ProductoProvider();
    // List<Producto> Productos = await ct.getAll();
    return FutureBuilder(
      future: ct.getAll(),
      builder: (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
        if (snapshot.hasData) {
          return _cargarlista(snapshot.data, context);
        } else {
          // return Center(child: CircularProgressIndicator());
          return Center(
            child:
                Text('No tenemos productos resultados para este producto :('),
          );
        }
      },
    );
  }

  Widget _cargarlista(List<Producto> productos, BuildContext context) {
    // print(categorias);

    productos.removeWhere((element) =>
        !element.nombre.toLowerCase().contains(query.toLowerCase()));
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        //String carp = _quitarSpacios(datosBasicos.nombrecategoria);
        //print(carp);
        //String dirImage = 'assets/productos/$carp/${productos[index].imagen}';
        //print(dirImage);

        String dirImage = existeArchivo(
            productos[index].imagen, productos[index].idcategoria);
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
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.15,
                  fit: BoxFit.fill,
                  placeholder: AssetImage('assets/images/noimage.png'),
                  image: AssetImage(dirImage)),
              trailing: IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  _insertarProductoCarritoBloc(
                      datosBasicos.clienteId, productos[index], context);
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

  String _quitarSpacios(String nomb) {
    return nomb.replaceAll(new RegExp(r' '), '_');
  }

  _insertarProductoCarritoBloc(
      int cliente, Producto producto, BuildContext context) {
    ProductoCarrito pc = new ProductoCarrito();
    String date = DateFormat("yyyy-MM-dd H:mm:ss").format(DateTime.now());
    pc.idcliente = cliente;
    pc.id = null;
    pc.nombre = producto.nombre;
    pc.precio = producto.precio;
    pc.descripcion = producto.descripcion;
    pc.imagen = producto.imagen;
    pc.idcategoria = producto.idcategoria;
    pc.estado = 0;
    pc.fecha = date;

    pbloc.agregarProductosCarrito(pc);

    Toast.show('${producto.nombre} agregado a tu carrito', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  void setDatosbasicos(DatosBasicos db) {
    datosBasicos = db;
    pbloc.setCarrito(datosBasicos.clienteId);
  }

  String existeArchivo(String dir, int idcat) {
    List<String> lista = [
      'Carnes_y_Embutidos',
      'Frutas_y_Verduras',
      'Panadería_y_Dulces',
      'Huevos,_Lácteos_y_Cafe',
      'Aceite,_Pastas',
      'Conservas_y_Comida_Preparada',
      'Zumos_y_Bebidas',
      'Aperitivos',
      'Infantil',
      'Cosmética_y_Cuidado_Personal',
      'Hogar_y_Limpieza'
    ];
    /*
    lista.forEach((element) {
      String dirImage = 'assets/productos/$element/$dir';

      if (File(dirImage).exists() != null) {
        print("direccion:" + dirImage);
        return rootBundle
            .load(dirImage)
            .then((_) => dirImage)
            .catchError(() => null);
      }
    });
    */
    String dirImage = 'assets/productos/${lista[idcat - 1]}/$dir';

    return dirImage;
  }
}
