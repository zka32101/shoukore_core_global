import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'home_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const ShoukoreExampleApp());
}

class ShoukoreExampleApp extends StatefulWidget {
  const ShoukoreExampleApp({super.key});

  @override
  State<ShoukoreExampleApp> createState() => _ShoukoreExampleAppState();
}

class _ShoukoreExampleAppState extends State<ShoukoreExampleApp> {
  Locale _locale = const Locale('pt', 'BR');

  void _setLocale(Locale locale) => setState(() => _locale = locale);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(onLocaleChanged: _setLocale),
    );
  }
}
