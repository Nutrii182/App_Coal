
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coal/src/shared/preferences_user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications {

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final _pref = new PreferencesUser();
  final dbReference = Firestore.instance;

  final _messageStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get message => _messageStreamController.stream;

  initNotifications(){

    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token){
      print(token);
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
        print(info);
      },

      onLaunch: (info) async {
        print(info);
      },
    );
  }

  dispose(){
    _messageStreamController?.close();
  }
}