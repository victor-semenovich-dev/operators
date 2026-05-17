// import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/intercom/ui/route/home_route.dart';
import 'package:operators/src/intercom/ui/route/settings_route.dart';
import 'package:operators/src/ui/authorization/authorization_provider.dart';
import 'package:operators/src/ui/home/home_bloc.dart';
import 'package:operators/src/ui/home/widget/add_edit_event.dart';
import 'package:operators/src/ui/home/widget/confirmation_dialog.dart';
import 'package:operators/src/ui/home/widget/notification_confirmation_dialog.dart';
import 'package:operators/src/ui/home/widget/sort_dropdown.dart';
import 'package:operators/src/ui/home/widget/table_inactive_events_dialog.dart';
import 'package:operators/src/ui/home/widget/table_widget.dart';

class HomeScreen extends StatelessWidget {
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
                      case 'settings':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsRoute(),
                          ),
                        );
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
                      if (state.isAdmin)
                        PopupMenuItem<String>(
                          value: 'settings',
                          child: Text('Настройки'),
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
            onCancelAppointmentsClick: cubit.cancelAppointments,
            onNotificationClick: (event) {
              showDialog(
                context: context,
                builder: (context) => NotificationConfirmationDialog(
                  title: 'Уведомление об участии',
                  message:
                      '${event.title}\n\n${cubit.getNotificationText(event)}',
                  telegramConfigs: state.telegramConfigs,
                  onConfirmationClick:
                      (message, telegramConfigs, refreshTable) {
                    cubit.sendMessage(message, telegramConfigs);
                  },
                ),
              );
            },
            onRemindClick: (event) {
              showDialog(
                context: context,
                builder: (context) => NotificationConfirmationDialog(
                  title: 'Напоминание про отметки',
                  message: state.messages['marksReminder'],
                  telegramConfigs: state.telegramConfigs,
                  onConfirmationClick:
                      (message, telegramConfigs, refreshTable) {
                    cubit.sendMessage(message, telegramConfigs);
                  },
                ),
              );
            },
            onRefreshClick: (event) {
              cubit.updateEvents(dateTimeFrom: event.date);
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
