import 'package:arjun_guruji/features/Admin/domain/repository/event_repository.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';

class UploadEventImageParams {
  final File image;
  final String eventName;
  UploadEventImageParams(this.image, this.eventName);
}

class UploadEventImageUseCase
    implements Usecase<String, UploadEventImageParams, String> {
  final EventRepository repository;
  UploadEventImageUseCase(this.repository);

  @override
  Future<Either<String, String>> call(UploadEventImageParams params) async {
    try {
      final url = await repository.uploadImageToEventFolder(
          params.image, params.eventName);
      return Right(url);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
