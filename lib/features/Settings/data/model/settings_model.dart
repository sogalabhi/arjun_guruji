import '../../domain/entity/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    required super.readingTheme,
    required super.fontSize,
    required super.fontStyle,
    required super.enableNotifications,
  });

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      readingTheme: entity.readingTheme,
      fontSize: entity.fontSize,
      fontStyle: entity.fontStyle,
      enableNotifications: entity.enableNotifications,
    );
  }
}
