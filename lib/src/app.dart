import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:operators/src/data/repository/auth.dart';
import 'package:operators/src/data/repository/events.dart';
import 'package:operators/src/data/repository/fcm.dart';
import 'package:operators/src/data/repository/table.dart';
import 'package:operators/src/data/repository/telegram.dart';
import 'package:operators/src/intercom2/ui/route/intercom_route.dart';

class OperatorsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => FcmRepository()),
        RepositoryProvider(create: (context) => TableRepository()),
        RepositoryProvider(create: (context) => EventsRepository()),
        RepositoryProvider(create: (context) => TelegramRepository()),
      ],
      child: MaterialApp(
        title: 'Интерком',
        theme: ThemeData(
          scrollbarTheme: ScrollbarThemeData(
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
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
      ),
    );
  }
}
