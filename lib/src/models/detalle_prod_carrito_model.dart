class Detalles {
  
  List<Detalle> items = new List();
  Detalles();

  Detalles.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final detalle = new Detalle.fromJson(item);
      items.add(detalle);
    }
  }
}
class Detalle {
    Detalle({
        this.id,
        this.cantidad,
        this.descripcion,
        this.idproducto,
        this.idcarrito,
    });

    int id;
    int cantidad;
    String descripcion;
    int idproducto;
    int idcarrito;

    factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        id: json["id"],
        cantidad: json["cantidad"],
        descripcion: json["descripcion"],
        idproducto: json["idproducto"],
        idcarrito: json["idcarrito"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cantidad": cantidad,
        "descripcion": descripcion,
        "idproducto": idproducto,
        "idcarrito": idcarrito,
    };
}
