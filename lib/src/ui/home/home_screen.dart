import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/data/usecase/sync_events.dart';
import 'package:operators/src/ui/authorization/authorization_provider.dart';
import 'package:operators/src/ui/home/home_bloc.dart';
import 'package:operators/src/ui/home/widget/notification.dart';
import 'package:operators/src/ui/home/widget/table.dart';

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

  Future<void> _initBackgroundFetch() async {
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 24 * 60,
        startOnBoot: true,
        requiredNetworkType: NetworkType.ANY,
      ),
      (String taskId) async {
        final useCase = SyncEventsUseCase(context.read(), context.read());
        await useCase.perform();
        BackgroundFetch.finish(taskId);
      },
      (String taskId) async {
        // timeout
        BackgroundFetch.finish(taskId);
      },
    );
    await BackgroundFetch.start();
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
        if (!kIsWeb) {
          if (state.isAdmin) {
            _initBackgroundFetch();
          } else {
            BackgroundFetch.stop();
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: !state.isLoggedIn
                ? Text('Только просмотр')
                : state.currentUser == null
                    ? Container()
                    : Text(state.currentUser?.name ?? ''),
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
              if (state.isAdmin && !kIsWeb)
                IconButton(
                  onPressed: () => context.read<HomeCubit>().updateEvents(),
                  icon: Icon(Icons.sync),
                  tooltip: 'Обновить',
                ),
              if (state.isLoggedIn)
                PopupMenuButton<String>(
                  tooltip: 'Меню',
                  onSelected: (value) async {
                    switch (value) {
                      case 'password':
                        context.read<HomeCubit>().resetPassword();
                        break;
                      case 'logout':
                        context.read<HomeCubit>().logout();
                        break;
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'password',
                        child: Text('Сменить пароль'),
                      ),
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Выход'),
                      ),
                    ];
                  },
                )
            ],
          ),
          body: TableWidget(
            state,
            context.read<HomeCubit>().toggleCanHelp,
            context.read<HomeCubit>().onRoleSelected,
            context.read<HomeCubit>().onCanHelpSelected,
            (event) {
              final cubit = context.read<HomeCubit>();
              final text = cubit.getNotificationText(event);
              showDialog(
                context: context,
                builder: (context) => NotificationDialog(
                  title: event.title,
                  body: text,
                  onSendClick: () => cubit.sendNotification(event.title, text),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
