import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/ui/authorization/reset_password/reset_password_bloc.dart';

class ResetPasswordDialog extends StatefulWidget {
  final String initialEmail;

  const ResetPasswordDialog({Key? key, required this.initialEmail})
      : super(key: key);

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmail;
    _emailController.addListener(() {
      context.read<ResetPasswordCubit>().consumeError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
      if (state.isResetCompleted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Письмо со сбросом пароля отправлено на почту'),
        ));
      }
    }, builder: (context, state) {
      return AlertDialog(
        title: Text('Сброс пароля'),
        content: Wrap(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: "Email"),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) => _resetPassword(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Заполните поле';
                      }
                      return null;
                    },
                  ),
                  if (state.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        state.error ?? '',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Сбросить пароль'),
            onPressed: () => _resetPassword(),
          ),
        ],
      );
    });
  }

  _resetPassword() async {
    final state = _formKey.currentState;
    if (state != null && state.validate()) {
      final email = _emailController.text;
      context.read<ResetPasswordCubit>().resetPassword(email);
    }
  }
}
