import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light({AppThemeButtonVariant buttonVariant = .medium}) {
    const white = Colors.white;
    const black = Colors.black;

    final buttonMinSize = AppThemeExtension.buttonSize(buttonVariant);

    return ThemeData(
      extensions: [
        AppThemeExtension(
          buttonVariant: buttonVariant,
          appBarLeadingPadding: .only(left: 8),
          colorScheme: .light(),
        ),
      ],
      colorSchemeSeed: white,
      scaffoldBackgroundColor: white,
      appBarTheme: AppBarTheme(
        backgroundColor: white,
        elevation: 0,
        leadingWidth: 64,
        titleSpacing: 8,
        centerTitle: false,
        actionsPadding: .only(right: 8),
      ),
      drawerTheme: DrawerThemeData(backgroundColor: white),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: black)),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          final color = states.contains(WidgetState.focused) ? black : Colors.grey;
          return TextStyle(color: color);
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: black),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: black,
          foregroundColor: white,
          minimumSize: buttonMinSize,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(foregroundColor: black, minimumSize: buttonMinSize),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: black,
        selectionHandleColor: black,
        selectionColor: black.withValues(alpha: 0.15),
      ),
    );
  }

  static Widget builder(BuildContext context, Widget? child) {
    final theme = Theme.of(context);
    final appTheme = AppThemeExtension.of(context);

    final buttonTextStyle = WidgetStateProperty.all(
      AppThemeExtension.buttonTextStyle(appTheme.buttonVariant, theme),
    );

    final modifiedTheme = theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(titleTextStyle: theme.textTheme.headlineSmall),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: theme.elevatedButtonTheme.style!.copyWith(textStyle: buttonTextStyle),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: theme.outlinedButtonTheme.style!.copyWith(textStyle: buttonTextStyle),
      ),
    );

    return Theme(data: modifiedTheme, child: child!);
  }
}

class AppThemeColorScheme {
  AppThemeColorScheme({
    required this.neutral,
    required this.success,
    required this.warning,
    required this.error,
  });

  final Color neutral;
  final Color success;
  final Color warning;
  final Color error;

  factory AppThemeColorScheme.light() => AppThemeColorScheme(
    neutral: const .fromARGB(255, 92, 184, 227),
    success: const .fromARGB(255, 139, 195, 74),
    warning: const .fromARGB(255, 249, 199, 50),
    error: const .fromARGB(255, 235, 98, 88),
  );

  static AppThemeColorScheme? lerp(AppThemeColorScheme? a, AppThemeColorScheme? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return t < 0.5 ? null : b;
    }
    if (b == null) {
      return t < 0.5 ? a : null;
    }
    return AppThemeColorScheme(
      neutral: .lerp(a.neutral, b.neutral, t)!,
      success: .lerp(a.success, b.success, t)!,
      warning: .lerp(a.warning, b.warning, t)!,
      error: .lerp(a.error, b.error, t)!,
    );
  }
}

enum AppThemeButtonVariant {
  large,
  medium,
  small;

  static AppThemeButtonVariant? lerp(AppThemeButtonVariant? a, AppThemeButtonVariant? b, double t) {
    return t <= 0.5 ? a : b;
  }
}

class AppThemeExtension implements ThemeExtension<AppThemeExtension> {
  AppThemeExtension({
    required this.buttonVariant,
    required this.appBarLeadingPadding,
    required this.colorScheme,
  });

  final AppThemeButtonVariant buttonVariant;
  final EdgeInsets appBarLeadingPadding;
  final AppThemeColorScheme colorScheme;

  static AppThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<AppThemeExtension>()!;
  }

  static Size buttonSize(AppThemeButtonVariant variant) {
    return switch (variant) {
      .large => Size(double.infinity, 48),
      .medium => Size(double.infinity, 44),
      .small => Size(double.infinity, 40),
    };
  }

  static TextStyle buttonTextStyle(AppThemeButtonVariant variant, ThemeData theme) {
    return switch (variant) {
      .large => theme.textTheme.titleMedium!,
      .medium => theme.textTheme.titleMedium!,
      .small => theme.textTheme.titleSmall!,
    };
  }

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    AppThemeButtonVariant? buttonVariant,
    EdgeInsets? appBarLeadingPadding,
    AppThemeColorScheme? colorScheme,
  }) {
    return AppThemeExtension(
      buttonVariant: buttonVariant ?? this.buttonVariant,
      appBarLeadingPadding: appBarLeadingPadding ?? this.appBarLeadingPadding,
      colorScheme: colorScheme ?? this.colorScheme,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(AppThemeExtension? other, double t) {
    return AppThemeExtension(
      buttonVariant: .lerp(buttonVariant, other?.buttonVariant, t) ?? buttonVariant,
      appBarLeadingPadding:
          .lerp(appBarLeadingPadding, other?.appBarLeadingPadding, t) ?? appBarLeadingPadding,
      colorScheme: .lerp(colorScheme, other?.colorScheme, t) ?? colorScheme,
    );
  }

  @override
  Object get type => AppThemeExtension;
}
