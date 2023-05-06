import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/ui/authorization/reset_password/reset_password_bloc.dart';
import 'package:operators/src/ui/authorization/reset_password/reset_password_dialog.dart';

class ResetPasswordDialogProvider extends StatelessWidget {
  final String initialEmail;

  const ResetPasswordDialogProvider({Key? key, required this.initialEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(context.read()),
      child: ResetPasswordDialog(initialEmail: initialEmail),
    );
  }
}
