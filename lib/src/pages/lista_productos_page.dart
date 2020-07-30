import 'package:flutter/material.dart';
import 'package:supermarket/src/bloc/producto_bloc.dart';
import 'package:supermarket/src/models/datos_basicos.dart';
import 'package:supermarket/src/providers/productoCarrito_provider.dart';
import 'package:supermarket/src/providers/producto_provider.dart';
import 'package:toast/toast.dart';

class ListaProductosPage extends StatefulWidget {
  @override
  _ListaProductosPageState createState() => _ListaProductosPageState();
}

class _ListaProductosPageState extends State<ListaProductosPage> {
  DatosBasicos datosbasicos;
  ProductoBloc pbloc = new ProductoBloc();
  // List<Categoria> categorias;
  @override
  void initState() {
    super.initState();
    //  _getcategoriasall();
  }

  @override
  Widget build(BuildContext context) {
    datosbasicos = ModalRoute.of(context).settings.arguments;
    pbloc.setCarrito(datosbasicos.clienteId);
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

  Widget _cargarlista(List<Producto> productos) {
    // print(categorias);
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        String carp = _quitarSpacios(datosbasicos.nombrecategoria);
        print(carp);
        String dirImage = 'assets/productos/$carp/${productos[index].imagen}';
        print(dirImage);
        return Column(
          children: <Widget>[
            ListTile(
              title: Text(
                '${productos[index].nombre}',
                style: TextStyle(color: Colors.blue),
              ),
              subtitle: RichText(
                  text: TextSpan(
                      text: '${productos[index].descripcion}',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                    TextSpan(
                        text: '\nPrecio: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(
                        text: '${productos[index].precio} Bs',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 15.0))
                  ])),
              isThreeLine: true,
              leading: FadeInImage(
                  width: MediaQuery.of(context).size.width*0.2,
                  height: MediaQuery.of(context).size.height*0.15,
                  fit: BoxFit.fill,
                  placeholder: AssetImage('assets/images/noimage.png'),
                  image: AssetImage(dirImage)),
              trailing: IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  _insertarProductoCarritoBloc(
                      datosbasicos.clienteId, productos[index]);
                },
              ),
            ),
            Divider()
          ],
        );
      },
      itemCount: productos.length,
    );
  }

  Widget _cargarlista2() {
    final ProductoProvider ct = new ProductoProvider();
    // List<Producto> Productos = await ct.getAll();
    return FutureBuilder(
      future: ct.getProductosCategoria(datosbasicos.categoriaId),
      builder: (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
        if (snapshot.hasData) {
          return _cargarlista(snapshot.data);
        } else {
          // return Center(child: CircularProgressIndicator());
          return Center(
            child: Text('No tenemos productos en esta categoria aún :('),
          );
        }
      },
    );
  }

  _insertarProductoCarritoBloc(int cliente, Producto producto) {
    ProductoCarrito pc = new ProductoCarrito();
    pc.idcliente = cliente;
    pc.id = null;
    pc.nombre = producto.nombre;
    pc.precio = producto.precio;
    pc.descripcion = producto.descripcion;
    pc.imagen = producto.imagen;
    pc.idcategoria = producto.idcategoria;

    pbloc.agregarProductosCarrito(pc);
    Toast.show('${producto.nombre} agregado a tu carrito', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  // Future<List<Categoria>> _getcategoriasall() async {
  //   List<Categoria> cate;
  //   CategoriaProvider cp = new CategoriaProvider();
  //   categorias = await cp.getAll();
  //   return cate;
  // }

  String _quitarSpacios(String nomb) {
    return nomb.replaceAll(new RegExp(r' '), '_');
  }
}
