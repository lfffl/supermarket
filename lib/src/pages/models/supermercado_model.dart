class Supermercados {
  
  List<Supermercado> items = new List();
  Supermercados();

  Supermercados.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final supermercado = new Supermercado.fromJson(item);
      items.add(supermercado);
    }
  }
}

class Supermercado {
    Supermercado({
        this.id,
        this.nombre,
        this.longitud,
        this.latitud,
        this.descripcion,
    });

    int id;
    String nombre;
    double longitud;
    double latitud;
    String descripcion;

    factory Supermercado.fromJson(Map<String, dynamic> json) => Supermercado(
        id: json["id"],
        nombre: json["nombre"],
        longitud: json["longitud"].toDouble(),
        latitud: json["latitud"].toDouble(),
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "longitud": longitud,
        "latitud": latitud,
        "descripcion": descripcion,
    };
}
