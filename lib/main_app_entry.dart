import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dane_reacher/error_handling_screen/error_screen.dart';
import 'package:dane_reacher/routes/app_routes.dart';
import 'package:dane_reacher/utils/app_size.dart';
import 'package:dane_reacher/utils/app_theme_configuration.dart';
import 'package:dane_reacher/utils/observer/logger_ob_server.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final AppRoutes appRoutes = AppRoutes.instance;
final GlobalKey<OverlayState> appOverlayKey = GlobalKey<OverlayState>();

class MainAppEntry extends StatefulWidget {
  const MainAppEntry({super.key});

  @override
  State<MainAppEntry> createState() => _MainAppEntryState();
}

class _MainAppEntryState extends State<MainAppEntry> {
  Key providerKey = UniqueKey();
  void resetRiverpod() {
    setState(() {
      providerKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    /////////////////
    AppSize.size = MediaQuery.of(context).size;

    //////////////// main services
    return ProviderScope(key: providerKey, observers: [LoggerObServer()], child: MainApp());
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      routerConfig: appRoutes.router,
      title: "dane_reacher",
      color: Colors.white,
      themeAnimationCurve: Curves.easeInOut,
      themeAnimationDuration: Duration.zero,
      theme: AppThemeConfiguration.instance.lightThemeData,
      darkTheme: AppThemeConfiguration.instance.darkThemeData,
      themeMode: ThemeMode.light,

      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return Overlay(
            key: appOverlayKey,
            initialEntries: [OverlayEntry(builder: (context) => ErrorScreen())],
          );
        };

        return Overlay(
          key: appOverlayKey,
          initialEntries: [OverlayEntry(builder: (context) => child ?? SizedBox())],
        );
      },
    );
  }
}
