import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/presentation/cubit/movie/movie_recommendations_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetMovieRecommendations,
])
void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MovieRecommendationsCubit cubit;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    cubit = MovieRecommendationsCubit(
      getMovieRecommendations: mockGetMovieRecommendations,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  const tId = 1;
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];
  group(
    'Movie Recommendations',
    () {
      blocTest<MovieRecommendationsCubit, MovieRecommendationsState>(
        'Should emitsInOrder [Loading, Loaded] when success',
        build: () {
          when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Right(tMovies));
          return cubit;
        },
        act: (bloc) => bloc.get(tId),
        expect: () => [
          const MovieRecommendationsLoadingState(),
          MovieRecommendationsLoadedState(items: tMovies),
        ],
      );

      blocTest<MovieRecommendationsCubit, MovieRecommendationsState>(
        'Should emitsInOrder [Loading, Error] when unsuccess',
        build: () {
          when(mockGetMovieRecommendations.execute(tId))
              .thenAnswer((_) async =>const  Left(ServerFailure('error')));
          return cubit;
        },
        act: (bloc) => bloc.get(tId),
        expect: () => [
          const MovieRecommendationsLoadingState(),
          const MovieRecommendationsErrorState('error'),
        ],
      );
    },
  );
}
