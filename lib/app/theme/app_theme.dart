import 'package:flutter/material.dart';

import 'noir_palette.dart';

class AppTheme {
  static ThemeData dark() {
    const seed = NoirPalette.cyan;
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ).copyWith(
          primary: NoirPalette.cyan,
          secondary: NoirPalette.magenta,
          tertiary: NoirPalette.electricBlue,
          surface: NoirPalette.panel,
          onSurface: NoirPalette.textPrimary,
          primaryContainer: NoirPalette.electricBlue.withValues(alpha: 0.18),
          onPrimaryContainer: NoirPalette.textPrimary,
          secondaryContainer: NoirPalette.magenta.withValues(alpha: 0.14),
          onSecondaryContainer: NoirPalette.textPrimary,
          error: NoirPalette.danger,
          onError: Colors.white,
          outline: NoirPalette.border,
          surfaceTint: Colors.transparent,
        );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      scaffoldBackgroundColor: NoirPalette.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: NoirPalette.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        toolbarHeight: 60,
      ),
      dividerTheme: DividerThemeData(
        color: NoirPalette.border.withValues(alpha: 0.9),
      ),
      cardTheme: CardThemeData(
        color: NoirPalette.panelGlass,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: NoirPalette.border.withValues(alpha: 0.95)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: NoirPalette.panelGlass,
        indicatorColor: NoirPalette.cyan.withValues(alpha: 0.14),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected
                ? NoirPalette.textPrimary
                : NoirPalette.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? NoirPalette.cyan : NoirPalette.textSecondary,
          );
        }),
        height: 68,
      ),
      navigationDrawerTheme: const NavigationDrawerThemeData(
        backgroundColor: NoirPalette.panel,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: NoirPalette.cyan.withValues(alpha: 0.14),
        selectedIconTheme: const IconThemeData(color: NoirPalette.cyan),
        unselectedIconTheme: const IconThemeData(
          color: NoirPalette.textSecondary,
        ),
        selectedLabelTextStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          color: NoirPalette.textPrimary,
        ),
        unselectedLabelTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: NoirPalette.textSecondary,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: NoirPalette.cyan,
        linearTrackColor: NoirPalette.border,
        circularTrackColor: NoirPalette.border,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: NoirPalette.electricBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          elevation: 0,
          shadowColor: NoirPalette.electricBlue.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: NoirPalette.cyan.withValues(alpha: 0.34)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: NoirPalette.textPrimary,
          backgroundColor: NoirPalette.panelSoft.withValues(alpha: 0.70),
          side: BorderSide(color: NoirPalette.border.withValues(alpha: 0.95)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return NoirPalette.electricBlue.withValues(alpha: 0.24);
            }
            return NoirPalette.panelSoft.withValues(alpha: 0.72);
          }),
          foregroundColor: const WidgetStatePropertyAll(
            NoirPalette.textPrimary,
          ),
          side: WidgetStateProperty.resolveWith((states) {
            final color = states.contains(WidgetState.selected)
                ? NoirPalette.cyan
                : NoirPalette.border;
            return BorderSide(color: color.withValues(alpha: 0.92));
          }),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NoirPalette.panelSoft.withValues(alpha: 0.85),
        hintStyle: const TextStyle(color: NoirPalette.textMuted),
        labelStyle: const TextStyle(color: NoirPalette.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: NoirPalette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: NoirPalette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: NoirPalette.cyan, width: 1.4),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: NoirPalette.panel,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      textTheme: base.textTheme.copyWith(
        displaySmall: base.textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
          color: NoirPalette.textPrimary,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: NoirPalette.textPrimary,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: NoirPalette.textPrimary,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: NoirPalette.textPrimary,
          letterSpacing: -0.2,
        ),
        labelLarge: base.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: NoirPalette.textSecondary,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          height: 1.35,
          color: NoirPalette.textPrimary,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          height: 1.4,
          color: NoirPalette.textSecondary,
        ),
      ),
    );
  }
}
