import 'package:sqflite/sqflite.dart';
import 'package:supermarket/src/models/ProductoCarrito_model.dart';
export 'package:supermarket/src/models/ProductoCarrito_model.dart';

import 'db_provider.dart';



class ProductoCarritoProvider {
  Database db;

  insert(ProductoCarrito productoCarrito) async {
    db = await DBProvider.db.database;
    final res = await db.insert('producto_carrito', productoCarrito.toJson());
    return res;
  }

  Future<ProductoCarrito> getProductoCarritoId(int id) async {
    db = await DBProvider.db.database;
    final res = await db.query('producto_carrito', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? ProductoCarrito.fromJson(res.first) : null;
  }

  Future<List<ProductoCarrito>> getProductoCarritosXclienteId(int id) async {
    db = await DBProvider.db.database;
    final res = await db.query('producto_carrito', where: 'idCliente=?', whereArgs: [id]);
    List<ProductoCarrito> list =
        res.isNotEmpty ? res.map((e) => ProductoCarrito.fromJson(e)).toList() : null;
    return list;
  }

  Future<List<ProductoCarrito>> getAll() async {
    db = await DBProvider.db.database;
    final res = await db.query('producto_carrito');
    List<ProductoCarrito> list =
        res.isNotEmpty ? res.map((e) => ProductoCarrito.fromJson(e)).toList() : null;
    return list;
  }

  updateProductoCarrito(ProductoCarrito productoCarrito) async {
    db = await DBProvider.db.database;
    final res = db.update('producto_carrito', productoCarrito.toJson(),
        where: 'id = ?', whereArgs: [productoCarrito.id]);
    return res; // retorna el numero de id,s actualizados
  }

  deleteProductoCarrito(int id) async {
    db = await DBProvider.db.database;
    final res = db.delete('producto_carrito', where: 'id=?', whereArgs: [id]);
    return res; // retorna el numero de filas eliminadas
  }

  deleteAll() async {
    db = await DBProvider.db.database;
    final res = db.delete('producto_carrito');
    return res; // retorna el numero de filas eliminadas
  }

}
