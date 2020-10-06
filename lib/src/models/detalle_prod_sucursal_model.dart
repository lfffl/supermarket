class DetProdSucursals {
  
  List<DetProdSucursal> items = new List();
  DetProdSucursals();

  DetProdSucursals.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final detalle = new DetProdSucursal.fromJson(item);
      items.add(detalle);
    }
  }
}

class DetProdSucursal {
    DetProdSucursal({
        this.id,
        this.idproducto,
        this.idsucursal,
    });

    int id;
    int idproducto;
    int idsucursal;

    factory DetProdSucursal.fromJson(Map<String, dynamic> json) => DetProdSucursal(
        id: json["id"],
        idproducto: json["idproducto"],
        idsucursal: json["idsucursal"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idproducto": idproducto,
        "idsucursal": idsucursal,
    };
}
