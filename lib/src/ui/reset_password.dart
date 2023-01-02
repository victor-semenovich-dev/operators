import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:operators/src/bloc/auth.dart';
import 'package:provider/provider.dart';

class ResetPasswordWidget extends StatefulWidget {
  final String initialEmail;

  const ResetPasswordWidget({Key? key, required this.initialEmail})
      : super(key: key);

  @override
  State<ResetPasswordWidget> createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmail;
    _emailController.addListener(() {
      setState(() => _errorMessage = null);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(builder: (context, auth, child) {
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
                    onFieldSubmitted: (value) => _resetPassword(auth),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Заполните поле';
                      }
                      return null;
                    },
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorMessage ?? '',
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
            onPressed: () => _resetPassword(auth),
          ),
        ],
      );
    });
  }

  _resetPassword(AuthModel auth) async {
    setState(() => _errorMessage = null);
    final state = _formKey.currentState;
    if (state != null && state.validate()) {
      final email = _emailController.text;
      try {
        await auth.resetPassword(customEmail: email);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Письмо со сбросом пароля отправлено на почту'),
        ));
      } on FirebaseAuthException catch (e) {
        setState(() => _errorMessage = e.message);
      }
    }
  }
}
