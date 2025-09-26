import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_land/core/utils/datetime_converter.dart';
import 'package:movie_land/data/repositories/movie_list_repository.dart';
import 'package:movie_land/data/services/movie_lists_api.dart';
import 'package:movie_land/presentation/viewmodels/movie_detail_view_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatelessWidget {
  final String id;
  const MovieDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => MovieDetailViewModel(
            movieId: id,
            movieListRepository: MovieListRepositoryImp(
              api: MovieListsApiImpl(),
            ),
          )..initialize(),
      child: _MovieDetailPage(),
    );
  }
}

class _MovieDetailPage extends StatelessWidget {
  const _MovieDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final read = Provider.of<MovieDetailViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),
      body: Consumer<MovieDetailViewModel>(
        builder:
            (context, value, child) =>
                (value.isLoading)
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                      children: [
                        SizedBox(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: 0.3,
                                child: Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        'https://image.tmdb.org/t/p/w500${value.movieDetail?.backdropPath}',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      value.movieDetail?.title ?? '',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          DatetimeConverter()
                                              .convertToReadableDate(
                                                value
                                                        .movieDetail
                                                        ?.releaseDate ??
                                                    '',
                                              ),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            value.movieDetail?.genres
                                                    .map((e) => e.name)
                                                    .join(', ') ??
                                                '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w200${value.movieDetail?.posterPath}',
                                placeholder:
                                    (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                width: 100,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 16),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: CircularPercentIndicator(
                                    radius: 22,
                                    lineWidth: 3,
                                    percent:
                                        (value.movieDetail?.voteAverage ?? 0) /
                                        10,
                                    center: Text(
                                      '${((value.movieDetail?.voteAverage ?? 0) * 10).toStringAsFixed(0)}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    progressColor:
                                        (value.movieDetail?.voteAverage ?? 0) >=
                                                7
                                            ? Colors.green
                                            : (value.movieDetail?.voteAverage ??
                                                    0) >=
                                                4
                                            ? Colors.orange
                                            : Colors.red,
                                    backgroundColor: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Text('User score'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16),
                              Text(
                                'Overview',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(value.movieDetail?.overview ?? ''),
                            ],
                          ),
                        ),
                      ],
                    ),
      ),
    );
  }
}
