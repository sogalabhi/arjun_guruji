import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/Astottaras/domain/entity/astottara.dart';
import 'package:arjun_guruji/features/Astottaras/domain/usecases/fetch_astottaras_usecase.dart';
import 'package:arjun_guruji/features/Astottaras/domain/usecases/get_cached_astottaras_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'astottara_events.dart';
part 'astottara_states.dart';
part 'astottara_bloc.freezed.dart';

class AstottarasBloc extends Bloc<AstottarasEvent, AstottarasState> {
  final FetchAstottarasUseCase fetchAstottarasUseCase;
  final GetCachedAstottarasUseCase getCachedAstottarasUseCase;
  final Connectivity connectivity;

  AstottarasBloc({
    required this.fetchAstottarasUseCase,
    required this.getCachedAstottarasUseCase,
    required this.connectivity,
  }) : super(const AstottarasState.initial()) {
    on<FetchAllAstottaras>(_onFetchAstottaras);
  }

  Future<void> _onFetchAstottaras(
      FetchAllAstottaras event, Emitter<AstottarasState> emit) async {
    List<Astottara> cachedAstottaras = [];
    try {
      cachedAstottaras = getCachedAstottarasUseCase();

      if (cachedAstottaras.isNotEmpty) {
        emit(AstottarasState.astottarasLoaded(cachedAstottaras));
      } else {
        emit(const AstottarasState.loading());
      }
    } catch (e) {
      emit(const AstottarasState.loading());
    }

    try {
      final Either<String, List<Astottara>> result =
          await fetchAstottarasUseCase.call(NoParams());

      await result.fold(
        (failure) async {
          if (cachedAstottaras.isEmpty) {
            emit(AstottarasState.error(failure));
          }
        },
        (freshAstottaras) async {
          bool hasChanged = false;
          if (freshAstottaras.length != cachedAstottaras.length) {
            hasChanged = true;
          } else {
            for (int i = 0; i < freshAstottaras.length; i++) {
              final remote = freshAstottaras[i];
              final local = cachedAstottaras[i];
              if (remote.title != local.title ||
                  remote.imageUrl != local.imageUrl ||
                  remote.content != local.content ||
                  remote.lastUpdated != local.lastUpdated) {
                hasChanged = true;
                break;
              }
            }
          }

          if (hasChanged && !emit.isDone) {
            emit(AstottarasState.astottarasLoaded(freshAstottaras));
          }
        },
      );
    } catch (e) {
      if (cachedAstottaras.isEmpty) {
        emit(AstottarasState.error("Failed to load astottaras: $e"));
      }
    }
  }
}
