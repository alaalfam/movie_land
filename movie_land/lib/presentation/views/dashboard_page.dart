import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_land/core/utils/datetime_converter.dart';
import 'package:movie_land/core/utils/movie_land_dimentions.dart';
import 'package:movie_land/data/models/movie_model.dart';
import 'package:movie_land/data/repositories/movie_list_repository.dart';
import 'package:movie_land/data/services/movie_lists_api.dart';
import 'package:movie_land/presentation/viewmodels/dashboard_view_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(MovieLandDimentions.spaceDefault),
            child: Consumer<DashboardViewModel>(
              builder:
                  (context, viewModel, child) => TextField(
                    decoration: InputDecoration(
                      hintText: 'Search movies...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    onChanged: read.onSearchChanged,
                  ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => read.refreshPage(),
              child: Consumer<DashboardViewModel>(
                builder:
                    (context, value, child) => PagedGridView<int, MovieModel>(
                      padding: const EdgeInsets.all(
                        MovieLandDimentions.spaceDefault,
                      ),
                      state: value.state,
                      fetchNextPage: value.fetchNextPage,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: MovieLandDimentions.spaceDefault,
                            crossAxisSpacing: MovieLandDimentions.spaceDefault,
                            childAspectRatio: 0.45,
                          ),
                      // separatorBuilder:
                      //     (context, index) =>
                      //         SizedBox(height: MovieLandDimentions.spaceDefault),
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
                                  AspectRatio(
                                    aspectRatio: 2 / 3,
                                    child: Stack(
                                      clipBehavior: Clip.none,
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
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: -25,
                                          left: 10,
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                              child: CircularPercentIndicator(
                                                radius: 22,
                                                lineWidth: 3,
                                                percent: item.voteAverage / 10,
                                                center: Text(
                                                  '${(item.voteAverage * 10).toStringAsFixed(0)}%',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                progressColor:
                                                    item.voteAverage >= 7
                                                        ? Colors.green
                                                        : item.voteAverage >= 4
                                                        ? Colors.orange
                                                        : Colors.red,
                                                backgroundColor:
                                                    Colors.grey.shade800,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MovieLandDimentions.spaceXLarge,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item.title,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleSmall,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MovieLandDimentions.spaceSmall,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      DatetimeConverter()
                                          .convertToHumanReadable(
                                            item.releaseDate,
                                          ),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
