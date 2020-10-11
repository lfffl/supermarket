import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supermarket/src/models/datos_basicos.dart';
import 'package:supermarket/src/pages/menu_principal.dart';
import 'package:supermarket/src/providers/supermercado_provider.dart';
import 'package:supermarket/src/utils/calculos_mapas.dart';
import 'package:toast/toast.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapaPage extends StatefulWidget {
  @override
  State<MapaPage> createState() => MapaPageState();
}

class MapaPageState extends State<MapaPage> {
  Completer<GoogleMapController> _controller = Completer();
  MenuP menup;
  double zoom = 14.4746;
  Set<Marker> _markers = Set();
  List<Supermercado> listaSuper = [];
  DatosBasicos datosbasicos;
  String botonTexto = "Comprar";
  Supermercado botonSupermercado;
  Location location = new Location();
  LocationData _locationData;
  final Set<Polyline> _polyline = {};
  String _mapStyle;
  GoogleMapController mapController;

  // LocationData _locationData;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/varios/map_style.txt').then((string) {
      _mapStyle = string;
    });
    // _iniciarLocation();
  }

  static final CameraPosition _inicial = CameraPosition(
    target: LatLng(-17.783338, -63.182117),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    datosbasicos = ModalRoute.of(context).settings.arguments;
    menup = new MenuP(datosbasicos);
    return WillPopScope(
      onWillPop: () async => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text('Esta seguro que quiere salir?'),
                  actions: <Widget>[
                    RaisedButton(
                        child: Text('Salir'),
                        onPressed: () => Navigator.of(context).pop(true)),
                    RaisedButton(
                        child: Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(false)),
                  ])),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Supermercados cercanos"),
        ),
        body: GoogleMap(
          markers: _markers,
          polylines: _polyline,
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _inicial,
          onMapCreated: (GoogleMapController controller) async {
            mapController = controller;
            mapController.setMapStyle(_mapStyle);
            _controller.complete(controller);
            await _getSupermercados();
            _showmarkers(context, listaSuper, datosbasicos);
          },
        ),
        floatingActionButton: Container(
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(left: 20.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              if (botonTexto != "Comprar") {
                _alertConfirmacion(context, botonSupermercado, datosbasicos);
              } else {
                Toast.show("Selecciona un supermercado!", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }
            },
            label: Text(botonTexto),
            icon: Icon(Icons.store),
          ),
        ),
        //drawer: _getdrawer(context),
        drawer: menup,
      ),
    );
  }

  Widget _getdrawer(BuildContext context) {
    if (listaSuper.isEmpty) {
      SupermercadoProvider ls = new SupermercadoProvider();

      return FutureBuilder(
          future: ls.getAll(),
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              listaSuper = snapshot.data;
              // _showmarkers(snapshot.data);
              return _crearDrawer(snapshot.data, context);
            } else {
              return CircularProgressIndicator();
            }
          });
    } else {
      return _crearDrawer(listaSuper, context);
    }
  }

  Widget _crearDrawer(List<Supermercado> ls, BuildContext context) {
    return Drawer(
      child: ListView.builder(
        itemCount: ls == null ? 1 : ls.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _createHeader();
          }
          index -= 1;
          // double long = ls[index].latitud;
          // double lat = ls[index].longitud;
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  ls[index].nombre,
                  style: TextStyle(color: Colors.red),
                ),
                leading: Icon(
                  Icons.store_mall_directory,
                  color: Colors.blue,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                ),
                subtitle: Text(ls[index].descripcion),
                onTap: () {
                  setState(() {
                    botonSupermercado = ls[index];
                    botonTexto = ls[index].nombre;
                  });
                  _goSuper(ls[index]);
                  Navigator.of(context).pop();
                },
              ),
              Divider()
            ],
          );
        },
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/Supermercados.jpg'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Supermercados Disponibles",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Future<void> _goSuper(Supermercado sup) async {
    double lat = sup.longitud;
    double long = sup.latitud;
    MarkerId mid = MarkerId(sup.id.toString());
    // setState(() {
    //   _markers.add(Marker(
    //       markerId: mid,
    //       position: LatLng(lat, long),
    //       infoWindow: InfoWindow(title: sup.nombre, snippet: sup.descripcion)));
    // });

    GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), zoom))
        .then((_) async {
      await Future.delayed(Duration(seconds: 2));
      controller.showMarkerInfoWindow(mid);
    });
  }

  void _showmarkers(BuildContext context, List<Supermercado> sup,
      DatosBasicos datosbasicos) async {
    // GoogleMapController controller = await _controller.future;

    sup.forEach((sup) {
      double lat = sup.longitud;
      double long = sup.latitud;
      MarkerId mid = MarkerId(sup.id.toString());
      setState(() {
        _markers.add(Marker(
            onTap: () {
              setState(() {
                botonSupermercado = sup;
                botonTexto = sup.nombre;
              });
            },
            markerId: mid,
            position: LatLng(lat, long),
            infoWindow: InfoWindow(
                title: sup.nombre,
                snippet: sup.descripcion,
                onTap: () {
                  _alertConfirmacion(context, sup, datosbasicos);
                })));
      });
    });
  }

  void _alertConfirmacion(
      BuildContext context, Supermercado sup, DatosBasicos datosbasicos) {
    datosbasicos.supermercadoId = sup.id;
    datosbasicos.supermercadoNombre = sup.nombre;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmar"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    new TextSpan(
                        text: 'Desea seleccionar : ',
                        style: TextStyle(color: Colors.black)),
                    new TextSpan(
                        text: '${sup.nombre}',
                        style: TextStyle(color: Colors.blue, fontSize: 15.0)),
                    new TextSpan(
                        text: ' para realizar sus compras?',
                        style: TextStyle(color: Colors.black))
                  ]),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancelar")),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, 'catergorias',
                        arguments: datosbasicos);
                  },
                  child: Text("OK")),
            ],
          );
        });
  }

  Future<void> _getSupermercados() async {
    SupermercadoProvider ls = new SupermercadoProvider();
    listaSuper = await ls.getAll();
    _locationData = await location.getLocation();

    GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(_locationData.latitude, _locationData.longitude), zoom))
        .then((_) async {
      await Future.delayed(Duration(seconds: 2));
      dibujar_linea_mas_cercano();
    });
  }

  void dibujar_linea_mas_cercano() {
    LatLng coor2 = LatLng(_locationData.latitude, _locationData.longitude);
    LatLng coorBest;
    List<LatLng> listlatlong = List();
    Supermercado sup;

    double men = double.maxFinite;
    listaSuper.forEach((element) {
      LatLng coor1 = LatLng(element.longitud, element.latitud);

      double calc = calcular_distancia_entre_ubicaciones(coor1, coor2);
      if (calc < men) {
        men = calc;
        coorBest = coor1;
        sup = element;
        setState(() {
          botonSupermercado = element;
          botonTexto = element.nombre;
        });
      }
    });
    listlatlong.add(coorBest);
    listlatlong.add(coor2);

    _polyline.add(Polyline(
      polylineId: PolylineId(1.toString()),
      visible: true,
      //latlng is List<LatLng>
      points: listlatlong,
      color: Colors.green,
    ));

    Toast.show('El supermercado mas cercano es: ${sup.nombre}', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}
