class Categorias {
  
  List<Categoria> items = new List();
  Categorias();

  Categorias.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final categoria = new Categoria.fromJson(item);
      items.add(categoria);
    }
  }
}

class Categoria {
    Categoria({
        this.id,
        this.nombre,
        this.descripcion,
        this.imagen,
    });

    int id;
    String nombre;
    String descripcion;
    String imagen;

    factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        imagen: json["imagen"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "imagen": imagen,
    };
}
