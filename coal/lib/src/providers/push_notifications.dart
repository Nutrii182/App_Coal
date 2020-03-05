
import 'dart:async';
import 'dart:io';

import 'package:coal/src/shared/preferences_user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications {

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final _pref = new PreferencesUser();

  final _messageStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get message => _messageStreamController.stream;

  initNotifications(){

    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token){
      _pref.token = token;
    });

    _firebaseMessaging.configure(

      onMessage: (info) async {

        Map<String, dynamic> argument;
        if(Platform.isAndroid){
          argument = info ?? null;
        }
        _messageStreamController.sink.add(argument);
      },

      onResume: (info) async {
      },

      onLaunch: (info) async {
      },
    );
  }

  dispose(){
    _messageStreamController?.close();
  }
}