import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final appLocaleProvider = StateProvider<Locale>((ref) => const Locale('zh'));

const appSupportedLocales = [Locale('zh'), Locale('en')];

class LocalizedText {
  const LocalizedText({required this.zh, required this.en});

  final String zh;
  final String en;

  String resolve(BuildContext context) => context.tr(zh, en);

  String resolveByCode(String languageCode) => languageCode == 'zh' ? zh : en;

  LocalizedText copyWith({String? zh, String? en}) {
    return LocalizedText(zh: zh ?? this.zh, en: en ?? this.en);
  }
}

extension BuildContextLocaleX on BuildContext {
  Locale get appLocale => Localizations.localeOf(this);

  bool get isZh => appLocale.languageCode == 'zh';

  String tr(String zh, String en) => isZh ? zh : en;

  String formatShortDate(DateTime date) {
    if (isZh) {
      return '${date.month}月${date.day}日';
    }

    return DateFormat('MMM d', 'en').format(date);
  }

  String formatMonthDay(DateTime date) {
    if (isZh) {
      return '${date.month}月${date.day}日';
    }

    return DateFormat('MMM d', 'en').format(date);
  }
}
