import 'package:sqflite/sqflite.dart';

import 'db_provider.dart';
import 'package:supermarket/src/pages/models/Cliente_model.dart';

class ClienteProvider {
  Database db = DBProvider.db.database;

  insert(Cliente cliente) async {
    final res = await db.insert('Cliente', cliente.toJson());
    return res;
  }

  Future<Cliente> getClienteId(int id) async {
    final res = await db.query('Cliente', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? Cliente.fromJson(res.first) : null;
  }

  Future<List<Cliente>> getAll() async {
    final res = await db.query('Cliente');
    List<Cliente> list =
        res.isNotEmpty ? res.map((e) => Cliente.fromJson(e)).toList() : null;
    return list;
  }

  updateCliente(Cliente cliente) async {
    final res = db.update('Cliente', cliente.toJson(),
        where: 'id = ?', whereArgs: [cliente.id]);
    return res; // retorna el numero de id,s actualizados
  }

  deleteCliente(int id) async {
    final res = db.delete('Cliente', where: 'id=?', whereArgs: [id]);
    return res; // retorna el numero de filas eliminadas
  }

  
}
