// ignore_for_file: non_constant_identifier_names, avoid_web_libraries_in_flutter, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_manager/window_manager.dart';
import 'Locale/locale.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'Page/Insideview/homeview.dart';
import 'Page/NotFoundPage.dart';
import 'Page/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (GetPlatform.isWindows || GetPlatform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowManager.instance.setMinimumSize(const Size(1200, 600));
    //WindowManager.instance.setMaximumSize(const Size(1200, 600));
  }
  usePathUrlStrategy();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Languages(),
      locale: uiset.locale ?? Get.deviceLocale,
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ko', ''), // Korean
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      fallbackLocale: Get.deviceLocale,
      title: 'V Ridge',
      defaultTransition: Transition.noTransition,
      routes: {
        '/': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const HomePage());
          default:
            return MaterialPageRoute(
                builder: (context) => const NotFoundPage());
        }
      },
    );
  }
}
