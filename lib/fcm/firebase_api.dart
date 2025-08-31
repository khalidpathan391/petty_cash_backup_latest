import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:petty_cash/data/sources/local/shared_preference.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification!.title!}');
  print('Body:  ${message.notification!.body!}');
  print('Title: ${message.data}');
}

class FirebaseApi {
  final _fireMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    NotificationSettings settings = await _fireMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted provisional permission');
    } else {
      print('denied');
    }
    final FCMToken = await _fireMessaging.getToken();
    print('Token====>>   $FCMToken');
    DataPreferences.saveData('firebaseToken', FCMToken.toString());

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
