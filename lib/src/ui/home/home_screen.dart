// import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/intercom/ui/route/home_route.dart';
import 'package:operators/src/ui/authorization/authorization_provider.dart';
import 'package:operators/src/ui/home/home_bloc.dart';
import 'package:operators/src/ui/home/widget/add_edit_event.dart';
import 'package:operators/src/ui/home/widget/confirmation_dialog.dart';
import 'package:operators/src/ui/home/widget/notification_confirmation_dialog.dart';
import 'package:operators/src/ui/home/widget/sort_dropdown.dart';
import 'package:operators/src/ui/home/widget/table_inactive_events_dialog.dart';
import 'package:operators/src/ui/home/widget/table_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeState? _lastState;

  // Future<void> _initBackgroundFetch() async {
  //   await BackgroundFetch.configure(
  //     BackgroundFetchConfig(
  //       minimumFetchInterval: 12 * 60,
  //       startOnBoot: true,
  //       requiredNetworkType: NetworkType.ANY,
  //     ),
  //     (String taskId) async {
  //       final now = DateTime.now();
  //       if (now.hour >= 21 || now.hour < 9) {
  //         final useCase = SyncEventsUseCase(context.read(), context.read());
  //         await useCase.perform();
  //       }
  //       BackgroundFetch.finish(taskId);
  //     },
  //     (String taskId) async {
  //       // timeout
  //       BackgroundFetch.finish(taskId);
  //     },
  //   );
  //   await BackgroundFetch.start();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        final cubit = context.read<HomeCubit>();

        if (state.isResetPasswordCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Письмо со сбросом пароля отправлено на почту'),
          ));
          cubit.consumeResetPasswordState();
        }

        final sendNotificationResult =
            cubit.getNotificationResultReadableText();
        if (sendNotificationResult != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(sendNotificationResult),
          ));
          cubit.consumeSendNotificationResult();
        }

        final syncResult = cubit.getSyncResultText();
        if (syncResult != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(syncResult),
          ));
          cubit.consumeSyncEventsResult();
        }

        // if (!kIsWeb && _lastState?.isAdmin != state.isAdmin) {
        //   if (state.isAdmin) {
        //     _initBackgroundFetch();
        //   } else {
        //     BackgroundFetch.stop();
        //   }
        // }

        if (_lastState == null ||
            _lastState?.currentUser?.id != state.currentUser?.id) {
          cubit.updateUserFcmData();
        }
        _lastState = state;
      },
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return Scaffold(
          appBar: AppBar(
            title: !state.isLoggedIn
                ? Text('Только просмотр')
                : state.currentUser == null
                    ? Container()
                    : Text(state.currentUser?.name ?? ''),
            actions: [
              if (state.showIntercomOption)
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IntercomRoute(
                          user: state.currentUser,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.videocam_outlined),
                  tooltip: 'Интерком',
                ),
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
              if (state.isAdmin)
                SortDropdown(
                  selectedItem: state.sortType,
                  onItemSelected: cubit.setSortType,
                ),
              if (state.isAdmin)
                if (state.syncInProgress)
                  Container(
                    width: 48,
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                else
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
                      case 'add_event':
                        showDialog(
                          context: context,
                          builder: (context) => AddEditEventDialog(
                            onConfirmClick: cubit.addEvent,
                          ),
                        );
                        break;
                      case 'toggle_inactive_users':
                        cubit.showAllUsers(!state.showAllUsers);
                        break;
                      case 'toggle_inactive_events':
                        showDialog(
                          context: context,
                          builder: (context) => TableInactiveEventsDialog(
                            allEvents: state.inactiveEvents,
                            visibleEvents: state.inactiveVisibleEvents,
                            applyForcedVisibleEvents:
                                cubit.applyForcedVisibleEvents,
                          ),
                        );
                        break;
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
                      if (state.isAdmin)
                        PopupMenuItem<String>(
                          value: 'add_event',
                          child: Text('Добавить событие'),
                        ),
                      if (state.isAdmin)
                        PopupMenuItem<String>(
                          value: 'toggle_inactive_users',
                          child: Text(state.showAllUsers
                              ? 'Скрыть неактивных пользователей'
                              : 'Показать всех пользователей'),
                        ),
                      if (state.isAdmin)
                        PopupMenuItem<String>(
                          value: 'toggle_inactive_events',
                          child: Text('Показать неактивные события'),
                        ),
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
            state: state,
            onToggleCanHelp: context.read<HomeCubit>().toggleCanHelp,
            onRoleSelected: context.read<HomeCubit>().onRoleSelected,
            onCanHelpSelected: context.read<HomeCubit>().onCanHelpSelected,
            onNotificationClick: (event) {
              final text = cubit.getNotificationText(event);
              showDialog(
                context: context,
                builder: (context) => NotificationConfirmationDialog(
                  title: event.title,
                  message: text,
                  telegramConfigs: state.telegramConfigs,
                  onConfirmationClick: (telegramConfigs) {
                    cubit.sendNotification(
                      event.title,
                      text,
                      telegramConfigs,
                    );
                  },
                ),
              );
            },
            onRemindClick: (event) {
              final users = cubit.getMissedMarksUsers(event);
              showDialog(
                context: context,
                builder: (context) => NotificationConfirmationDialog(
                  message: users.map((e) => e.name).join('\n'),
                  telegramConfigs: state.telegramConfigs,
                  telegramInitialValue: cubit.getRemindTelegramDefaultValue(),
                  onConfirmationClick: (telegramConfigs) {
                    cubit.sendRemind(
                      event,
                      users,
                      telegramConfigs,
                    );
                  },
                ),
              );
            },
            onEditClick: (event) {
              showDialog(
                context: context,
                builder: (context) => AddEditEventDialog(
                  initialDateTime: event.date,
                  initialTitle: event.title,
                  onConfirmClick: (dateTime, title) =>
                      cubit.updateEvent(event.id, dateTime, title),
                ),
              );
            },
            onHideClick: (event) {
              showDialog(
                context: context,
                builder: (context) => ConfirmationDialog(
                  message: 'Скрыть событие "${event.title}"?',
                  onConfirmationClick: () => cubit.hideEvent(event),
                ),
              );
            },
            onDeleteClick: (event) {
              showDialog(
                context: context,
                builder: (context) => ConfirmationDialog(
                  message:
                      'Удалить событие "${event.title}"? Отметки пользователей также будут удалены.',
                  onConfirmationClick: () => cubit.deleteEvent(event),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
