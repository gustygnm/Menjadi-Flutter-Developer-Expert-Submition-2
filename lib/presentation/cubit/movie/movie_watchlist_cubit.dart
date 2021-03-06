import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_watchlist_state.dart';

class MovieWatchlistCubit extends Cubit<MovieWatchlistState> {
  MovieWatchlistCubit({
    required this.getWatchlistMovies,
  }) : super(const MovieWatchlistInitialState());

  final GetWatchlistMovies getWatchlistMovies;

  Future<void> get() async {
    emit(const MovieWatchlistLoadingState());
    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) => emit(MovieWatchlistErrorState(failure.message)),
      (values) => emit(MovieWatchlistLoadedState(items: values)),
    );
  }
}
