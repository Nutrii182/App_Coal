
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

  TextEditingController _editCont = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _crearNombre(),
            _crearFecha(context),
            _crearDropdown(),
            // _crearCorreo(),
            // _crearContrasenia(),
            // _crearRepContra()
          ],
        ) 
      ),
    );
  }

  Widget _crearNombre() {

    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        labelText: 'Nombre',
        hintText: 'Nombre',
        suffixIcon: Icon(Icons.accessibility),
        icon: Icon(Icons.account_circle)
      ),
      onChanged: (v) => setState((){
        _nombre = v;
      })
    );
  }

  Widget _crearFecha(BuildContext context) {

    return TextFormField(
      controller: _editCont,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        labelText: 'Fecha',
        hintText: 'Fecha de Nacimiento',
        suffixIcon: Icon(Icons.cake),
        icon: Icon(Icons.calendar_today)
      ),
      onTap: (){
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
      locale: Locale('es', 'ES')
    );

    if (picked != null) {
    setState(() {
      _dateFormat = DateFormat("dd/MM/yyyy").format(picked);
      _editCont.text = _dateFormat;
      _fecha = _dateFormat;
    });
  }
  }

  Widget _crearDropdown() {

    return Row(
      children: <Widget>[
        Icon(Icons.person),
        Text('Género'),
        SizedBox(width: 30.0),
        DropdownButton(
          value: _option,
          items: getOptionDropDown(),
          onChanged: (opt){
            setState(() {
              _option = opt;
              _genero = _option;
            });
          }
        )
      ],
    );
  }

  List<DropdownMenuItem<String>> getOptionDropDown(){

    List<DropdownMenuItem<String>> lista = new List();

    _list.forEach((gen){
      lista.add(DropdownMenuItem(
        child: Text(gen),
        value: gen,
      ));
    });
    return lista;
  }

  // _crearCorreo() {}
  
  // _crearContrasenia() {}

  // _crearRepContra() {}

  
}