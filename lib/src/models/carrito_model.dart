class Carritos {
  
  List<Carrito> items = new List();
  Carritos();

  Carritos.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final carrito = new Carrito.fromJson(item);
      items.add(carrito);
    }
  }
}

class Carrito {
    Carrito({
        this.id,
        this.descripcion,
    });

    int id;
    String descripcion;

    factory Carrito.fromJson(Map<String, dynamic> json) => Carrito(
        id: json["id"],
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
    };
}