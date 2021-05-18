import 'package:flutter/material.dart';

class ItemRow extends StatelessWidget {
  ItemRow({
    required this.icon,
    required this.labelText,
  });
  Icon icon;
  String labelText;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        icon,
        Text(labelText, textAlign: TextAlign.start),
      ],
    );
  }
}
