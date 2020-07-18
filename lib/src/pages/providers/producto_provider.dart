import 'package:sqflite/sqflite.dart';

import 'db_provider.dart';
import 'package:supermarket/src/pages/models/Producto_model.dart';

class ProductoProvider {
  Database db = DBProvider.db.database;

  insert(Producto producto) async {
    final res = await db.insert('Producto', producto.toJson());
    return res;
  }

  Future<Producto> getProductoId(int id) async {
    final res = await db.query('Producto', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? Producto.fromJson(res.first) : null;
  }

  Future<List<Producto>> getAll() async {
    final res = await db.query('Producto');
    List<Producto> list =
        res.isNotEmpty ? res.map((e) => Producto.fromJson(e)).toList() : null;
    return list;
  }

  updateProducto(Producto producto) async {
    final res = db.update('Producto', producto.toJson(),
        where: 'id = ?', whereArgs: [producto.id]);
    return res; // retorna el numero de id,s actualizados
  }

  deleteProducto(int id) async {
    final res = db.delete('Producto', where: 'id=?', whereArgs: [id]);
    return res; // retorna el numero de filas eliminadas
  }
}
