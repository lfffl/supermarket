import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:location/location.dart';
import 'package:supermarket/src/models/datos_basicos.dart';
import 'package:supermarket/src/providers/cliente_provider.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);
  final DatosBasicos datos = new DatosBasicos();

  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      // if (!users.containsKey(data.name)) {
      //   return 'El usuario no existe';
      // }
      // if (users[data.name] != data.password) {
      //   return 'Contrasena incorrecta';
      // }
      // return null;
      // print(scriptBD());
      final ClienteProvider cp = new ClienteProvider();
      Cliente cli = await cp.getClienteCI(int.parse(data.name));
      // List<Cliente> cli = await cp.getAll();

      if (cli == null) {
        return 'El usuario no existe';
      }
      if (cli.ci.toString() != data.password) {
        return 'Contrasena incorrecta';
      }
      datos.clienteId = cli.id;
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    getPermiso();
    return FlutterLogin(
      title: '',
      logo: 'assets/images/logo2.png',
      onLogin: _authUser,
      onSignup: _authUser,
      onSubmitAnimationCompleted: () {
        Navigator.pushNamed(context, 'mapa', arguments: datos);
      },
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
        usernameHint: 'Usuario',
        passwordHint: 'Contrasena',
        loginButton: 'INGRESAR',
        signupButton: 'REGISTRAR',
        forgotPasswordButton: 'Olvidaste tu password?',
      ),
      emailValidator: (str) {
        if (str == "") {
          return "Debes ingresar un usuario!";
        } else {
          return null;
        }
      },
    );
  }

  void getPermiso() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    // LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // _locationData = await location.getLocation();
  }
}
