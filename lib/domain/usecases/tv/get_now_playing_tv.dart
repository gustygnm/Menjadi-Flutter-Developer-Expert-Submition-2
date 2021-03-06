import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/repositories/tv/tv_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetNowPlayingTV {
  final TVRepository repository;

  GetNowPlayingTV(this.repository);

  Future<Either<Failure, List<TV>>> execute() {
    return repository.getNowPlayingTV();
  }
}
