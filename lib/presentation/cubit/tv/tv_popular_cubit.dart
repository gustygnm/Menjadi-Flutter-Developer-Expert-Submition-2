import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_popular_state.dart';

class TVPopularCubit extends Cubit<TVPopularState> {
  TVPopularCubit({
    required this.getPopularTV,
  }) : super(const TVPopularInitialState());

  final GetPopularTV getPopularTV;
  Future<void> get() async {
    emit(const TVPopularLoadingState());

    final result = await getPopularTV.execute();

    result.fold(
      (failure) => emit(TVPopularErrorState(failure.message)),
      (values) => emit(TVPopularLoadedState(items: values)),
    );
  }
}
