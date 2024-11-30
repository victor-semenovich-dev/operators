import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'intercom/ui/route/intercom_route.dart';

class OperatorsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Интерком',
      theme: ThemeData(
        useMaterial3: false,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ru'),
      ],
      home: IntercomRoute(),
    );
  }
}
