import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/bloc/table.dart';
import 'package:operators/src/ui/authorization/authorization_provider.dart';
import 'package:operators/src/ui/home/home_bloc.dart';
import 'package:operators/src/ui/home/widget/table.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().updateUserFcmData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.isResetPasswordCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Письмо со сбросом пароля отправлено на почту'),
          ));
          context.read<HomeCubit>().consumeResetPasswordState();
        }
      },
      builder: (context, state) {
        return Consumer<TableModel>(builder: (context, table, child) {
          final user = table.userList?.firstWhereOrNull(
              (user) => user.uid == state.currentFirebaseUser?.uid);
          return Scaffold(
            appBar: AppBar(
              title: !state.isLoggedIn
                  ? Text('Только просмотр')
                  : user == null
                      ? Container()
                      : Text(user.name),
              actions: [
                if (!state.isLoggedIn)
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AuthorizationDialogProvider(),
                      );
                    },
                    icon: Icon(Icons.login),
                    tooltip: 'Авторизация',
                  ),
                if (state.isLoggedIn)
                  IconButton(
                    onPressed: () => context.read<HomeCubit>().logout(),
                    icon: Icon(Icons.logout),
                    tooltip: 'Выход',
                  ),
                if (state.isLoggedIn)
                  PopupMenuButton<String>(
                    tooltip: 'Меню',
                    onSelected: (value) async {
                      switch (value) {
                        case 'password':
                          context.read<HomeCubit>().resetPassword();
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
            body: TableWidget(table, table.tableData, state),
          );
        });
      },
    );
  }
}
