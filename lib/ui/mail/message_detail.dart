import 'package:flutter/material.dart';

class MessageDetail extends StatelessWidget {
  String text;
  MessageDetail(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Сообщение'),
          backgroundColor: Colors.blue,
        ),
        body: CustomScrollView(slivers: <Widget>[
          SliverList(
              delegate: SliverChildBuilderDelegate((context, int i) {
            return Column(
              children: <Widget>[
                Text(text),
              ],
            );
          }, childCount: 1))
        ]));
  }
}
