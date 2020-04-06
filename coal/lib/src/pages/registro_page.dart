import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:coal/src/shared/preferences_user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  String _nombre = '', _fecha = '', _genero = '', _correo = '';
  String _password = '', _repPassword = '', _option = 'Seleccione su género';
  List<String> _list = ['Seleccione su género', 'Masculino', 'Femenino'];
  bool _stateUser = false, _isLoading = false;
  final dbReference = Firestore.instance;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final _pref = new PreferencesUser();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  TextEditingController _editName = new TextEditingController();
  TextEditingController _editDate = new TextEditingController();
  TextEditingController _editEmail = new TextEditingController();
  TextEditingController _editPass = new TextEditingController();
  TextEditingController _editRePass = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => Center(
            child: Form(
          key: _formkey,
          child: Container(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  _crearNombre(),
                  Divider(),
                  _crearFecha(context),
                  Divider(),
                  _crearDropdown(),
                  Divider(),
                  _crearCorreo(),
                  Divider(),
                  _crearPassword(),
                  Divider(),
                  _crearRepContra(),
                  SizedBox(height: 20.0),
                  _crearBotones(context)
                ],
              )),
        )),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
        controller: _editName,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Nombre',
            hintText: 'Nombre',
            suffixIcon: Icon(Icons.accessibility),
            icon: Icon(Icons.account_circle)),
        validator: (value) =>
            value.isEmpty ? 'El nombre no puede estar vacío' : null,
        onChanged: (v) => setState(() {
              _nombre = v;
            }));
  }

  Widget _crearFecha(BuildContext context) {
    return TextFormField(
      controller: _editDate,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Fecha de Nacimiento',
          suffixIcon: Icon(Icons.cake),
          icon: Icon(Icons.calendar_today)),
      validator: (value) =>
          value.isEmpty ? 'La fecha no puede estar vacía' : null,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
    );
  }

  void _selectDate(BuildContext context) async {
    String _dateFormat;

    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1950),
        lastDate: new DateTime.now(),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      setState(() {
        _dateFormat = DateFormat("dd/MM/yyyy").format(picked);
        _editDate.text = _dateFormat;
        _fecha = _dateFormat;
      });
    }
  }

  Widget _crearDropdown() {
    return Row(
      children: <Widget>[
        Icon(Icons.person,
            color: Color.fromRGBO(114, 115, 139, 1.0), size: 25.0),
        SizedBox(width: 30.0),
        DropdownButton(
            iconEnabledColor: Color.fromRGBO(114, 115, 139, 1.0),
            value: _option,
            items: getOptionDropDown(),
            onChanged: (opt) {
              setState(() {
                _option = opt;
                _genero = _option;
              });
            })
      ],
    );
  }

  List<DropdownMenuItem<String>> getOptionDropDown() {
    List<DropdownMenuItem<String>> lista = new List();

    _list.forEach((gen) {
      lista.add(DropdownMenuItem(
        child: Text(gen,
            style: TextStyle(color: Color.fromRGBO(114, 115, 139, 1.0))),
        value: gen,
      ));
    });
    return lista;
  }

  Widget _crearCorreo() {
    return TextFormField(
      controller: _editEmail,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Correo',
          hintText: 'Correo Electrónico',
          helperText: 'Favor de escribir un correo válido',
          suffixIcon: Icon(Icons.alternate_email),
          icon: Icon(Icons.mail)),
      validator: validateEmail,
      onChanged: (v) => setState(() {
        _correo = v;
      }),
    );
  }

  Widget _crearPassword() {
    return TextFormField(
        controller: _editPass,
        obscureText: true,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Contraseña',
            hintText: 'Contraseña',
            helperText: 'Mínimo 6 Caractéres',
            suffixIcon: Icon(Icons.lock_open),
            icon: Icon(Icons.lock)),
        validator: validatePassword,
        onChanged: (valor) => setState(() {
              _password = valor;
            }));
  }

  Widget _crearRepContra() {
    return TextFormField(
        controller: _editRePass,
        obscureText: true,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Verifica Contraseña',
            hintText: 'Reescribe tu Contraseña',
            helperText: 'Mínimo 6 Caractéres',
            suffixIcon: Icon(Icons.lock_open),
            icon: Icon(Icons.lock)),
        validator: (value) =>
            value.isEmpty ? 'La Verificación no puede estar vacía' : null,
        onChanged: (valor) => setState(() {
              _repPassword = valor;
            }));
  }

  Widget _crearBotones(BuildContext context) {
    return Row(
      children: <Widget>[
        RaisedButton(
            color: Colors.blue,
            child: Text('Aceptar', style: TextStyle(color: Colors.white)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              if (_formkey.currentState.validate()) {
                if (_password != _repPassword) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Las contraseñas no son iguales')));
                  setState(() {
                    _isLoading = false;
                  });
                } else {
                  if (_genero == 'Seleccione su género') {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Favor de seleccionar su género')));
                    setState(() {
                      _isLoading = false;
                    });
                  } else {
                    _getData();
                    Future.delayed(Duration(seconds: 2), () {
                      if (_stateUser == true) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Usuario Existente')));
                        setState(() {
                          _isLoading = false;
                        });
                      } else {
                        if (_creaUsuario() == null) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Error en el Registro')));
                          setState(() {
                            _isLoading = false;
                          });
                        } else {
                          _registraUsuario();
                          Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text('Registro Exitoso')));
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pushReplacementNamed(context, 'login');
                          });
                        }
                      }
                    });
                  }
                }
              }
            }),
        SizedBox(width: 10.0),
        RaisedButton(
            color: Colors.blueGrey,
            child: Text('Limpiar', style: TextStyle(color: Colors.white)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              _editDate.text = '';
              _editName.text = '';
              _editEmail.text = '';
              _editPass.text = '';
              _editRePass.text = '';
            }),
        SizedBox(width: 10.0),
        _loading(),
      ],
    );
  }

  Widget _loading() {
    if (_isLoading == true)
      return SizedBox(
          height: 20.0, width: 20.0, child: CircularProgressIndicator());
    else
      return Container();
  }

  void _registraUsuario() async {

    _firebaseMessaging.getToken().then((token){
      print(token);
      _pref.token = token;
    });

    return await dbReference.collection("Usuarios").document(_correo.toLowerCase()).setData({
      'Nombre': _nombre.toLowerCase(),
      'Fecha de Nacimiento': _fecha,
      'Genero': _genero.toLowerCase(),
      'Correo': _correo.toLowerCase(),
      'Token': _pref.token,
    });
  }

  Future<AuthResult> _creaUsuario() async {
    final regis = await _auth.createUserWithEmailAndPassword(
        email: _correo.toLowerCase(), password: _password);

    if (regis == null) return null;
    return regis;
  }

  void _getData() async {
    await dbReference.collection("Usuarios").getDocuments().then((val) {
      for (var i = 0; i < val.documents.length; i++) {
        if (val.documents[i].data["Correo"] == _correo) _stateUser = true;
      }
    });
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

  String validatePassword(String value) {
    if (value.isEmpty)
      return 'La contraseña no puede estar vacía';
    else {
      if (value.length < 6)
        return 'La contraseña debe tener mínimo 6 caractéres';
    }
    return null;
  }
}
