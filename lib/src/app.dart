import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:operators/src/data/repository/auth.dart';
import 'package:operators/src/data/repository/events.dart';
import 'package:operators/src/data/repository/fcm.dart';
import 'package:operators/src/data/repository/table.dart';
import 'package:operators/src/data/repository/telegram.dart';
import 'package:operators/src/ui/home/home_provider.dart';

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
        title: 'Участие операторов',
        theme: ThemeData(
          scrollbarTheme: ScrollbarThemeData(
            thumbVisibility: WidgetStateProperty.all<bool>(true),
          ),
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
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
        home: HomeScreenProvider(),
      ),
    );
  }
}
