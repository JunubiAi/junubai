import 'package:buai/app.dart';
import 'package:buai/firebase_options.dart';
import 'package:buai/gemini_options.dart';
import 'package:buai/models/chat_content_model.dart';
import 'package:buai/models/chat_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((message) {
    print(' FCM on message  : ${message.notification?.title}');
  });

  Gemini.init(apiKey: GeminiOptions.googleApiKey);

  await Hive.initFlutter();

  Hive.registerAdapter(ChatModelAdapter());
  Hive.registerAdapter(ChatContentModelAdapter());

  runApp(const App());
}
