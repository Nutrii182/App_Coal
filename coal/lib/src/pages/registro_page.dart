import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  String _nombre = '';
  String _fecha = '';
  String _genero = '';
  String _correo = '';
  String _password = '';
  String _repPassword = '';
  String _option = 'Seleccione su género';
  List<String> _list = ['Seleccione su género', 'Hombre', 'Mujer'];

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
      body: Container(
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
              _crearBotones()
            ],
          )),
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
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2021),
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
      validator: (value) =>
          value.isEmpty ? 'El Correo no puede estar vacío' : null,
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
            helperText: 'Mínimo 8 Caractéres',
            suffixIcon: Icon(Icons.lock_open),
            icon: Icon(Icons.lock)),
        validator: (value) =>
            value.isEmpty ? 'La Contraseña no puede estar vacía' : null,
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
            helperText: 'Mínimo 8 Caractéres',
            suffixIcon: Icon(Icons.lock_open),
            icon: Icon(Icons.lock)),
        validator: (value) =>
            value.isEmpty ? 'La Verificación no puede estar vacía' : null,
        onChanged: (valor) => setState(() {
              _repPassword = valor;
            }));
  }

  Widget _crearBotones() {
    return Row(
      children: <Widget>[
        RaisedButton(
            color: Colors.blue,
            child: Text('Aceptar', style: TextStyle(color: Colors.white)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {}),
        SizedBox(width: 15.0),
        RaisedButton(
            color: Colors.blue,
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
      ],
    );
  }
}
