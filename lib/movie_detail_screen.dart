import 'package:flutter/material.dart';
import 'package:movie_pp/provider/movie_provider.dart';
import 'package:movie_pp/widgets/reusableTextWidget.dart';
import 'package:movie_pp/widgets/reusableTitleWidget.dart';
import 'package:provider/provider.dart';

class MovieDetailScreen extends StatelessWidget {
  MovieDetailScreen(
      {super.key, required this.movieTitle, this.movie, this.allSimilarMovies});
  final String movieTitle;
  final movie;
  final allSimilarMovies;
  final String imagePath = 'https://image.tmdb.org/t/p/w500';

  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(
          movieTitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
                onPressed: () {
                  print('Mark as favourite');
                  isFavourite = !isFavourite;
                  movieProvider.toggleFavourite(isFavourite);
                  movieProvider.getFavouriteMovie(movie);
                },
                icon: Icon(
                  movieProvider.favouriteMoviesList.contains(movie)
                      ? Icons.favorite_outlined
                      : Icons.favorite_outline,
                  color: movieProvider.favouriteMoviesList.contains(movie)
                      ? Colors.red
                      : Colors.white70,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 320,
              child: movie['backdrop_path'] != null
                  ? Image.network(
                      imagePath + movie['backdrop_path'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.movie,
                      size: 60,
                      color: Colors.grey.shade800,
                    ),
            ),
            // reusableRow('Title', value: movie['original_title']),
            reusableRow('Release date', value: movie['release_date']),
            reusableRow('Language', value: movie['original_language']),
            reusableRow('Votes', value: movie['vote_count'].toString()),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                  Text(
                    movie['overview'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            ///
            /// Similar Movies

            if (allSimilarMovies != null)
              Column(
                children: [
                  const ReusableTitleWidget(title: 'Similar Movies'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 260,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: allSimilarMovies['results'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  print('goto movie detail screen');
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      movieTitle: allSimilarMovies['results']
                                          [index]['title'],
                                      movie: allSimilarMovies['results'][index],
                                      allSimilarMovies: allSimilarMovies,
                                    ),
                                  ));
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: allSimilarMovies['results'][index]
                                                  ['backdrop_path'] !=
                                              null
                                          ? Image.network(
                                              imagePath +
                                                  allSimilarMovies['results']
                                                              [index]
                                                          ['backdrop_path']
                                                      .toString(),
                                              width: 120,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.movie,
                                              size: 60,
                                              color: Colors.grey.shade800,
                                            ),
                                    ),
                                    ReusableTextWidget(
                                      title: allSimilarMovies['results'][index]
                                          ['original_title'],
                                    ),
                                    ReusableTextWidget(
                                      title: allSimilarMovies['results'][index]
                                          ['release_date'],
                                    ),
                                    ReusableTextWidget(
                                        title:
                                            '${allSimilarMovies['results'][index]['vote_count']} votes'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget reusableRow(String key, {String value = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white),
          ),
          const SizedBox(width: 5),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
