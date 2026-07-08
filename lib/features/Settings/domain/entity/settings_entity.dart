import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final String readingTheme;
  final double fontSize;
  final String fontStyle;
  final bool enableNotifications;
  final String panchangCity;

  const SettingsEntity({
    required this.readingTheme,
    required this.fontSize,
    required this.fontStyle,
    required this.enableNotifications,
    required this.panchangCity,
  });

  factory SettingsEntity.initial() {
    return const SettingsEntity(
      readingTheme: 'light',
      fontSize: 20.0,
      fontStyle: 'sans-serif',
      enableNotifications: true,
      panchangCity: 'Mysore',
    );
  }

  SettingsEntity copyWith({
    String? readingTheme,
    double? fontSize,
    String? fontStyle,
    bool? enableNotifications,
    String? panchangCity,
  }) {
    return SettingsEntity(
      readingTheme: readingTheme ?? this.readingTheme,
      fontSize: fontSize ?? this.fontSize,
      fontStyle: fontStyle ?? this.fontStyle,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      panchangCity: panchangCity ?? this.panchangCity,
    );
  }

  @override
  List<Object?> get props => [
        readingTheme,
        fontSize,
        fontStyle,
        enableNotifications,
        panchangCity,
      ];
}

