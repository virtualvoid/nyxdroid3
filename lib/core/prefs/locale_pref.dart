// author: juraj.suchan@gmail.com

import 'dart:ui';

const supportedLanguageCodes = ['en', 'cs'];

Locale? localeFromPref(String value) =>
    supportedLanguageCodes.contains(value) ? Locale(value) : null;
