import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/presentation/cubit/movie/movie_now_playing_cubit.dart';

import '../../../dummy_data/movie/dummy_objects_movie.dart';
import 'movie_now_playing_cubit_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MovieNowPlayingCubit cubit;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    cubit = MovieNowPlayingCubit(
      getNowPlayingMovies: mockGetNowPlayingMovies,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group(
    'Movie Now Playing',
    () {
      blocTest<MovieNowPlayingCubit, MovieNowPlayingState>(
        'should emitsInOrder [Loading, Loaded] when success',
        build: () {
          when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Right(testMovieList));
          return cubit;
        },
        act: (bloc) => bloc.get(),
        expect: () => [
          const MovieNowPlayingLoadingState(),
          MovieNowPlayingLoadedState(items: testMovieList),
        ],
      );

      blocTest<MovieNowPlayingCubit, MovieNowPlayingState>(
        'should emitsInOrder [Loading, Error] when unsuccess',
        build: () {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((_) async => const Left(ServerFailure('error')));
          return cubit;
        },
        act: (bloc) => bloc.get(),
        expect: () => [
          const MovieNowPlayingLoadingState(),
          const MovieNowPlayingErrorState('error'),
        ],
      );
    },
  );
}
