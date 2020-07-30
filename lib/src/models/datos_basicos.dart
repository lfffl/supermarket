class DatosBasicos {
  DatosBasicos({
    this.clienteId,
    this.clienteNombre,
    this.carrito,
    this.supermercadoId,
    this.nombrecategoria,
    this.supermercadoNombre,
    this.categoriaId,
  });

  int clienteId;
  String clienteNombre;
  int carrito;
  int supermercadoId;
  String nombrecategoria;
  String supermercadoNombre;
  int categoriaId;

  factory DatosBasicos.fromJson(Map<String, dynamic> json) => DatosBasicos(
        clienteId: json["cliente_id"],
        clienteNombre: json["cliente_nombre"],
        carrito: json["carrito"],
        supermercadoId: json["supermercado_id"],
        supermercadoNombre: json["supermercado_nombre"],
        categoriaId: json["categoriaID"],
      );

  Map<String, dynamic> toJson() => {
        "cliente_id": clienteId,
        "cliente_nombre": clienteNombre,
        "carrito": carrito,
        "supermercado_id": supermercadoId,
        "supermercado_nombre": supermercadoNombre,
        "categoriaID": categoriaId,
      };
}
