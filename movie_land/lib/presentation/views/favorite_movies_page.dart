import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_land/core/utils/datetime_converter.dart';
import 'package:movie_land/core/utils/movie_land_dimentions.dart';
import 'package:movie_land/data/repositories/movie_list_repository.dart';
import 'package:movie_land/data/services/movie_lists_api.dart';
import 'package:movie_land/presentation/viewmodels/favorite_moveies_view_model.dart';
import 'package:provider/provider.dart';

class FavoriteMoviesPage extends StatelessWidget {
  const FavoriteMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => FavoriteMoveiesViewModel(
            movieRepository: MovieListRepositoryImp(api: MovieListsApiImpl()),
          )..initialize(),
      child: _FavoriteMoviesPage(),
    );
  }
}

class _FavoriteMoviesPage extends StatelessWidget {
  const _FavoriteMoviesPage();

  @override
  Widget build(BuildContext context) {
    final read = Provider.of<FavoriteMoveiesViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Movies')),
      body: Consumer<FavoriteMoveiesViewModel>(
        builder:
            (context, value, child) =>
                (value.isLoading)
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                      padding: const EdgeInsets.all(
                        MovieLandDimentions.paddingDefault,
                      ),
                      itemBuilder:
                          (context, index) => Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                MovieLandDimentions.borderRadiusMedium,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                    0,
                                    3,
                                  ), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                          MovieLandDimentions
                                              .borderRadiusMedium,
                                        ),
                                        bottomLeft: Radius.circular(
                                          MovieLandDimentions
                                              .borderRadiusMedium,
                                        ),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://image.tmdb.org/t/p/w220_and_h330_face${value.favoriteMovies[index].posterPath}',
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MovieLandDimentions.spaceDefault,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical:
                                              MovieLandDimentions
                                                  .paddingDefault,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                value
                                                    .favoriteMovies[index]
                                                    .title,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  MovieLandDimentions
                                                      .spaceDefault,
                                            ),
                                            Text(
                                              DatetimeConverter()
                                                  .convertToHumanReadable(
                                                    value
                                                        .favoriteMovies[index]
                                                        .releaseDate,
                                                  ),
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: IconButton(
                                    onPressed:
                                        () => read.removeFromFavorite(
                                          value.favoriteMovies[index],
                                        ),
                                    icon: Icon(Icons.delete),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      separatorBuilder:
                          (context, index) =>
                              SizedBox(height: MovieLandDimentions.spaceLarge),
                      itemCount: value.favoriteMovies.length,
                    ),
      ),
    );
  }
}
