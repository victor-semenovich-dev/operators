import 'package:flutter/material.dart';
import 'package:operators/src/bloc/auth.dart';
import 'package:operators/src/bloc/table.dart';
import 'package:operators/src/data/table.dart';
import 'package:operators/src/data/user.dart';
import 'package:operators/src/ui/authorization.dart';
import 'package:operators/src/ui/table.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final tableBloc = TableBloc();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(builder: (context, auth, child) {
      return Scaffold(
        appBar: AppBar(
          title: auth.currentUser == null
              ? Text('Только просмотр')
              : StreamBuilder<List<User>>(
                  stream: tableBloc.usersStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final user = snapshot.data.firstWhere(
                          (user) => user.uid == auth.currentUser.uid);
                      return Text(user.name);
                    } else {
                      return Container();
                    }
                  },
                ),
          actions: [
            if (auth.currentUser == null)
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AuthorizationWidget(),
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
        body: SafeArea(
          child: StreamBuilder<TableData>(
              stream: tableBloc.tableStream,
              builder: (context, snapshot) {
                return TableWidget(tableBloc, snapshot.data);
              }),
        ),
      );
    });
  }
}
