import 'package:flutter/material.dart';
import 'package:supermarket/src/models/datos_basicos.dart';
import 'package:supermarket/src/providers/categoria_provider.dart';

class ComprasPage extends StatefulWidget {
  @override
  _ComprasState createState() => _ComprasState();
}

class _ComprasState extends State<ComprasPage> {
  @override
  DatosBasicos datosbasicos;
  Widget build(BuildContext context) {
    datosbasicos = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(datosbasicos.supermercadoNombre),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, 'carrito', arguments: datosbasicos);
            },
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: _cargarlista2(),
    );
  }

  Widget _cargarlista(List<Categoria> categorias) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Text(
                '${categorias[index].nombre}',
                style: TextStyle(color: Colors.blue),
              ),
              subtitle: Text('${categorias[index].descripcion}'),
              trailing: Icon(
                Icons.arrow_forward,
                color: Colors.deepPurpleAccent,
              ),
              onTap: () {
                datosbasicos.categoriaId = categorias[index].id;
                Navigator.pushNamed(context, 'producto', arguments: datosbasicos);
              },
            ),
            Divider()
          ],
        );
      },
      itemCount: categorias.length,
    );
  }

  Widget _cargarlista2() {
    final CategoriaProvider ct = new CategoriaProvider();
    // List<Categoria> categorias = await ct.getAll();
    return FutureBuilder(
      future: ct.getAll(),
      builder: (BuildContext context, AsyncSnapshot<List<Categoria>> snapshot) {
        if (snapshot.hasData) {
          return _cargarlista(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
