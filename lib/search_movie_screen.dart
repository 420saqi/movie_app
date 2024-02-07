import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_pp/widgets/reusableTextWidget.dart';
import 'package:movie_pp/widgets/reusableTitleWidget.dart';
import 'package:http/http.dart' as http;

import 'movie_detail_screen.dart';

///
///
///   add a search movie option
///   filters option
///
///
class SearchMovieScreen extends StatefulWidget {
  SearchMovieScreen({super.key, required this.getAllMovies});
  final List getAllMovies;
  @override
  State<SearchMovieScreen> createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  final String imagePath = 'https://image.tmdb.org/t/p/w500';
  bool isSearching = false;
  Map<String, dynamic> movieDetails = {};
  TextEditingController searchMovieController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: const Text('Search Movie'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  onSubmitted: (value) async {
                    if (value.isEmpty) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enter Movie Title')));
                      return;
                    }
                    print(value);
                    setState(() {
                      isSearching = true;
                    });
                    //
                    ///
                    /// call api here
                    //
                    const String base_url = "https://api.themoviedb.org/3";

                    const endpoint = "/search/movie";

                    try {
                      final response = await http.get(
                        Uri.parse(
                            '$base_url$endpoint?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&query=$value'),
                      );
                      movieDetails = jsonDecode(response.body);
                      print(movieDetails);
                      setState(() {
                        isSearching = false;
                      });
                    } catch (e) {
                      print('Error in finding movie ❤❤❤ $e');
                      setState(() {
                        isSearching = false;
                      });
                    }
                  },
                  controller: searchMovieController,
                  style: const TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.white70),
                    labelText: 'Search For a Movie',
                    suffixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.white70,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white38),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white38),
                    ),
                  ),
                ),
              ),

              ///
              /// GridView builder to show all movies
              //
              ReusableTitleWidget(
                  title: (movieDetails.toString() != 'null' &&
                          movieDetails.isNotEmpty)
                      ? 'Results for ${searchMovieController.text}'
                      : 'All Movies'),

              isSearching == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (movieDetails.toString() != 'null' &&
                          movieDetails.isNotEmpty)
                      ? SizedBox(
                          height: 500,
                          child: movieDetails['results'].isEmpty
                              ? const Text(
                                  'No movie Found',
                                  style: TextStyle(color: Colors.white70),
                                )
                              : GridView.builder(
                                  itemCount: movieDetails['results'].length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        print('goto movie detail screen');

                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(
                                            movieTitle: movieDetails['results']
                                                [index]['title'],
                                            movie: movieDetails['results']
                                                [index],
                                            allSimilarMovies: movieDetails,
                                          ),
                                        ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: movieDetails['results']
                                                              [index]
                                                          ['backdrop_path'] !=
                                                      null
                                                  ? Image.network(
                                                      imagePath +
                                                          movieDetails['results']
                                                                      [index][
                                                                  'backdrop_path']
                                                              .toString(),
                                                      width: 100,
                                                      height: 70,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Icon(
                                                      Icons.movie,
                                                      size: 60,
                                                      color:
                                                          Colors.grey.shade800,
                                                    ),
                                            ),
                                            ReusableTextWidget(
                                              width: 80,
                                              fontSize: 7,
                                              title: movieDetails['results']
                                                  [index]['original_title'],
                                            ),
                                            ReusableTextWidget(
                                              width: 80,
                                              fontSize: 7,
                                              title: movieDetails['results']
                                                  [index]['release_date'],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        )
                      : SizedBox(
                          height: 500,
                          child: GridView.builder(
                            itemCount: widget.getAllMovies.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  print('goto movie detail screen');

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      movieTitle: widget.getAllMovies[index]
                                          ['title'],
                                      movie: widget.getAllMovies[index],
                                      // allSimilarMovies: animationMovies,
                                    ),
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: widget.getAllMovies[index]
                                                    ['backdrop_path'] !=
                                                null
                                            ? Image.network(
                                                imagePath +
                                                    widget.getAllMovies[index]
                                                            ['backdrop_path']
                                                        .toString(),
                                                width: 100,
                                                height: 70,
                                                fit: BoxFit.cover,
                                              )
                                            : Icon(
                                                Icons.movie,
                                                size: 60,
                                                color: Colors.grey.shade800,
                                              ),
                                      ),
                                      ReusableTextWidget(
                                        width: 80,
                                        fontSize: 7,
                                        title: widget.getAllMovies[index]
                                            ['original_title'],
                                      ),
                                      ReusableTextWidget(
                                        width: 80,
                                        fontSize: 7,
                                        title: widget.getAllMovies[index]
                                            ['release_date'],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ],
          ),
        ));
  }
}
