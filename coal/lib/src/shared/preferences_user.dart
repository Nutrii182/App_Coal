import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUser {

  static final PreferencesUser _instance = new PreferencesUser._();

  factory PreferencesUser(){
    return _instance;
  }

  PreferencesUser._();

  SharedPreferences _pref;

  initPref() async {
    this._pref = await SharedPreferences.getInstance();
  }

  get name{
    return _pref.getString('Nombre') ?? null;
  }

  set name(String value){
    _pref.setString('Nombre', value);
  }

  get date{
    return _pref.getString('Fecha') ?? null;
  }

  set date(String value){
    _pref.setString('Fecha', value);
  }

    get gender{
    return _pref.getString('Genero') ?? null;
  }

  set gender(String value){
    _pref.setString('Genero', value);
  }

  get email{
    return _pref.getString('Correo') ?? null;
  }

  set email(String value){
    _pref.setString('Correo', value);
  }

  get token{
    return _pref.getString('Token') ?? null;
  }

  set token(String value){
    _pref.setString('Token', value);
  }

  get sesion{
    return _pref.getBool('Sesion') ?? false;
  }

  set sesion(bool value){
    _pref.setBool('Sesion', value);
  }
}