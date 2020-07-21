import 'package:sqflite/sqflite.dart';
import 'package:supermarket/src/models/categoria_model.dart';
export 'package:supermarket/src/models/categoria_model.dart';
import 'db_provider.dart';


class CategoriaProvider {
   Database db;

  insert(Categoria categoria) async {
    db = await DBProvider.db.database;
    final res = await db.insert('categoria', categoria.toJson());
    return res;
  }

  Future<Categoria> getCategoriaId(int id) async {
    db = await DBProvider.db.database;
    final res = await db.query('categoria', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? Categoria.fromJson(res.first) : null;
  }

  Future<List<Categoria>> getAll() async {
    db = await DBProvider.db.database;
    final res = await db.query('categoria');
    List<Categoria> list =
        res.isNotEmpty ? res.map((e) => Categoria.fromJson(e)).toList() : null;
    return list;
  }

  updateCategoria(Categoria categoria) async {
    db = await DBProvider.db.database;
    final res = db.update('categoria', categoria.toJson(),
        where: 'id = ?', whereArgs: [categoria.id]);
    return res; // retorna el numero de id,s actualizados
  }

  deleteCategoria(int id) async {
    db = await DBProvider.db.database;
    final res = db.delete('categoria', where: 'id=?', whereArgs: [id]);
    return res; // retorna el numero de filas eliminadas
  }

  
}
