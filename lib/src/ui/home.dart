import 'package:flutter/material.dart';
import 'package:operators/src/bloc/table.dart';
import 'package:operators/src/data/table.dart';
import 'package:operators/src/ui/table.dart';

class HomeScreen extends StatelessWidget {

  final tableBloc = TableBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<TableData>(
          stream: tableBloc.tableStream,
          builder: (context, snapshot) {
            print('data: ${snapshot.data}');
            return TableWidget(tableBloc, snapshot.data);
          }
        ),
      )
    );
  }
}