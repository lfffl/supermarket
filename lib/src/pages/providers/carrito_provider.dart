import 'package:sqflite/sqflite.dart';

import 'db_provider.dart';
import 'package:supermarket/src/pages/models/carrito_model.dart';
export 'package:supermarket/src/pages/models/carrito_model.dart';

class CarritoProvider {
  Database db;

   CarritoProvider() {
    iniciarbd();
  }

  void iniciarbd() async {
    db = await DBProvider.db.database;
  }

  insert(Carrito carrito) async {
    final res = await db.insert('carrito', carrito.toJson());
    return res;
  }

  Future<Carrito> getCarritoId(int id) async {
    final res = await db.query('carrito', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? Carrito.fromJson(res.first) : null;
  }

  Future<List<Carrito>> getAll() async {
    final res = await db.query('carrito');
    List<Carrito> list =
        res.isNotEmpty ? res.map((e) => Carrito.fromJson(e)).toList() : null;
    return list;
  }

  updateCarrito(Carrito carrito) async {
    final res = db.update('carrito', carrito.toJson(),
        where: 'id = ?', whereArgs: [carrito.id]);
    return res; // retorna el numero de id,s actualizados
  }

  deleteCarrito(int id) async {
    final res = db.delete('carrito', where: 'id=?', whereArgs: [id]);
    return res; // retorna el numero de filas eliminadas
  }

  
}
