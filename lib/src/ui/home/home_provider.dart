import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/ui/home/home_bloc.dart';
import 'package:operators/src/ui/home/home_screen.dart';

class HomeScreenProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeCubit(context.read(), context.read(), context.read()),
      child: HomeScreen(),
    );
  }
}
