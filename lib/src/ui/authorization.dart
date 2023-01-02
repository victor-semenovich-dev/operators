import 'package:flutter/material.dart';
import 'package:operators/src/bloc/auth.dart';
import 'package:operators/src/ui/reset_password.dart';
import 'package:provider/provider.dart';

class AuthorizationWidget extends StatefulWidget {
  final AuthModel auth;

  const AuthorizationWidget({Key? key, required this.auth}) : super(key: key);

  @override
  _AuthorizationWidgetState createState() => _AuthorizationWidgetState();
}

class _AuthorizationWidgetState extends State<AuthorizationWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.auth.addListener(_authListener);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    widget.auth.removeListener(_authListener);
  }

  void _authListener() {
    final auth = Provider.of<AuthModel>(context, listen: false);
    if (auth.currentUser != null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(builder: (context, auth, child) {
      final errorMessage = auth.errorMessage;
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
                    onFieldSubmitted: (value) {
                      final state = _formKey.currentState;
                      if (state != null && state.validate()) {
                        auth.login(
                            _emailController.text, _passwordController.text);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Заполните поле';
                      }
                      return null;
                    },
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        errorMessage,
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
                builder: (context) =>
                    ResetPasswordWidget(initialEmail: _emailController.text),
              );
            },
          ),
          TextButton(
            child: Text('Войти'),
            onPressed: () {
              final state = _formKey.currentState;
              if (state != null && state.validate()) {
                auth.login(_emailController.text, _passwordController.text);
              }
            },
          ),
        ],
      );
    });
  }
}
