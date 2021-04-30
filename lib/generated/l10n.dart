// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Моё приложение`
  String get mail_title_app {
    return Intl.message(
      'Моё приложение',
      name: 'mail_title_app',
      desc: '',
      args: [],
    );
  }

  /// `Расписание`
  String get shedule {
    return Intl.message(
      'Расписание',
      name: 'shedule',
      desc: '',
      args: [],
    );
  }

  /// `ДEНЬ САМОСТОЯТЕЛЬНЫХ ЗАНЯТИЙ`
  String get free_day_title {
    return Intl.message(
      'ДEНЬ САМОСТОЯТЕЛЬНЫХ ЗАНЯТИЙ',
      name: 'free_day_title',
      desc: '',
      args: [],
    );
  }

  /// `Номер группы`
  String get input_name_group_label {
    return Intl.message(
      'Номер группы',
      name: 'input_name_group_label',
      desc: '',
      args: [],
    );
  }

  /// `Продолжить`
  String get landing_btn_label {
    return Intl.message(
      'Продолжить',
      name: 'landing_btn_label',
      desc: '',
      args: [],
    );
  }

  /// `Расписание группы не найдено`
  String get error_shedule {
    return Intl.message(
      'Расписание группы не найдено',
      name: 'error_shedule',
      desc: '',
      args: [],
    );
  }

  /// `Выбрать группу`
  String get choose_group_label {
    return Intl.message(
      'Выбрать группу',
      name: 'choose_group_label',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
