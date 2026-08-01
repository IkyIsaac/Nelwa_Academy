import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'admin_constants.dart';

/// Drives the admin router's redirect logic. Deliberately independent of
/// the mobile app's `AppStateNotifier` (lib/flutter_flow/nav/nav.dart) —
/// the admin module never imports mobile-app code.
class AdminAuthNotifier extends ChangeNotifier {
  AdminAuthNotifier() {
    _sub = FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? _user;
  User? get user => _user;

  /// Interim gate — see admin_constants.dart for why this is an email
  /// check rather than a custom claim.
  bool get isAdmin => _user != null && _user!.email == kAdminEmail;

  late final StreamSubscription<User?> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
