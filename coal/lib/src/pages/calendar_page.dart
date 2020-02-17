import 'package:coal/src/shared/preferences_user.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:coal/src/widgets/drawer.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  // Map<DateTime, List> _events;
  // final _selectedDay = DateTime.now();
  // List _selectedEvents;
  CalendarController _calendarController;
  final pref = new PreferencesUser();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    pref.lastPage = 'calendar';

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(title: Text('Calendario Coal')),
      body: Container(
        child: TableCalendar(
          locale: 'es-MX',
          formatAnimation: FormatAnimation.slide,
          calendarController: _calendarController,
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: HeaderStyle(
            centerHeaderTitle: true,
            formatButtonVisible: false
          ),
          calendarStyle: CalendarStyle(
            holidayStyle: TextStyle().copyWith(color: Colors.red),
            weekendStyle: TextStyle().copyWith(color: Colors.deepOrange)
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: TextStyle().copyWith(color: Colors.deepOrange),
          ),
          onDaySelected: _onDaySelected,
        )
      )
    );
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      
    });
  }
}
