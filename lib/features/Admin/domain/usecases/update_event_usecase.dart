import 'package:arjun_guruji/features/Admin/domain/entity/event.dart';
import 'package:arjun_guruji/features/Admin/domain/repository/event_repository.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';

class UpdateEventParams {
  final Event event;
  final File? image;
  UpdateEventParams(this.event, {this.image});
}

class UpdateEventUseCase implements Usecase<void, UpdateEventParams, String> {
  final EventRepository repository;
  UpdateEventUseCase(this.repository);

  @override
  Future<Either<String, void>> call(UpdateEventParams params) async {
    try {
      await repository.updateEvent(params.event, image: params.image);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
