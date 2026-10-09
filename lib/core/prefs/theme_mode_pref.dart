// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

const themeModeValues = ['system', 'dark', 'light'];

ThemeMode themeModeFromPref(String value) => switch (value) {
  'dark' => ThemeMode.dark,
  'light' => ThemeMode.light,
  _ => ThemeMode.system,
};

bool isDarkFor(String value, {required bool systemDark}) => switch (value) {
  'dark' => true,
  'light' => false,
  _ => systemDark,
};
