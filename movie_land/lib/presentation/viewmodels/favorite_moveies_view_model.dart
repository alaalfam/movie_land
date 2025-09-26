import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:movie_land/data/models/movie_model.dart';
import 'package:movie_land/data/repositories/movie_list_repository.dart';

class FavoriteMoveiesViewModel extends ChangeNotifier {
  final MovieListRepository movieRepository;
  List<MovieModel> favoriteMovies = [];

  bool isLoading = false;

  FavoriteMoveiesViewModel({required this.movieRepository});

  void initialize() {
    // Load favorite movies from local storage or database
    loadFavoriteMovies();
  }

  Future<void> loadFavoriteMovies() async {
    try {
      isLoading = true;
      notifyListeners();
      favoriteMovies = await movieRepository.getFavoriteMovies() ?? [];
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeFromFavorite(MovieModel movie) async {
    try {
      await movieRepository.remove(movie.id);
      favoriteMovies.removeWhere((m) => m.id == movie.id);
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
