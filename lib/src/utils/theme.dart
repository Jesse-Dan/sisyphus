import 'package:color_system/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StateNotifierProvider to manage the theme state.
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

/// A StateNotifier class to manage and toggle between light and dark themes.
class ThemeNotifier extends StateNotifier<ThemeMode> {
  /// Initializes the ThemeNotifier with the system theme.
  ThemeNotifier() : super(ThemeMode.system);

  /// Toggles the current theme between light and dark.
  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  /// Returns the current theme mode.
  ThemeMode getTheme() => state;
}

/// Getter for the light theme data.
ThemeData get lightTheme => _lightTheme;

/// Defines the light theme settings.
final ThemeData _lightTheme = ThemeData.light().copyWith(

      popupMenuTheme: PopupMenuThemeData(color: HexColor('#FFFFFF'),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(
      color: HexColor('#CFD9E4')
    )),),

    primaryColor: HexColor('#262932'),

    // Applies the 'Satoshi' font family to the light theme text.
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Satoshi'),
    // Sets the background color for the scaffold.
    scaffoldBackgroundColor: HexColor('#F8F8F9'),
    // Customizes the AppBar theme.
    appBarTheme: AppBarTheme(
      backgroundColor: HexColor('#FFFFFF'),
    ),
    // Customizes the TabBar theme.
    tabBarTheme: TabBarTheme(
      // Removes the divider height between tabs.
      dividerHeight: 0,
      // Sets the color of unselected labels.
      unselectedLabelColor: HexColor('#737A91'),
      // Defines the indicator decoration for selected tabs.
      indicator: BoxDecoration(
        color: HexColor('#FFFFFF'),
        borderRadius: BorderRadius.circular(8),
      ),
      // Sets the size of the indicator to the size of the tab.
      indicatorSize: TabBarIndicatorSize.tab,
      // Customizes the label style for selected tabs.
      labelStyle: ThemeData.dark()
          .textTheme
          .labelMedium
          ?.copyWith(fontFamily: 'Satoshi', color: Colors.black, fontSize: 14),
      // Customizes the label style for unselected tabs.
      unselectedLabelStyle: ThemeData.dark().textTheme.labelMedium?.copyWith(
            color: HexColor('#737A91'),
          ),
    ),
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: HexColor('#FFFFFF')));

/// Getter for the dark theme data.
ThemeData get darkTheme => _darkTheme;

/// Defines the dark theme settings.
final ThemeData _darkTheme = ThemeData.dark().copyWith(
    popupMenuTheme: PopupMenuThemeData(color: HexColor('#1C2127'),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(
      color: HexColor('#373B3F')
    ))),
    primaryColor: HexColor('#262932'),
    // Applies the 'Satoshi' font family to the dark theme text.
    textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Satoshi'),
    // Sets the background color for the scaffold.
    scaffoldBackgroundColor: HexColor('#1C2127'),
    // Customizes the AppBar theme.
    appBarTheme: AppBarTheme(
      backgroundColor: HexColor('#17181B'),
    ),
    // Customizes the TabBar theme.
    tabBarTheme: TabBarTheme(
      // Removes the divider height between tabs.
      dividerHeight: 0,
      // Sets the color of unselected labels.
      unselectedLabelColor: HexColor('#737A91'),
      // Defines the indicator decoration for selected tabs.
      indicator: BoxDecoration(
        color: HexColor('#1C2127'),
        borderRadius: BorderRadius.circular(8),
      ),
      // Sets the size of the indicator to the size of the tab.
      indicatorSize: TabBarIndicatorSize.tab,
      // Customizes the label style for selected tabs.
      labelStyle: ThemeData.dark().textTheme.labelMedium?.copyWith(
          fontFamily: 'Satoshi', color: HexColor('#FFFFFF'), fontSize: 14),
      // Customizes the label style for unselected tabs.
      unselectedLabelStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: HexColor('#1C2127'),
    ));

Color themeColor(BuildContext context,
    {required Color lightColor, required Color darkColor}) {
  final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  return isDarkTheme ? darkColor : lightColor;
}
