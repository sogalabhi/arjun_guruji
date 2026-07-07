import 'package:equatable/equatable.dart';
import '../../domain/entity/settings_entity.dart';

abstract class SettingsState extends Equatable {
  final SettingsEntity settings;
  const SettingsState(this.settings);

  @override
  List<Object> get props => [settings];
}

class SettingsInitial extends SettingsState {
  SettingsInitial() : super(SettingsEntity.initial());
}

class SettingsLoading extends SettingsState {
  const SettingsLoading(super.settings);
}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded(super.settings);
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(super.settings, this.message);

  @override
  List<Object> get props => [settings, message];
}
