import 'package:arjun_guruji/features/Admin/domain/entity/event.dart';
import 'package:arjun_guruji/features/Admin/domain/repository/event_repository.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class GetEventsUseCase implements Usecase<List<Event>, NoParams, String> {
  final EventRepository repository;
  GetEventsUseCase(this.repository);

  @override
  Future<Either<String, List<Event>>> call(NoParams params) async {
    try {
      final events = await repository.getAllEvents();
      return Right(events);
    } catch (e) {
      return Left(e.toString());
    }
  }
} 