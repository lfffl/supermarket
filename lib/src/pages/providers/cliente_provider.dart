import 'package:sqflite/sqflite.dart';

import 'db_provider.dart';
import 'package:supermarket/src/pages/models/Cliente_model.dart';
export 'package:supermarket/src/pages/models/Cliente_model.dart';

class ClienteProvider {
  Database db;

  ClienteProvider() {
    iniciarbd();
  }

  void iniciarbd() async {
    db = await DBProvider.db.database;
  }

  insert(Cliente cliente) async {
    final res = await db.insert('cliente', cliente.toJson());
    return res;
  }

  Future<Cliente> getClienteId(int id) async {
    db = await DBProvider.db.database;
    final res = await db.query('cliente', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? Cliente.fromJson(res.first) : null;
  }

  Future<Cliente> getClienteCI(int ci) async {
    db = await DBProvider.db.database;
    final res = await db.query('cliente', where: 'ci=?', whereArgs: [ci]);
    return res.isNotEmpty ? Cliente.fromJson(res.first) : null;
  }

  Future<List<Cliente>> getAll() async {
    db = await DBProvider.db.database;
    final res = await db.query('cliente');
    List<Cliente> list =
        res.isNotEmpty ? res.map((e) => Cliente.fromJson(e)).toList() : null;
    return list;
  }

  updateCliente(Cliente cliente) async {
    final res = db.update('cliente', cliente.toJson(),
        where: 'id = ?', whereArgs: [cliente.id]);
    return res; // retorna el numero de id,s actualizados
  }

  deleteCliente(int id) async {
    final res = db.delete('cliente', where: 'id=?', whereArgs: [id]);
    return res; // retorna el numero de filas eliminadas
  }
}
