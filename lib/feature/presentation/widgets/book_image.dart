import 'package:flutter/material.dart';
import 'package:mpeischedule/generated/l10n.dart';

class BookImage extends StatelessWidget {
  const BookImage();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(30),
          child: Image.asset(
            'assets/image/book.png',
            scale: 1,
          ),
        ),
        Text(
          S.of(context).free_day_title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).appBarTheme.iconTheme!.color,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
