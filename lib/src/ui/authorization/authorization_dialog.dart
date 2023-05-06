import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/ui/authorization/authorization_bloc.dart';
import 'package:operators/src/ui/authorization/reset_password/reset_password_provider.dart';

class AuthorizationDialog extends StatefulWidget {
  const AuthorizationDialog({Key? key}) : super(key: key);

  @override
  _AuthorizationDialogState createState() => _AuthorizationDialogState();
}

class _AuthorizationDialogState extends State<AuthorizationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(
      () => context.read<AuthorizationCubit>().consumeError(),
    );
    _passwordController.addListener(
      () => context.read<AuthorizationCubit>().consumeError(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthorizationCubit, AuthorizationState>(
      listener: (context, state) {
        if (state.isLoggedIn) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Text('Авторизация'),
          content: Wrap(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: "Email"),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Заполните поле';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(hintText: "Пароль"),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) => _login(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
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
                      ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Сброс пароля'),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => ResetPasswordDialogProvider(
                      initialEmail: _emailController.text),
                );
              },
            ),
            TextButton(
              child: Text('Войти'),
              onPressed: () => _login(),
            ),
          ],
        );
      },
    );
  }

  _login() async {
    final cubit = context.read<AuthorizationCubit>();
    final state = _formKey.currentState;
    if (state != null && state.validate()) {
      cubit.login(_emailController.text, _passwordController.text);
    }
  }
}
