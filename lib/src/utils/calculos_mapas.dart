import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

double rad(double x) {
  const double pi = 3.1415926535897932;
     return x * pi / 180;
}

double calcular_distancia_entre_ubicaciones(LatLng p1,LatLng p2) {
     var R = 6378137; // Earth’s mean radius in meter
     var dLat = rad(p2.latitude - p1.latitude);
     var dLong = rad(p2.longitude - p1.longitude);
     var a = sin(dLat / 2) * sin(dLat / 2) +
       cos(rad(p1.latitude)) * cos(rad(p2.latitude)) *
       sin(dLong / 2) * sin(dLong / 2);
     var c = 2 * atan2(sqrt(a), sqrt(1 - a));
     var d = R * c;
     return d; // returns the distance in meter
}

