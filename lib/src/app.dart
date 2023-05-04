import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/bloc/auth.dart';
import 'package:operators/src/bloc/table.dart';
import 'package:operators/src/data/repository/auth.dart';
import 'package:operators/src/data/repository/fcm.dart';
import 'package:operators/src/ui/home.dart';
import 'package:provider/provider.dart';

class OperatorsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthModel()),
        ChangeNotifierProvider(create: (context) => TableModel()),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository(),
          ),
          RepositoryProvider<FcmRepository>(
            create: (context) => FcmRepository(),
          ),
        ],
        child: MaterialApp(
          title: 'Участие операторов',
          home: HomeScreen(),
        ),
      ),
    );
  }
}
