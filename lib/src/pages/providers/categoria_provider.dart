import 'package:sqflite/sqflite.dart';

import 'db_provider.dart';
import 'package:supermarket/src/pages/models/Categoria_model.dart';
export 'package:supermarket/src/pages/models/Categoria_model.dart';

class CategoriaProvider {
   Database db;

   CategoriaProvider() {
    iniciarbd();
  }

  void iniciarbd() async {
    db = await DBProvider.db.database;
  }


  insert(Categoria categoria) async {
    final res = await db.insert('Categoria', categoria.toJson());
    return res;
  }

  Future<Categoria> getCategoriaId(int id) async {
    final res = await db.query('Categoria', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? Categoria.fromJson(res.first) : null;
  }

  Future<List<Categoria>> getAll() async {
    final res = await db.query('Categoria');
    List<Categoria> list =
        res.isNotEmpty ? res.map((e) => Categoria.fromJson(e)).toList() : null;
    return list;
  }

  updateCategoria(Categoria categoria) async {
    final res = db.update('Categoria', categoria.toJson(),
        where: 'id = ?', whereArgs: [categoria.id]);
    return res; // retorna el numero de id,s actualizados
  }

  deleteCategoria(int id) async {
    final res = db.delete('Categoria', where: 'id=?', whereArgs: [id]);
    return res; // retorna el numero de filas eliminadas
  }

  
}
