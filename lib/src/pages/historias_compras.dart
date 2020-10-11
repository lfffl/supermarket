import 'package:flutter/material.dart';
import 'package:supermarket/src/bloc/producto_bloc.dart';
import 'package:supermarket/src/models/datos_basicos.dart';
import 'package:supermarket/src/providers/productoCarrito_provider.dart';

class HistorialCompras extends StatefulWidget {
  @override
  _HistorialComprasState createState() => _HistorialComprasState();
}

class _HistorialComprasState extends State<HistorialCompras> {
  DatosBasicos2 datosbasicos = new DatosBasicos2();
  ProductoBloc pbloc = new ProductoBloc();
  List<Factura> fac = new List<Factura>();

  @override
  Widget build(BuildContext context) {
    datosbasicos.datosBasicos = ModalRoute.of(context).settings.arguments;
    pbloc.setCarrito(datosbasicos.datosBasicos.clienteId);
    return Scaffold(
      appBar: AppBar(
        title: Text("Tu Historial de Compras"),
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
        return _crearLista(productos);
      },
    );
  }

  Widget _crearLista(List<ProductoCarrito> productos) {
    fac = _crearListaDeFacturas(productos);
    //print(fac.length);
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Fecha: ${fac[index].fecha}',
                style: TextStyle(color: Colors.blue),
              ),
              subtitle: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: '\nTotal: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                TextSpan(
                    text: '${fac[index].total} Bs',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 15.0))
              ])),
              isThreeLine: true,
              leading: Icon(Icons.format_list_bulleted),
              trailing: IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  datosbasicos.fecha = fac[index].fecha;
                  Navigator.pushNamed(context, 'DetalleHistorialCompras',
                      arguments: datosbasicos);
                },
              ),
            ),
            Divider()
          ],
        );
      },
      itemCount: fac.length,
    );
  }

  List<Factura> _crearListaDeFacturas(List<ProductoCarrito> productos) {
    fac.clear();
    List<String> fechas = new List<String>();
    productos.forEach((element) {
      if ((!fechas.contains(element.fecha)) && element.estado == 1) {
        //print('nueva fecha: ' + element.fecha);
        fechas.add(element.fecha);
      }
    });

    fechas.forEach((element) {
      Factura aux = new Factura();
      aux.fecha = element;

      productos.forEach((producto) {
        if (producto.fecha == aux.fecha) {
          aux.total += producto.precio;
        }
      });

      fac.add(aux);
    });
    return fac;
  }
}

class Factura {
  String fecha;
  double total = 0;
}

class DatosBasicos2 {
  DatosBasicos datosBasicos;
  String fecha;
}
