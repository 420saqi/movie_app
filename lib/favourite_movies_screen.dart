import 'package:flutter/material.dart';
import 'package:movie_pp/provider/movie_provider.dart';
import 'package:movie_pp/widgets/reusableTextWidget.dart';
import 'package:movie_pp/widgets/reusableTitleWidget.dart';
import 'package:provider/provider.dart';

import 'movie_detail_screen.dart';

class FavouriteMoviesScreen extends StatelessWidget {
  final String imagePath = 'https://image.tmdb.org/t/p/w500';

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    print(movieProvider.favouriteMoviesList.length);
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text(
          'Favourite Movies',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: SizedBox(
            height: 800,
            child: GridView.builder(
              itemCount: movieProvider.favouriteMoviesList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    print('goto movie detail screen');

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(
                        movieTitle: movieProvider.favouriteMoviesList[index]
                            ['title'],
                        movie: movieProvider.favouriteMoviesList[index],
                      ),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: movieProvider.favouriteMoviesList[index]
                                      ['backdrop_path'] !=
                                  null
                              ? Image.network(
                                  imagePath +
                                      movieProvider.favouriteMoviesList[index]
                                              ['backdrop_path']
                                          .toString(),
                                  width: 120,
                                  height: 130,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.movie,
                                  size: 100,
                                  color: Colors.grey.shade800,
                                ),
                        ),
                        ReusableTextWidget(
                          width: 80,
                          fontSize: 9,
                          title: movieProvider.favouriteMoviesList[index]
                              ['original_title'],
                        ),
                        ReusableTextWidget(
                          width: 80,
                          fontSize: 7,
                          title: movieProvider.favouriteMoviesList[index]
                              ['release_date'],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
