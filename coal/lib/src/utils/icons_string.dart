
import 'package:flutter/material.dart';

final _icons = <String, IconData>{
  'calendar_today' : Icons.calendar_today,
  'event' : Icons.event,
  'exit_to_app' : Icons.exit_to_app
};

Icon getIcon(String nameIcon){
  return Icon(_icons[nameIcon], color: Colors.blue);
}