import 'dart:async';

import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supermarket/src/pages/models/supermercado_model.dart';
import 'package:supermarket/src/pages/providers/supermercado_provider.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  double zoom = 14.4746;
  Set<Marker> _markers = Set();
  List<Supermercado> listaSuper = [];
  // LocationData _locationData;

  @override
  void initState() {
    super.initState();
    _iniciarLocation();
  }

  static final CameraPosition _inicial = CameraPosition(
    target: LatLng(-17.783338, -63.182117),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supermercados cercanos"),
      ),
      body: GoogleMap(
        markers: _markers,
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _inicial,
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);
          await _getSupermercados();
          _showmarkers(listaSuper);
        },
      ),
      drawer: _getdrawer(),
    );
  }

  Widget _getdrawer() {
    if (listaSuper.isEmpty) {
      SupermercadoProvider ls = new SupermercadoProvider();

      return FutureBuilder(
          future: ls.getAll(),
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              listaSuper = snapshot.data;
              // _showmarkers(snapshot.data);
              return _crearDrawer(snapshot.data);
            } else {
              return CircularProgressIndicator();
            }
          });
    } else {
      return _crearDrawer(listaSuper);
    }
  }

  Widget _crearDrawer(List<Supermercado> ls) {
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
      await Future.delayed(Duration(seconds: 1));
      controller.showMarkerInfoWindow(mid);
    });
  }

  void _showmarkers(List<Supermercado> sup) async {
    // GoogleMapController controller = await _controller.future;

    sup.forEach((sup) {
      double lat = sup.longitud;
      double long = sup.latitud;
      MarkerId mid = MarkerId(sup.id.toString());
      setState(() {
        _markers.add(Marker(
            markerId: mid,
            position: LatLng(lat, long),
            infoWindow:
                InfoWindow(title: sup.nombre, snippet: sup.descripcion)));
      });
    });
  }

  Future<void> _getSupermercados() async {
    SupermercadoProvider ls = new SupermercadoProvider();
    listaSuper = await ls.getAll();
  }

  void _iniciarLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // _locationData = await location.getLocation();
  }
}
