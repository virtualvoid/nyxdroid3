// author: juraj.suchan@gmail.com

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'nyx_colors.dart';
import 'nyx_palette.dart';

class NyxTheme {
  NyxTheme._();

  static ThemeData dark() => _build(
    brightness: Brightness.dark,
    palette: NyxPalette.dark,
    scheme: (base) => base.copyWith(
      surface: NyxColors.darkBackground,
      onSurface: NyxColors.darkText,
      surfaceContainerLowest: NyxColors.darkContainerLowest,
      surfaceContainerLow: NyxColors.darkContainerLow,
      surfaceContainer: NyxColors.darkContainer,
      surfaceContainerHigh: NyxColors.darkContainerHigh,
      surfaceContainerHighest: NyxColors.darkContainerHighest,
    ),
  );

  static ThemeData light() => _build(
    brightness: Brightness.light,
    palette: NyxPalette.light,
    scheme: (base) => base.copyWith(
      surface: NyxColors.lightBackground,
      onSurface: NyxColors.lightText,
      surfaceContainerLowest: NyxColors.lightContainerLowest,
      surfaceContainerLow: NyxColors.lightContainerLow,
      surfaceContainer: NyxColors.lightContainer,
      surfaceContainerHigh: NyxColors.lightContainerHigh,
      surfaceContainerHighest: NyxColors.lightContainerHighest,
    ),
  );

  static ThemeData _build({
    required Brightness brightness,
    required NyxPalette palette,
    required ColorScheme Function(ColorScheme base) scheme,
  }) {
    final colors = scheme(
      ColorScheme.fromSeed(seedColor: NyxColors.seed, brightness: brightness),
    );
    final rounded12 = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );
    final field = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      extensions: [palette],
      scrollbarTheme: ScrollbarThemeData(
        interactive: true,
        radius: const Radius.circular(5),
        minThumbLength: 48,
        thickness: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.dragged) ? 10 : 6,
        ),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => colors.onSurfaceVariant.withValues(
            alpha: states.contains(WidgetState.dragged) ? 0.9 : 0.6,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant.withValues(alpha: 0.5),
        space: 1,
        thickness: 0.5,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerHigh,
        border: field,
        enabledBorder: field,
        disabledBorder: field,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.error),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 44),
          shape: const StadiumBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 44),
          shape: const StadiumBorder(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: const StadiumBorder()),
      ),
      chipTheme: ChipThemeData(
        shape: rounded12,
        side: BorderSide(color: colors.outlineVariant),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceContainerLow,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: rounded12,
        backgroundColor: colors.inverseSurface,
        contentTextStyle: TextStyle(color: colors.onInverseSurface),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colors.surfaceContainerHigh,
        shape: rounded12,
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: colors.outlineVariant.withValues(alpha: 0.5),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.onSurfaceVariant,
        shape: rounded12,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colors.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.surfaceContainerHighest,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
