import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supermarket/src/bloc/producto_bloc.dart';
import 'package:supermarket/src/models/categoria_model.dart';
import 'package:supermarket/src/pages/historias_compras.dart';
import 'package:supermarket/src/providers/productoCarrito_provider.dart';
import 'package:supermarket/src/providers/producto_provider.dart';
import 'package:toast/toast.dart';

class DetalleHistoriaCompra extends StatefulWidget {
  @override
  _DetalleHistoriaCompraState createState() => _DetalleHistoriaCompraState();
}

class _DetalleHistoriaCompraState extends State<DetalleHistoriaCompra> {
  //List<ProductoCarrito> listap;
  DatosBasicos2 datosBasicos;
  double totalPagar = 0;
  List<Categoria> categorias;
  ProductoBloc pbloc = new ProductoBloc();
  @override
  Widget build(BuildContext context) {
    datosBasicos = ModalRoute.of(context).settings.arguments;
    pbloc.setCarrito(datosBasicos.datosBasicos.clienteId);
    return Scaffold(
      appBar: AppBar(
        title: Text("Tu detalle de Compra"),
      ),
      body: _crear(context),
    );
  }

  Widget _crear(BuildContext context) {
    print("activa esto");
    return StreamBuilder(
      stream: pbloc.productoStream,
      builder: (context, AsyncSnapshot<List<ProductoCarrito>> snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: Text('No tienes Historial de compras!.'),
          );
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final productos = snapshot.data;
        //listap = snapshot.data;
        if (productos.length == 0) {
          return Center(
            child: Text('No tienes Historial de compras.'),
          );
        }
        //_crearListaDeFacturas(productos);
        return _cargarlista(productos, context);
      },
    );
  }

  Widget _cargarlista(List<ProductoCarrito> productos, BuildContext context) {
    print(datosBasicos.fecha + "asdfasdf");
     productos.removeWhere((element) => !element.fecha.contains(datosBasicos.fecha));
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
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
                      )),
              isThreeLine: true,
              leading: FadeInImage(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.15,
                  fit: BoxFit.fill,
                  placeholder: AssetImage('assets/images/noimage.png'),
                  image: AssetImage(dirImage)),
              trailing: Text(
                    '${productos[index].precio} Bs',
                    style: TextStyle(fontSize: 25.0, color: Colors.black),
                  ),
            ),
            Divider()
          ],
        );
      },
      itemCount: productos.length,
    );
  }


  void setDatosbasicos(DatosBasicos2 db) {
    datosBasicos = db;
    pbloc.setCarrito(datosBasicos.datosBasicos.clienteId);
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
