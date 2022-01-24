import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ditonton/presentation/cubit/movie/movie_popular_cubit.dart';

import '../../../dummy_data/movie/dummy_objects_movie.dart';
import 'movie_popular_cubit_test.mocks.dart';

@GenerateMocks([
  GetPopularMovies,
])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late MoviePopularCubit cubit;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    cubit = MoviePopularCubit(getPopularMovies: mockGetPopularMovies);
  });

  tearDown(() async {
    await cubit.close();
  });

  group(
    'Movie Popular',
    () {
      blocTest<MoviePopularCubit, MoviePopularState>(
        'Should emitsInOrder [Loading, Loaded] when success',
        build: () {
          when(mockGetPopularMovies.execute()).thenAnswer((_) async => Right(testMovieList));
          return cubit;
        },
        act: (bloc) => bloc.get(),
        expect: () => [
          const MoviePopularLoadingState(),
          MoviePopularLoadedState(items: testMovieList),
        ],
      );

      blocTest<MoviePopularCubit, MoviePopularState>(
        'Should emitsInOrder [Loading, Loaded] when unsuccess',
        build: () {
          when(mockGetPopularMovies.execute())
              .thenAnswer((_) async =>const  Left(ServerFailure('error')));
          return cubit;
        },
        act: (bloc) => bloc.get(),
        expect: () => [
          const MoviePopularLoadingState(),
          const MoviePopularErrorState('error'),
        ],
      );
    },
  );
}
