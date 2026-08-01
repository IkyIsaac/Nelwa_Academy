import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'admin_auth_notifier.dart';
import 'admin_router.dart';
import 'design/admin_tokens.dart';

class AdminApp extends StatefulWidget {
  const AdminApp({super.key});

  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  late final AdminAuthNotifier _authNotifier;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authNotifier = AdminAuthNotifier();
    _router = createAdminRouter(_authNotifier);
  }

  @override
  void dispose() {
    _authNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Nelwa Academy Admin',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AdminColors.oxblood,
          primary: AdminColors.oxblood,
          secondary: AdminColors.terracotta,
        ),
        scaffoldBackgroundColor: AdminColors.canvas,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AdminColors.oxblood,
          selectionHandleColor: AdminColors.oxblood,
        ),
      ),
      routerConfig: _router,
    );
  }
}
