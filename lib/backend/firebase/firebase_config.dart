import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB1eRpBBatM6yDOuGUC0ptSARa_5ufHDQ4",
            authDomain: "nelwasacademy-7uw9xf.firebaseapp.com",
            projectId: "nelwasacademy-7uw9xf",
            storageBucket: "nelwasacademy-7uw9xf.firebasestorage.app",
            messagingSenderId: "91236738139",
            appId: "1:91236738139:web:5540a75442015e64a88b7e"));
  } else {
    await Firebase.initializeApp();
  }
}
