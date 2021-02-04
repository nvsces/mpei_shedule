import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/auth_mpei_services/auth_services_event.dart';
import 'package:mpeischedule/bloc/auth_mpei_services/auth_services_state.dart';
import 'package:mpeischedule/sevices/bars/bars_parser.dart';
import 'package:mpeischedule/sevices/mail/mail_parser.dart';
import 'package:requests/requests.dart' as req;
import 'package:shared_preferences/shared_preferences.dart';

class MpeiAuthBloc extends Bloc<MpeiAuthEvent, MpeiAuthState> {
  MpeiAuthBloc(MpeiAuthState initialState) : super(initialState);

  @override
  Stream<MpeiAuthState> mapEventToState(MpeiAuthEvent event) async* {
    if (event is MpeiCheckAuthEvent) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var yesAuth = preferences.getString('mpei') ?? "";
      if (yesAuth.isNotEmpty) {
        yield MpeiLoginState();
      } else {
        yield MpeiNotLogginState();
      }
    }
    if (event is MpeiExitEvent) {
      req.Requests.clearStoredCookies('https://mail.mpei.ru/owa/');
      req.Requests.clearStoredCookies(bars_base_url);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove('mpei');
      yield MpeiNotLogginState();
    }
    if (event is MpeiLoginEvent) {
      bool successBars = await BarsParser.init(event.login, event.password);
      bool successMail = await MailParser.init(event.login, event.password);
      if (successMail && successBars) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('mpei', 'yes');
        yield MpeiLoginState();
      } else {
        yield MpeiErrorState();
      }
    }
  }
}
