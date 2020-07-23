class ProductosCarrito {
  List<ProductoCarrito> items = new List();
  ProductosCarrito();

  ProductosCarrito.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final productoCarrito = new ProductoCarrito.fromJson(item);
      items.add(productoCarrito);
    }
  }
}

class ProductoCarrito {
  ProductoCarrito({
    this.id,
    this.idcliente,
    this.nombre,
    this.precio,
    this.descripcion,
    this.imagen,
    this.idcategoria,
  });

  int id;
  int idcliente;
  String nombre;
  double precio;
  String descripcion;
  String imagen;
  int idcategoria;

  factory ProductoCarrito.fromJson(Map<String, dynamic> json) => ProductoCarrito(
        id: json["id"],
        idcliente: json["idcliente"],
        nombre: json["nombre"],
        precio: json["precio"].toDouble(),
        descripcion: json["descripcion"],
        imagen: json["imagen"],
        idcategoria: json["idcategoria"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idcliente" : idcliente,
        "nombre": nombre,
        "precio": precio,
        "descripcion": descripcion,
        "imagen": imagen,
        "idcategoria": idcategoria,
      };
}
