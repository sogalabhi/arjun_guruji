import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entity/settings_entity.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/save_settings_usecase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final SaveSettingsUseCase saveSettingsUseCase;

  SettingsBloc({
    required this.getSettingsUseCase,
    required this.saveSettingsUseCase,
  }) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateTheme>(_onUpdateTheme);
    on<UpdateFontSize>(_onUpdateFontSize);
    on<UpdateFontStyle>(_onUpdateFontStyle);
    on<ToggleNotifications>(_onToggleNotifications);
    on<UpdatePanchangCity>(_onUpdatePanchangCity);
    on<ResetSettings>(_onResetSettings);
  }

  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading(state.settings));
    final result = await getSettingsUseCase(NoParams());
    
    result.fold(
      (failure) => emit(SettingsError(state.settings, failure)),
      (settings) {
        emit(SettingsLoaded(settings));
        _handleFCMSubscription(settings.enableNotifications);
      },
    );
  }

  Future<void> _onUpdateTheme(UpdateTheme event, Emitter<SettingsState> emit) async {
    final updatedSettings = state.settings.copyWith(readingTheme: event.theme);
    await _updateAndSave(updatedSettings, emit);
  }

  Future<void> _onUpdateFontSize(UpdateFontSize event, Emitter<SettingsState> emit) async {
    final updatedSettings = state.settings.copyWith(fontSize: event.fontSize);
    await _updateAndSave(updatedSettings, emit);
  }

  Future<void> _onUpdateFontStyle(UpdateFontStyle event, Emitter<SettingsState> emit) async {
    final updatedSettings = state.settings.copyWith(fontStyle: event.fontStyle);
    await _updateAndSave(updatedSettings, emit);
  }

  Future<void> _onToggleNotifications(ToggleNotifications event, Emitter<SettingsState> emit) async {
    final updatedSettings = state.settings.copyWith(enableNotifications: event.enable);
    await _updateAndSave(updatedSettings, emit);
    _handleFCMSubscription(event.enable);
  }

  Future<void> _onUpdatePanchangCity(UpdatePanchangCity event, Emitter<SettingsState> emit) async {
    final updatedSettings = state.settings.copyWith(panchangCity: event.city);
    await _updateAndSave(updatedSettings, emit);
  }

  Future<void> _onResetSettings(ResetSettings event, Emitter<SettingsState> emit) async {
    final updatedSettings = SettingsEntity.initial();
    await _updateAndSave(updatedSettings, emit);
    _handleFCMSubscription(updatedSettings.enableNotifications);
  }

  Future<void> _updateAndSave(SettingsEntity newSettings, Emitter<SettingsState> emit) async {
    // Optimistic update
    emit(SettingsLoaded(newSettings));
    
    final result = await saveSettingsUseCase(newSettings);
    result.fold(
      (failure) => emit(SettingsError(state.settings, failure)), // If it failed, it stays at previous state? Wait. The state now has newSettings.
      (_) => null,
    );
  }

  void _handleFCMSubscription(bool enable) {
    try {
      if (enable) {
        FirebaseMessaging.instance.subscribeToTopic('all');
      } else {
        FirebaseMessaging.instance.unsubscribeFromTopic('all');
      }
    } catch (e) {
      print('Failed to update FCM subscription: $e');
    }
  }
}
