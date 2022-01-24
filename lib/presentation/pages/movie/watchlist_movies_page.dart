import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/cubit/movie/movie_watchlist_cubit.dart';
import 'package:ditonton/presentation/widgets/card/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const routeName = '/watchlist-movie';

  const WatchlistMoviesPage({Key? key}) : super(key: key);

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MovieWatchlistCubit>().get());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<MovieWatchlistCubit>().getWatchlistMovies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieWatchlistCubit, MovieWatchlistState>(
          builder: (context, state) {
            if (state is MovieWatchlistLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieWatchlistLoadedState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.items[index];
                  return MovieCard(movie: movie);
                },
                itemCount: state.items.length,
              );
            } else if (state is MovieWatchlistErrorState) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
