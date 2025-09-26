import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_land/core/utils/movie_land_dimentions.dart';
import 'package:movie_land/data/models/movie_model.dart';
import 'package:movie_land/data/repositories/movie_list_repository.dart';
import 'package:movie_land/data/services/movie_lists_api.dart';
import 'package:movie_land/presentation/components/movie_cart.dart';
import 'package:movie_land/presentation/viewmodels/dashboard_view_model.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardViewModel>(
      create:
          (_) => DashboardViewModel(
            movieRepository: MovieListRepositoryImp(api: MovieListsApiImpl()),
            context: context,
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
      appBar: AppBar(
        title: const Text('Movie Land'),
        actions: [
          IconButton(
            onPressed: read.goToFavoriteMovies,
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
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
                            (context, item, index) => MovieCart(
                              item: item,
                              addToFavorite: read.addToFavorite,
                              onTap:
                                  () =>
                                      read.goToMovieDetail(item.id.toString()),
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
