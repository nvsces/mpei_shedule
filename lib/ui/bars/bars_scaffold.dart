import 'package:flutter/material.dart';
import 'package:mpeischedule/ui/bars/bars_page.dart';

class BarsScaffold extends StatelessWidget {
  const BarsScaffold({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Барс МЭИ'),
      ),
      body: BarsPage(),
    );
  }
}
