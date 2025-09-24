import 'package:movie_land/data/models/movie_model.dart';
import 'package:movie_land/data/services/movie_lists_api.dart';

class MovieListRepository {
  final MovieListsApi _api;

  MovieListRepository(this._api);

  Future<List<MovieModel>> popularMovies(int page) async => _api.popular(page);
}
