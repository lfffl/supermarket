import 'package:sqflite/sqflite.dart';
import 'package:supermarket/src/models/carrito_model.dart';
export 'package:supermarket/src/models/carrito_model.dart';

import 'db_provider.dart';

class CarritoProvider {
  Database db;



  insert(Carrito carrito) async {
    db = await DBProvider.db.database;
    final res = await db.insert('carrito', carrito.toJson());
    return res;
  }

  Future<Carrito> getCarritoId(int id) async {
    db = await DBProvider.db.database;
    final res = await db.query('carrito', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? Carrito.fromJson(res.first) : null;
  }

  Future<List<Carrito>> getAll() async {
    db = await DBProvider.db.database;
    final res = await db.query('carrito');
    List<Carrito> list =
        res.isNotEmpty ? res.map((e) => Carrito.fromJson(e)).toList() : null;
    return list;
  }

  updateCarrito(Carrito carrito) async {
    db = await DBProvider.db.database;
    final res = db.update('carrito', carrito.toJson(),
        where: 'id = ?', whereArgs: [carrito.id]);
    return res; // retorna el numero de id,s actualizados
  }

  deleteCarrito(int id) async {
    db = await DBProvider.db.database;
    final res = db.delete('carrito', where: 'id=?', whereArgs: [id]);
    return res; // retorna el numero de filas eliminadas
  }

  
}
