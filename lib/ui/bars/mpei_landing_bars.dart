import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/auth_mpei_services/auth_services_bloc.dart';
import 'package:mpeischedule/bloc/auth_mpei_services/auth_services_event.dart';
import 'package:mpeischedule/bloc/auth_mpei_services/auth_services_state.dart';
import 'package:mpeischedule/ui/bars/auth_mpei.dart';
import 'package:mpeischedule/ui/bars/bars_page.dart';

class MpeiLandingPageBars extends StatelessWidget {
  const MpeiLandingPageBars({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MpeiAuthBloc, MpeiAuthState>(builder: (context, state) {
      final MpeiAuthBloc mpeiAuthBloc = BlocProvider.of(context);
      if (state is MpeiFirstState) {
        mpeiAuthBloc.add(MpeiCheckAuthEvent());
        return Center(child: CircularProgressIndicator());
      }
      if (state is MpeiLoginState) {
        return BarsPage();
      }
      if (state is MpeiNotLogginState) {
        return AuthMpei();
      }
      return Center(child: Text('Ошибка'));
    });
  }
}
