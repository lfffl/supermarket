import 'package:flutter/material.dart';
import 'package:supermarket/src/models/datos_basicos.dart';
import 'package:supermarket/src/pages/menu_principal.dart';
import 'package:supermarket/src/providers/categoria_provider.dart';
import 'package:supermarket/src/utils/SearchDelegate.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:diacritic/diacritic.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';

class CategoriasPage extends StatefulWidget {
  @override
  _ComprasState createState() => _ComprasState();
}

class _ComprasState extends State<CategoriasPage> {
  bool permisoMicrofono = false;
  DataSearch ds = new DataSearch();
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  DatosBasicos datosbasicos;
  MenuP p = new MenuP();
  @override
  Widget build(BuildContext context) {
    datosbasicos = ModalRoute.of(context).settings.arguments;
    p.setDatosbasicos(datosbasicos);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        //title: Text(datosbasicos.supermercadoNombre),
        centerTitle: true,
        actions: <Widget>[
          Center(child: Text(resultText)),
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () {
              if (!permisoMicrofono) {
                _permissionRequest();
              }
              //Navigator.pushNamed(context, 'carrito', arguments: datosbasicos);
              //showSearch(context: context, delegate: DataSearch());
              if (permisoMicrofono) {
                if (_isAvailable && !_isListening) {
                  _isListening = true;
                  resultText = "Escuchando...";
                  _speechRecognition.listen(locale: "en_US").then((result) {
                    ds.setDatosbasicos(datosbasicos);

                    showSearch(
                        context: context,
                        delegate: ds,
                        query: removeDiacritics(result).toLowerCase());
                    resultText = "";
                  });
                }
                /*
                if (_isListening) {
                  _isListening = false;
                  _speechRecognition.stop().then((result) {
                    _isListening = false;
                    ds.setDatosbasicos(datosbasicos);

                    showSearch(
                        context: context,
                        delegate: ds,
                        query: removeDiacritics(result).toLowerCase());
                  });
                  resultText = "";
                }
                */
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              if (_isListening) {
                _speechRecognition.stop().then((result) {
                  print("entro al stop");
                });
              }
              ds.setDatosbasicos(datosbasicos);

              showSearch(
                  context: context,
                  delegate: ds,
                  query: removeDiacritics(resultText).toLowerCase());
              resultText = "";
            },
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: _cargarlista2(),
      drawer: p,
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

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  _permissionRequest() async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Easy Permission Validator',
    );
    var result = await permissionValidator.microphone();
    if (result) {
      permisoMicrofono = true;
    }
  }
}
