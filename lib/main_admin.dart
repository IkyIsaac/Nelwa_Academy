import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'backend/firebase/firebase_config.dart';
import 'admin/admin_app.dart';

/// Entry point for the browser-only admin portal. Built and hosted
/// separately from lib/main.dart (the Play Store/App Store app) — nothing
/// under lib/admin/ is imported by the mobile entry point, and nothing here
/// imports it, so each build only contains what it needs.
///
/// Run with: flutter run -d chrome -t lib/main_admin.dart
/// Build with: flutter build web -t lib/main_admin.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await initFirebase();

  runApp(const AdminApp());
}
