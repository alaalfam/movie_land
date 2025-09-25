import 'package:movie_land/core/core_api.dart';
import 'package:movie_land/data/models/movie_model.dart';

abstract class MovieListsApi {
  final coreApi = CoreApi();

  final String nowPlayingEndpoint = '3/movie/now_playing';
  final String popularEndpoint = '3/movie/popular';
  final String topRateEndpoint = '3/movie/top_rate';
  final String upcomingEndpoint = '3/movie/upcoming';
  final String searchEndpoint = '3/search/movie';

  Future<List<MovieModel>> nowPlaying(int page);
  Future<List<MovieModel>> popular(int page);
  Future<List<MovieModel>> topRate(int page);
  Future<List<MovieModel>> upComming(int page);
  Future<List<MovieModel>> searchMovie(int page, String query);
}

class MovieListsApiImpl extends MovieListsApi {
  @override
  Future<List<MovieModel>> nowPlaying(int page) async {
    try {
      final response = await coreApi.get(endpoint: nowPlayingEndpoint, queryParameters: {'page': page.toString()});
      return (response['results'] as List)
          .map((json) => MovieModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
// https://image.tmdb.org/t/p/w220_and_h330_face/sUsVimPdA1l162FvdBIlmKBlWHx.jpg
  @override
  Future<List<MovieModel>> popular(int page) async {
    try {
      final response = await coreApi.get(endpoint: popularEndpoint, queryParameters: {'page': page.toString()});
      return (response['results'] as List)
          .map((json) => MovieModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MovieModel>> topRate(int page) async {
    final response = await coreApi.get(endpoint: topRateEndpoint);
    return (response['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<MovieModel>> upComming(int page) async {
    final response = await coreApi.get(endpoint: upcomingEndpoint);
    return (response['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }
  
  @override
  Future<List<MovieModel>> searchMovie(int page, String query) async {
    try {
      final response = await coreApi.get(
        endpoint: searchEndpoint,
        queryParameters: {
          'page': page.toString(),
          'query': query,
        },
      );
      return response['results'] != null
          ? (response['results'] as List)
              .map((json) => MovieModel.fromJson(json))
              .toList()
          : [];
    } catch (e) {
      rethrow;
    }
  }
}
