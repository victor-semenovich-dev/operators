import 'package:flutter/material.dart';
import 'package:operators/src/bloc/auth.dart';
import 'package:provider/provider.dart';

class AuthorizationWidget extends StatefulWidget {
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

    final auth = Provider.of<AuthModel>(context, listen: false);
    auth.addListener(_authListener);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    final auth = Provider.of<AuthModel>(context, listen: false);
    auth.removeListener(_authListener);
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
                      if (value.isEmpty) {
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
                      if (_formKey.currentState.validate()) {
                        auth.login(
                            _emailController.text, _passwordController.text);
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Заполните поле';
                      }
                      return null;
                    },
                  ),
                  if (auth.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        auth.errorMessage,
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
            child: Text('Отмена'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Войти'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                auth.login(_emailController.text, _passwordController.text);
              }
            },
          ),
        ],
      );
    });
  }
}
