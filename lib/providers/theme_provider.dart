import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/app_constants.dart';

class ThemeProvider extends ChangeNotifier {
  final _storage = GetStorage();
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;

  void init() {
    _isDarkMode = _storage.read('isDarkMode') ?? false;
    _notificationsEnabled = _storage.read('notificationsEnabled') ?? true;
    notifyListeners();
  }

  void toggleTheme(bool value) {
    _isDarkMode = value;
    _storage.write('isDarkMode', value);
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    _storage.write('notificationsEnabled', value);
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.light,
        surface: AppConstants.backgroundLight,
      ),
      scaffoldBackgroundColor: AppConstants.backgroundLight,
      useMaterial3: true,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppConstants.slate800),
        bodyMedium: TextStyle(color: AppConstants.slate800),
        titleLarge: TextStyle(color: AppConstants.slate900),
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.dark,
        surface: AppConstants.darkModeSurface,
      ),
      scaffoldBackgroundColor: AppConstants.darkModeBackground,
      useMaterial3: true,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppConstants.darkModeTextPrimary),
        bodyMedium: TextStyle(color: AppConstants.darkModeTextSecondary),
        titleLarge: TextStyle(color: AppConstants.darkModeTextPrimary),
      ),
      iconTheme: const IconThemeData(color: AppConstants.darkModeTextPrimary),
      listTileTheme: const ListTileThemeData(
        iconColor: AppConstants.darkModeTextSecondary,
        textColor: AppConstants.darkModeTextPrimary,
      ),
    );
  }
}
