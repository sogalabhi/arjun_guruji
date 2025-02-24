part of 'astottara_bloc.dart';

@freezed
class AstottarasState with _$AstottarasState {
  const factory AstottarasState.initial() = Initial;

  const factory AstottarasState.loading() = Loading;

  const factory AstottarasState.astottarasLoaded(List<Astottara> astottaras) =
      AstottarasLoaded;

  const factory AstottarasState.error(String message) = Error;
}
