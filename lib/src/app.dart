import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/bloc/table.dart';
import 'package:operators/src/data/repository/auth.dart';
import 'package:operators/src/data/repository/fcm.dart';
import 'package:operators/src/data/repository/table.dart';
import 'package:operators/src/ui/home/home_provider.dart';
import 'package:provider/provider.dart';

class OperatorsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TableModel()),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => AuthRepository()),
          RepositoryProvider(create: (context) => FcmRepository()),
          RepositoryProvider(create: (context) => TableRepository()),
        ],
        child: MaterialApp(
          title: 'Участие операторов',
          home: HomeScreenProvider(),
        ),
      ),
    );
  }
}
