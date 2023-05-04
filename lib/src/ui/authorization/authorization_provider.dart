import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/ui/authorization/authorization_bloc.dart';
import 'package:operators/src/ui/authorization/authorization_dialog.dart';

class AuthorizationDialogProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthorizationCubit(context.read()),
      child: AuthorizationDialog(),
    );
  }
}
