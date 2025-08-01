import 'package:arjun_guruji/features/Admin/domain/repository/event_repository.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class DeleteEventUseCase implements Usecase<void, String, String> {
  final EventRepository repository;
  DeleteEventUseCase(this.repository);

  @override
  Future<Either<String, void>> call(String eventId) async {
    try {
      await repository.deleteEvent(eventId);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
