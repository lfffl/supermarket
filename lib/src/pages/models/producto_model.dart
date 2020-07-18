class Productos {

  List<Producto> items = new List();
  Productos();

  Productos.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final producto = new Producto.fromJson(item);
      items.add(producto);
    }
  }
}

class Producto {
  Producto({
    this.id,
    this.nombre,
    this.precio,
    this.descripcion,
    this.imagen,
    this.idcategoria,
  });

  int id;
  String nombre;
  double precio;
  String descripcion;
  String imagen;
  int idcategoria;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id"],
        nombre: json["nombre"],
        precio: json["precio"].toDouble(),
        descripcion: json["descripcion"],
        imagen: json["imagen"],
        idcategoria: json["idcategoria"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "precio": precio,
        "descripcion": descripcion,
        "imagen": imagen,
        "idcategoria": idcategoria,
      };
}
