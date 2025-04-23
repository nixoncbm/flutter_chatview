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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hoy`
  String get today {
    return Intl.message('Hoy', name: 'today', desc: '', args: []);
  }

  /// `Ayer`
  String get yesterday {
    return Intl.message('Ayer', name: 'yesterday', desc: '', args: []);
  }

  /// `Respondido a ti`
  String get repliedToYou {
    return Intl.message(
      'Respondido a ti',
      name: 'repliedToYou',
      desc: '',
      args: [],
    );
  }

  /// `Respondido por`
  String get repliedBy {
    return Intl.message(
      'Respondido por',
      name: 'repliedBy',
      desc: '',
      args: [],
    );
  }

  /// `Más`
  String get more {
    return Intl.message('Más', name: 'more', desc: '', args: []);
  }

  /// `Deshacer`
  String get unsend {
    return Intl.message('Deshacer', name: 'unsend', desc: '', args: []);
  }

  /// `Responder`
  String get reply {
    return Intl.message('Responder', name: 'reply', desc: '', args: []);
  }

  /// `Respondiendo a`
  String get replyTo {
    return Intl.message('Respondiendo a', name: 'replyTo', desc: '', args: []);
  }

  /// `Mensaje`
  String get message {
    return Intl.message('Mensaje', name: 'message', desc: '', args: []);
  }

  /// `Toca y mantén para multiplicar tu reacción`
  String get reactionPopupTitle {
    return Intl.message(
      'Toca y mantén para multiplicar tu reacción',
      name: 'reactionPopupTitle',
      desc: '',
      args: [],
    );
  }

  /// `Foto`
  String get photo {
    return Intl.message('Foto', name: 'photo', desc: '', args: []);
  }

  /// `Enviar`
  String get send {
    return Intl.message('Enviar', name: 'send', desc: '', args: []);
  }

  /// `Tú`
  String get you {
    return Intl.message('Tú', name: 'you', desc: '', args: []);
  }

  /// `Ningún mensaje`
  String get noMessages {
    return Intl.message(
      'Ningún mensaje',
      name: 'noMessages',
      desc: '',
      args: [],
    );
  }

  /// `Algo salió mal !!`
  String get somethingWentWrong {
    return Intl.message(
      'Algo salió mal !!',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Recargar`
  String get reload {
    return Intl.message('Recargar', name: 'reload', desc: '', args: []);
  }

  /// `Informe`
  String get report {
    return Intl.message('Informe', name: 'report', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'es'),
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
