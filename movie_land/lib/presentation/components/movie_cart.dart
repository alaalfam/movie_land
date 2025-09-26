import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_land/core/utils/datetime_converter.dart';
import 'package:movie_land/core/utils/movie_land_dimentions.dart';
import 'package:movie_land/data/models/movie_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MovieCart extends StatelessWidget {
  final MovieModel item;
  final void Function(MovieModel) addToFavorite;
  const MovieCart({super.key, required this.item, required this.addToFavorite});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
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
                        (context, url) =>
                            const Center(child: CircularProgressIndicator()),
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
                      borderRadius: BorderRadius.circular(100),
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
                        backgroundColor: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.8, 1.0],
                        colors: [Colors.white70, Colors.white10],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ListView(
                            shrinkWrap: true,
                            children: [
                              ListTile(
                                leading: Icon(Icons.favorite_border),
                                title: Text('Add to Favorite'),
                                onTap: () {
                                  addToFavorite(item);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.menu),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MovieLandDimentions.spaceXLarge),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          SizedBox(height: MovieLandDimentions.spaceSmall),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              DatetimeConverter().convertToHumanReadable(item.releaseDate),
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
