import 'package:flutter/material.dart';
import 'package:supermarket/src/models/datos_basicos.dart';
import 'package:supermarket/src/providers/categoria_provider.dart';

class CategoriasPage extends StatefulWidget {
  @override
  _ComprasState createState() => _ComprasState();
}

class _ComprasState extends State<CategoriasPage> {
  DatosBasicos datosbasicos;
  @override
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
        String imagen = categorias[index].imagen;
        // print(imagen);
        return Column(
          children: <Widget>[
            Stack(children: <Widget>[
              GestureDetector(
                child: FadeInImage(
                    height: MediaQuery.of(context).size.height * 0.20,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                    placeholder: AssetImage("assets/load/load.gif"),
                    fadeOutDuration: Duration(seconds: 2),
                    image: AssetImage('assets/categorias/$imagen')),
                onTap: () {
                  datosbasicos.categoriaId = categorias[index].id;
                  datosbasicos.nombrecategoria = categorias[index].nombre;
                  Navigator.pushNamed(context, 'listaproductos',
                      arguments: datosbasicos);
                },
              ),
              Text(categorias[index].nombre,
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.yellow[900],
                      shadows: [
                        Shadow(
                            blurRadius: 2.0,
                            color: Colors.black,
                            offset: Offset(3.0, 2.0))
                      ]),
                  overflow: TextOverflow.ellipsis)
            ]),
            Divider()
          ],
        );
      },
      itemCount: categorias.length,
    );
  }

  // Text(categorias[index].nombre,
  //                 style: TextStyle(
  //                   fontSize: 25.0,color: Colors.white,
  //                   // background: Paint()..color = Colors.white,
  //                 ),
  //                 overflow: TextOverflow.ellipsis)

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

  // ListTile(
  //   title: Text(
  //     '${categorias[index].nombre}',
  //     style: TextStyle(color: Colors.blue),
  //   ),
  //   subtitle: Text('${categorias[index].descripcion}'),
  //   trailing: Icon(
  //     Icons.arrow_forward,
  //     color: Colors.deepPurpleAccent,
  //   ),
  //   onTap: () {
  //     datosbasicos.categoriaId = categorias[index].id;
  //     Navigator.pushNamed(context, 'listaproductos', arguments: datosbasicos);
  //   },
  // ),
}
