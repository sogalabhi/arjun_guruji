import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateTheme extends SettingsEvent {
  final String theme;
  const UpdateTheme(this.theme);

  @override
  List<Object> get props => [theme];
}

class UpdateFontSize extends SettingsEvent {
  final double fontSize;
  const UpdateFontSize(this.fontSize);

  @override
  List<Object> get props => [fontSize];
}

class UpdateFontStyle extends SettingsEvent {
  final String fontStyle;
  const UpdateFontStyle(this.fontStyle);

  @override
  List<Object> get props => [fontStyle];
}

class ToggleNotifications extends SettingsEvent {
  final bool enable;
  const ToggleNotifications(this.enable);

  @override
  List<Object> get props => [enable];
}

class UpdatePanchangCity extends SettingsEvent {
  final String city;
  const UpdatePanchangCity(this.city);

  @override
  List<Object> get props => [city];
}

class ResetSettings extends SettingsEvent {}

