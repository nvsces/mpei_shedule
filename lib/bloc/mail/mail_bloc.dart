import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/mail/mail_event.dart';
import 'package:mpeischedule/bloc/mail/mail_state.dart';
import 'package:mpeischedule/models/mail_header.dart';
import 'package:mpeischedule/sevices/mail_repository.dart';

class MailBloc extends Bloc<MailEvent, MailState> {
  final MailRepository mailRepository;

  MailBloc(this.mailRepository) : super(MailFirstState());

  @override
  Stream<MailState> mapEventToState(MailEvent event) async* {
    if (event is MailLoadEvent) {
      yield MailLoadingState();
      try {
        final List<MailHeader> mail = await mailRepository.getListHeader();
        //final List<String> ref = await mailRepository.getListRef();
        //final List<String> text = await mailRepository.getListText(ref);
        List<String> text = List(20);
        yield MailLoadedState(listHeader: mail, text: text);
      } catch (_) {
        yield MailEmptyState();
      }
    }
  }
}
