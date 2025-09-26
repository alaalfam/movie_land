import 'package:hive/hive.dart';
import 'package:movie_land/data/models/movie_model.dart';
import 'package:movie_land/data/services/movie_lists_api.dart';

abstract class MovieListRepository {
  Future<List<MovieModel>> popularMovies(int page);
  Future<List<MovieModel>> searchMovies(int page, String query);
  Future<void> saveToFavorite(MovieModel movie);
  Future<List<MovieModel>?> getFavoriteMovies();
  Future<void> remove(int movieId);
}

class MovieListRepositoryImp implements MovieListRepository {
  final MovieListsApi api;
  Box<MovieModel>? favoriteMoviesBox;

  MovieListRepositoryImp({required this.api});

  Future<void> _openBoxIfNeeded() async {
    if (!Hive.isBoxOpen('favoriteMoviesBox')) {
      favoriteMoviesBox = await Hive.openBox<MovieModel>('favoriteMoviesBox');
    } else {
      favoriteMoviesBox ??= Hive.box<MovieModel>('favoriteMoviesBox');
    }
  }

  @override
  Future<List<MovieModel>> popularMovies(int page) async => api.popular(page);

  @override
  Future<List<MovieModel>> searchMovies(int page, String query) async =>
      api.searchMovie(page, query);

  @override
  Future<void> saveToFavorite(MovieModel movie) async {
    await _openBoxIfNeeded();
    await favoriteMoviesBox?.put(movie.id, movie);
  }

  @override
  Future<List<MovieModel>?> getFavoriteMovies() async {
    await _openBoxIfNeeded();
    return favoriteMoviesBox?.values.toList();
  }

  Future<void> remove(int movieId) async {
    await _openBoxIfNeeded();
    await favoriteMoviesBox?.delete(movieId);
  }
}
