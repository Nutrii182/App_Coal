import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Bienvenido')),
        body: Builder(
          builder: (context) => SafeArea(
            child: Form(
              key: _formkey,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 50.0),
                    Image(
                      image: AssetImage('assets/logo_coal.png'),
                      width: double.infinity,
                    ),
                    SizedBox(height: 80.0),
                    _crearEmail(),
                    SizedBox(height: 30.0),
                    _crearPassword(),
                    SizedBox(height: 50.0),
                    _crearBoton(context),
                    SizedBox(height: 30.0),
                    _crearVinculo()
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _crearEmail() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: 'Correo',
        hintText: 'Correo Electrónico',
        suffixIcon: Icon(Icons.alternate_email),
      ),
      validator: validateEmail,
      onChanged: (v) => setState(() {
        _email = v;
      }),
    );
  }

  Widget _crearPassword() {
    return TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Contraseña',
          hintText: 'Contraseña',
          suffixIcon: Icon(Icons.lock_open),
        ),
        validator: (value) =>
            value.isEmpty ? 'La Contraseña no puede estar vacía' : null,
        onChanged: (valor) => setState(() {
              _password = valor;
            }));
  }

  Widget _crearBoton(BuildContext context) {
    return RaisedButton(
        color: Colors.blue,
        child: Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: () async {
          //Navigator.pushNamed(context, 'calendar');
          if (_formkey.currentState.validate()) {
            try {
              await _auth.signInWithEmailAndPassword(
                  email: _email, password: _password);
              await Navigator.pushReplacementNamed(context, 'calendar');
            } catch (e) {
              print("Error Iniciando Sesion: $e");
              String exception = getExceptionText(e);
              Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.blue, content: Text(exception)));
            }
          }
        }
      );
  }

  Widget _crearVinculo() {
    return Row(
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: 'No tienes una cuenta ',
            style: TextStyle(
                fontSize: 16.0, color: Color.fromRGBO(114, 115, 139, 1.0)),
          ),
        ),
        GestureDetector(
          child: Text('Regístrate',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  fontSize: 16.0)),
          onTap: () {
            Navigator.pushNamed(context, 'registro');
          },
        )
      ],
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty)
      return 'El correo no puede estar vacío';
    else {
      if (!regex.hasMatch(value))
        return 'Correo Electrónico Inválido';
      else
        return null;
    }
  }

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'La Cuenta no Existe';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Contraseña Incorrecta';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'Sin Conexión a Internet';
          break;
        case 'The email address is already in use by another account.':
          return 'La Cuenta ya Existe';
          break;
        default:
          return 'Error Desconocido';
      }
    } else {
      return 'Error Desconocido';
    }
  }
}
