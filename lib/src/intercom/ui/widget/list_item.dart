import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String _title;
  final Function _callback;

  ListItem(this._title, this._callback);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _callback.call(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Text(_title,
            style: TextStyle(
              fontSize: 22,
            )),
      ),
    );
  }
}
