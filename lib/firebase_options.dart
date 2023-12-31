// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyANJFTaWzTrvJq5hSVpKZAY2Hw-7vjXy-0',
    appId: '1:340715548910:web:838eb0cde7246fd2c743ff',
    messagingSenderId: '340715548910',
    projectId: 'flutter-kkwabaegi-0',
    authDomain: 'flutter-kkwabaegi-0.firebaseapp.com',
    storageBucket: 'flutter-kkwabaegi-0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCxgu3bh9mw4jEHS-HfmtHa0vMWwqxiQco',
    appId: '1:340715548910:android:75cd92c1eb6ddc4fc743ff',
    messagingSenderId: '340715548910',
    projectId: 'flutter-kkwabaegi-0',
    storageBucket: 'flutter-kkwabaegi-0.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB3sil45UeJwSTtMRZWPOR5n_hjnDPOVr0',
    appId: '1:340715548910:ios:22ffb2ce852ec1b1c743ff',
    messagingSenderId: '340715548910',
    projectId: 'flutter-kkwabaegi-0',
    storageBucket: 'flutter-kkwabaegi-0.appspot.com',
    iosBundleId: 'com.example.flutterCafeAdmin.RunnerTests',
  );
}
