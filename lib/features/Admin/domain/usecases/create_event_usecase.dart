import 'package:arjun_guruji/features/Admin/domain/entity/event.dart';
import 'package:arjun_guruji/features/Admin/domain/repository/event_repository.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'dart:io';
import 'package:dartz/dartz.dart';

class CreateEventParams {
  final Event event;
  final File? image;
  CreateEventParams(this.event, {this.image});
}

class CreateEventUseCase implements Usecase<Event, CreateEventParams, String> {
  final EventRepository repository;
  CreateEventUseCase(this.repository);

  @override
  Future<Either<String, Event>> call(CreateEventParams params) async {
    try {
      final event = await repository.createEvent(params.event, image: params.image);
      return Right(event);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
