class Clientes {
  
  List<Cliente> items = new List();
  Clientes();

  Clientes.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final cliente = new Cliente.fromJson(item);
      items.add(cliente);
    }
  }
}

class Cliente {
    Cliente({
        this.id,
        this.ci,
        this.nombre,
        this.telf,
        this.direccion,
        this.idcarrito,
        this.email,
        this.password,
    });

    int id;
    int ci;
    String nombre;
    int telf;
    String direccion;
    int idcarrito;
    String email;
    String password;

    factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        ci: json["ci"],
        nombre: json["nombre"],
        telf: json["telf"],
        direccion: json["direccion"],
        idcarrito: json["idcarrito"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "ci": ci,
        "nombre": nombre,
        "telf": telf,
        "direccion": direccion,
        "idcarrito": idcarrito,
        "email": email,
        "password": password,
    };
}