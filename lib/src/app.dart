import 'package:flutter/material.dart';
import 'package:operators/src/bloc/auth.dart';
import 'package:operators/src/bloc/table.dart';
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
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
