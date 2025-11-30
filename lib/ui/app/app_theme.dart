import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    const white = Colors.white;
    const black = Colors.black;

    final buttonMinSize = AppThemeExtension.buttonSize(.regular);

    return ThemeData(
      extensions: [AppThemeExtension(appBarLeadingPadding: EdgeInsets.only(left: 8))],
      colorSchemeSeed: white,
      scaffoldBackgroundColor: white,
      appBarTheme: AppBarTheme(
        backgroundColor: white,
        elevation: 0,
        leadingWidth: 64,
        titleSpacing: 8,
        centerTitle: false,
        actionsPadding: EdgeInsets.only(right: 8),
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

    final buttonTextStyle = WidgetStateProperty.all(theme.textTheme.titleMedium!);

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

enum AppThemeButtonVariant { regular, compact }

class AppThemeExtension implements ThemeExtension<AppThemeExtension> {
  AppThemeExtension({required this.appBarLeadingPadding});

  final EdgeInsets appBarLeadingPadding;

  static AppThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<AppThemeExtension>()!;
  }

  static Size buttonSize(AppThemeButtonVariant variant) {
    return switch (variant) {
      .regular => Size(double.infinity, 48),
      .compact => Size(double.infinity, 44),
    };
  }

  @override
  ThemeExtension<AppThemeExtension> copyWith({EdgeInsets? appBarLeadingPadding}) {
    return AppThemeExtension(
      appBarLeadingPadding: appBarLeadingPadding ?? this.appBarLeadingPadding,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(AppThemeExtension? other, double t) {
    return AppThemeExtension(
      appBarLeadingPadding:
          .lerp(appBarLeadingPadding, other?.appBarLeadingPadding, t) ?? appBarLeadingPadding,
    );
  }

  @override
  Object get type => AppThemeExtension;
}
