
import 'package:flutter/material.dart';
import 'package:coal/src/widgets/drawer.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información Personal'),
      ),
      drawer: DrawerWidget(),
      body: Center(
        child: Text('Info Personal'),
      ),
    );
  }
}