import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final String readingTheme; // 'light' | 'dark' | 'sepia'
  final double fontSize;     // 16.0 to 32.0
  final String fontStyle;    // 'sans-serif' | 'serif'
  final bool enableNotifications;

  const SettingsEntity({
    required this.readingTheme,
    required this.fontSize,
    required this.fontStyle,
    required this.enableNotifications,
  });

  factory SettingsEntity.initial() {
    return const SettingsEntity(
      readingTheme: 'light',
      fontSize: 20.0,
      fontStyle: 'sans-serif',
      enableNotifications: true,
    );
  }

  SettingsEntity copyWith({
    String? readingTheme,
    double? fontSize,
    String? fontStyle,
    bool? enableNotifications,
  }) {
    return SettingsEntity(
      readingTheme: readingTheme ?? this.readingTheme,
      fontSize: fontSize ?? this.fontSize,
      fontStyle: fontStyle ?? this.fontStyle,
      enableNotifications: enableNotifications ?? this.enableNotifications,
    );
  }

  @override
  List<Object?> get props => [
        readingTheme,
        fontSize,
        fontStyle,
        enableNotifications,
      ];
}
