import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_land/core/utils/movie_land_dimentions.dart';
import 'package:movie_land/data/models/movie_model.dart';
import 'package:movie_land/data/repositories/movie_list_repository.dart';
import 'package:movie_land/data/services/movie_lists_api.dart';
import 'package:movie_land/presentation/viewmodels/dashboard_view_model.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardViewModel>(
      create:
          (_) => DashboardViewModel(
            movieRepository: MovieListRepository(MovieListsApiImpl()),
          )..initialize(),
      child: const _DashboardPage(),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final read = Provider.of<DashboardViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Land')),
      body: Consumer<DashboardViewModel>(
        builder:
            (context, value, child) => PagedListView<int, MovieModel>.separated(
              padding: const EdgeInsets.all(MovieLandDimentions.spaceDefault),
              state: value.state,
              fetchNextPage: value.fetchNextPage,
              separatorBuilder:
                  (context, index) =>
                      SizedBox(height: MovieLandDimentions.spaceDefault),
              builderDelegate: PagedChildBuilderDelegate<MovieModel>(
                itemBuilder:
                    (context, item, index) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://image.tmdb.org/t/p/w220_and_h330_face${item.posterPath}',
                              placeholder:
                                  (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
              ),

              // controller: read.pagingController,
              // builder:
              //     (context, state, fetchNextPage) => Container(
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(8),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.grey.withValues(alpha: 0.5),
              //             spreadRadius: 2,
              //             blurRadius: 5,
              //             offset: const Offset(
              //               0,
              //               3,
              //             ), // changes position of shadow
              //           ),
              //         ],
              //       ),
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         crossAxisAlignment: CrossAxisAlignment.stretch,
              //         children: [
              //           Text(
              //             'Movies',
              //             style: Theme.of(context).textTheme.headlineMedium,
              //           ),
              //         ],
              //       ),
              //     ),
            ),
      ),
    );
  }
}
