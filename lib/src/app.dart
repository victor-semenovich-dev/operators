import 'package:flutter/material.dart';
import 'package:operators/src/bloc/auth.dart';
import 'package:operators/src/ui/home.dart';
import 'package:provider/provider.dart';

class OperatorsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
