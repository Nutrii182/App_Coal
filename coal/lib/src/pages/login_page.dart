import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Bienvenido')),
        body: SafeArea(
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
      validator: (value) =>
          value.isEmpty ? 'El Correo no puede estar vacío' : null,
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
        onPressed: () {
          print(_email);
          print(_password);
          Navigator.pushNamed(context, 'calendar');
        });
  }

  Widget _crearVinculo() {

    return Row(
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: 'No tienes una cuenta ',
            style: TextStyle(fontSize: 16.0, color: Color.fromRGBO(114, 115, 139, 1.0)),
          ),
        ),
        GestureDetector(
          child: Text(
            'Regístrate',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
              fontSize: 16.0)
            ),
          onTap: (){
            Navigator.pushNamed(context, 'registro');
          },
        )
      ],
    );
  }
}
