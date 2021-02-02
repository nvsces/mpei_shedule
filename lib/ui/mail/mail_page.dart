import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/mail/mail_bloc.dart';
import 'package:mpeischedule/bloc/mail/mail_event.dart';
import 'package:mpeischedule/bloc/mail/mail_state.dart';
import 'package:mpeischedule/sevices/mail_repository.dart';
import 'package:mpeischedule/ui/mail/message_detail.dart';

class MailPage extends StatelessWidget {
  final MailRepository mailRepository = MailRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MailBloc>(
        create: (context) => MailBloc(mailRepository),
        child: BlocBuilder<MailBloc, MailState>(builder: (context, state) {
          final MailBloc mailBloc = BlocProvider.of(context);
          if (state is MailFirstState) {
            mailBloc.add(MailLoadEvent());
            return Expanded(child: Center(child: CircularProgressIndicator()));
          }
          if (state is MailLoadingState) {
            return Expanded(child: Center(child: CircularProgressIndicator()));
          }
          if (state is MailLoadedState) {
            return RefreshIndicator(
              onRefresh: () {
                mailBloc.add(MailLoadEvent());
              },
              child: Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: state.listHeader.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 30,
                      //shadowColor: Colors.redAccent,
                      margin: EdgeInsets.symmetric(vertical: 7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                          title: Text(state.listHeader[index].title),
                          subtitle: Text(state.listHeader[index].author),
                          trailing: Text(state.listHeader[index].dateTime),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      MessageDetail(state.text[index])))),
                      //MessageDetail()))),
                    );
                  },
                ),
              ),
            );
          }
          return RefreshIndicator(
              onRefresh: () {
                mailBloc.add(MailLoadEvent());
              },
              child: Text('Ошибка'));
        }));
  }
}
