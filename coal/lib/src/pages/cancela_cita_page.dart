
import 'package:coal/src/widgets/drawer.dart';
import 'package:flutter/material.dart';

class CancelaCitaPage extends StatefulWidget {
  @override
  _CancelaCitaPageState createState() => _CancelaCitaPageState();
}

class _CancelaCitaPageState extends State<CancelaCitaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Cancelar Cita')
      ),
      body: Center(
        child: Text('Cancelar cita'),
      ),
    );
  }
}