import 'dart:async';

import 'package:supermarket/src/providers/productoCarrito_provider.dart';

class ProductoBloc {
  int cliente;
  static final ProductoBloc _singleton = new ProductoBloc._internal();

  setCarrito(int idcliente) {
    _singleton.cliente = idcliente;
  }

  factory ProductoBloc() {
    return _singleton;
  }

  ProductoBloc._internal() {
    obtenerProductosCarrito();
  }

  final _scansController = StreamController<List<ProductoCarrito>>.broadcast();
  Stream<List<ProductoCarrito>> get productoStream => _scansController.stream;

  dispose() {
    _scansController?.close();
  }

  obtenerProductosCarrito() async {
    ProductoCarritoProvider pc = ProductoCarritoProvider();

    if (cliente != null) {
      List<ProductoCarrito> vari =
          await pc.getProductoCarritosXclienteId(cliente);
      _scansController.sink.add(vari);
    }
  }

  agregarProductosCarrito(ProductoCarrito producto) async {
    ProductoCarritoProvider pc = ProductoCarritoProvider();
    await pc.insert(producto);
    obtenerProductosCarrito();
  }

  borrarProductosCarrito(int id) async {
    ProductoCarritoProvider pc = ProductoCarritoProvider();
    await pc.deleteProductoCarrito(id);
    obtenerProductosCarrito();
  }

  borrarAllProductoCarrito() async {
    ProductoCarritoProvider pc = ProductoCarritoProvider();
    await pc.deleteAll();
    obtenerProductosCarrito();
  }
}
