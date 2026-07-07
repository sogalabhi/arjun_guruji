import 'package:hive_flutter/hive_flutter.dart';
import '../model/settings_model.dart';

abstract class SettingsLocalDataSource {
  SettingsModel getSettings();
  Future<void> saveSettings(SettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final Box settingsBox;

  SettingsLocalDataSourceImpl(this.settingsBox);

  @override
  SettingsModel getSettings() {
    final readingTheme = settingsBox.get('readingTheme', defaultValue: 'light') as String;
    final fontSize = settingsBox.get('fontSize', defaultValue: 20.0) as double;
    final fontStyle = settingsBox.get('fontStyle', defaultValue: 'sans-serif') as String;
    final enableNotifications = settingsBox.get('enableNotifications', defaultValue: true) as bool;
    
    return SettingsModel(
      readingTheme: readingTheme,
      fontSize: fontSize,
      fontStyle: fontStyle,
      enableNotifications: enableNotifications,
    );
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    await settingsBox.put('readingTheme', settings.readingTheme);
    await settingsBox.put('fontSize', settings.fontSize);
    await settingsBox.put('fontStyle', settings.fontStyle);
    await settingsBox.put('enableNotifications', settings.enableNotifications);
  }
}
