import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:io';

class PushNotifications {

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final dbReference = Firestore.instance;

  final _messageStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get message => _messageStreamController.stream;

  initNotifications(){

    _firebaseMessaging.requestNotificationPermissions();

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