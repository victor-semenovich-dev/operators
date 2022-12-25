import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:operators/src/bloc/auth.dart';
import 'package:operators/src/bloc/table.dart';
import 'package:operators/src/ui/authorization.dart';
import 'package:operators/src/ui/table.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthModel, TableModel>(
        builder: (context, auth, table, child) {
      final user = table.userList
          ?.firstWhereOrNull((user) => user.uid == auth.currentUser?.uid);
      return Scaffold(
        appBar: AppBar(
          title: auth.currentUser == null
              ? Text('Только просмотр')
              : user == null
                  ? Container()
                  : Text(user.name),
          actions: [
            if (auth.currentUser == null)
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AuthorizationWidget(auth: auth),
                  );
                },
                icon: Icon(Icons.login),
                tooltip: 'Авторизация',
              ),
            if (auth.currentUser != null)
              IconButton(
                onPressed: () => auth.logout(),
                icon: Icon(Icons.logout),
                tooltip: 'Выход',
              ),
            if (auth.currentUser != null)
              PopupMenuButton<String>(
                tooltip: 'Меню',
                onSelected: (value) {
                  switch (value) {
                    case 'password':
                      {
                        auth.resetPassword();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Письмо со сбросом пароля отправлено на почту'),
                        ));
                      }
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'password',
                      child: Text('Сменить пароль'),
                    )
                  ];
                },
              )
          ],
        ),
        body: TableWidget(table, table.tableData),
      );
    });
  }
}
