import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/Astottaras/data/model/astottara_model.dart';
import 'package:arjun_guruji/features/Astottaras/domain/entity/astottara.dart';
import 'package:arjun_guruji/features/Astottaras/domain/usecases/FetchAstottarasUseCase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'astottara_events.dart';
part 'astottara_states.dart';
part 'astottara_bloc.freezed.dart';

class AstottarasBloc extends Bloc<AstottarasEvent, AstottarasState> {
  final FetchAstottarasUseCase fetchAstottarasUseCase;
  final Box<AstottaraModel> astottarasBox;
  final Connectivity connectivity;

  AstottarasBloc({
    required this.fetchAstottarasUseCase,
    required this.astottarasBox,
    required this.connectivity,
  }) : super(const AstottarasState.initial()) {
    on<FetchAllAstottaras>(_onFetchAstottaras);
  }

  Future<void> _onFetchAstottaras(FetchAllAstottaras event, Emitter<AstottarasState> emit) async {
    emit(const AstottarasState.loading());

    try {
      final ConnectivityResult connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        try {
          // No internet - Fetch from local Hive database
          final List<AstottaraModel> localAstottaras = astottarasBox.values.toList();
          final List<Astottara> astottaras = localAstottaras.map((astottaraModel) => AstottaraModel.toEntity(astottaraModel)).toList();
          
          emit(AstottarasState.astottarasLoaded(astottaras));
        } catch (e) {
          emit(AstottarasState.error("Failed to load astottaras from local database: $e"));
        }
        return;
      }

      // Internet is available - Fetch from Firestore
      final Either<String, List<Astottara>> result = await fetchAstottarasUseCase.call(NoParams());

      await result.fold(
        (failure) async => emit(AstottarasState.error(failure)), // Handle failure properly
        (astottaras) async {
          final List<AstottaraModel> astottaraModels = astottaras.map((astottara) => AstottaraModel.fromEntity(astottara)).toList();

          // Store astottaras in Hive (await to ensure completion)
          await astottarasBox.clear();
          await astottarasBox.addAll(astottaraModels);

          if (!emit.isDone) {
            emit(AstottarasState.astottarasLoaded(astottaras));
          }
        },
      );
    } catch (e) {
      print("Error in _onFetchAstottaras: $e"); // Print unexpected errors for debugging
    }
  }
}
