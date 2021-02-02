import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/bars/bars_bloc.dart';
import 'package:mpeischedule/bloc/bars/bars_event.dart';
import 'package:mpeischedule/bloc/bars/bars_state.dart';
import 'package:mpeischedule/sevices/bars_repository.dart';

class BarsPage extends StatelessWidget {
  BarsRepository _barsRepository = BarsRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BarsBloc>(
      create: (context) => BarsBloc(_barsRepository),
      child: BlocBuilder<BarsBloc, BarsState>(
        builder: (context, state) {
          final BarsBloc barsBloc = BlocProvider.of(context);
          if (state is BarsFirstState) {
            barsBloc.add(BarsLoadEvent());
            return Center(child: CircularProgressIndicator());
          }
          if (state is BarsLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is BarsLoadedState) {
            return Center(child: Text(state.username));
          }
          return Center(child: Text("Ошибка"));
        },
      ),
    );
  }
}
