import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_land/core/utils/error_handler.dart';
import 'package:movie_land/data/models/movie_model.dart';
import 'package:movie_land/data/repositories/movie_list_repository.dart';
import 'package:go_router/go_router.dart';

class DashboardViewModel extends ChangeNotifier {
  final MovieListRepositoryImp movieRepository;
  int pageSize = 20;
  PagingState<int, MovieModel> state = PagingState<int, MovieModel>();
  String searchQuery = '';
  final BuildContext context;

  DashboardViewModel({required this.movieRepository, required this.context});

  void initialize() {}

  Future<void> refreshPage() async {
    state = state.reset();
    notifyListeners();
  }

  Future<void> fetchNextPage() async {
    try {
      if (state.isLoading) return;
      state = state.copyWith(isLoading: true, error: null);
      notifyListeners();

      final newKey = (state.keys?.last ?? 0) + 1;
      List<MovieModel> newItems = [];
      if (searchQuery.isNotEmpty) {
        // Implement search logic here
        newItems = await movieRepository.searchMovies(newKey, searchQuery);
      } else {
        // Fetch popular movies by default
        newItems = await movieRepository.popularMovies(newKey);
      }
      final isLastPage = newItems.isEmpty;

      state = state.copyWith(
        pages: [...?state.pages, newItems],
        keys: [...?state.keys, newKey],
        hasNextPage: !isLastPage,
        isLoading: false,
      );
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleError(e);
      state = state.copyWith(isLoading: false, error: e);
      notifyListeners();
    }
  }

  void addToFavorite(MovieModel movie) {
    // Implement favorite logic here
    movieRepository.saveToFavorite(movie);
  }

  void goToFavoriteMovies() {
    context.push('/favorite_movies');
  }

  void onSearchChanged(String query) {
    searchQuery = query;
    refreshPage();
  }

  @override
  void dispose() {
    // pagingController.dispose();
    super.dispose();
  }
}
