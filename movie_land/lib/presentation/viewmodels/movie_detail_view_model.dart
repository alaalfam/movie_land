import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:movie_land/data/models/movie_detail_model.dart';
import 'package:movie_land/data/repositories/movie_list_repository.dart';

class MovieDetailViewModel extends ChangeNotifier {
  final String movieId;
  MovieDetailModel? movieDetail;
  bool isLoading = true;
  final MovieListRepository movieListRepository;

  MovieDetailViewModel({
    required this.movieId,
    required this.movieListRepository,
  });

  void initialize() {
    // Fetch movie details using movieId
    log('Fetching details for movie ID: $movieId');
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    // Implement fetching movie details logic here
    try {
      isLoading = true;
      notifyListeners();
      movieDetail = await movieListRepository.getMovieDetail(movieId);
    } catch (e) {
      log('Error fetching movie details: $e');
      // Handle error appropriately
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
