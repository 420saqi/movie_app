import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:movie_pp/movie_detail_screen.dart';
import 'package:movie_pp/search_movie_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepPurple,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 23))),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic data;

  final String imagePath = 'https://image.tmdb.org/t/p/w500';
  dynamic year2024Movies;
  dynamic year2023Movies;
  dynamic actionMovies;
  dynamic adventureMovies;
  dynamic animationMovies;
  Future<Object?>? _incrementCounter() async {
    const String base_url = "https://api.themoviedb.org/3";

    const endpoint = "/trending/movie/week";
    const endpoint2 = "/discover/movie";

    final response = await http.get(
      Uri.parse(
          '$base_url$endpoint?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&page=2'),
      // '$base_url$endpoint?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&page=2&primary_release_year=2024'),
    );
    data = jsonDecode(response.body);

    ///
    ///
    /// 2024
    ///
    final year2024response = await http.get(
      Uri.parse(
          '$base_url$endpoint2?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&primary_release_year=2024'),
    );
    if (year2024response.statusCode == 200) {
      final year2024DecodedData = jsonDecode(year2024response.body);
      // print('💋💋💋💋$year2024DecodedData');
      year2024Movies = year2024DecodedData;
    }

    ///
    /// 2023
    ///
    final year2023response = await http.get(
      Uri.parse(
          '$base_url$endpoint2?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&primary_release_year=2023'),
    );
    if (year2023response.statusCode == 200) {
      final year2023DecodedData = jsonDecode(year2023response.body);
      year2023Movies = year2023DecodedData;
    }

    ///
    ///
    /// action
    ///
    final actionMoviesResponse = await http.get(
      Uri.parse(
          '$base_url$endpoint2?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&with_genres=28'),
    );
    if (actionMoviesResponse.statusCode == 200) {
      final genreMoviesDecodedData = jsonDecode(actionMoviesResponse.body);
      actionMovies = genreMoviesDecodedData;
    }

    ///
    ///
    /// adventure
    //
    final genreMovie = await http.get(
      Uri.parse(
          '$base_url$endpoint2?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&with_genres=12'),
    );
    if (genreMovie.statusCode == 200) {
      final genreMoviesDecodedData = jsonDecode(genreMovie.body);
      adventureMovies = genreMoviesDecodedData;
    }

    ///
    /// animation movies
    //
    final allMovieGenre = await http.get(
      Uri.parse(
          '$base_url$endpoint2?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&with_genres=16,18'),
    );
    if (allMovieGenre.statusCode == 200) {
      final genreMoviesDecodedData = jsonDecode(allMovieGenre.body);
      animationMovies = genreMoviesDecodedData;
      // print(animationMovies);
    }
    return data;
  }

  @override
  void initState() {
    _incrementCounter;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(data['results'][0]);

    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          centerTitle: true,
          leading: const Icon(Icons.movie),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchMovieScreen(),
                    ));
                  },
                  icon: const Icon(Icons.search)),
            )
          ],
          title: const Text('SR Movies Co'),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.data.toString() == 'null') {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // trending movies
                  reusableTitle('Trending Movies'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 260,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data['results'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  print('goto movie detail screen');

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      movieTitle: data['results'][index]
                                          ['title'],
                                      movie: data['results'][index],
                                      allSimilarMovies: data,
                                    ),
                                  ));
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imagePath +
                                            data['results'][index]
                                                    ['backdrop_path']
                                                .toString(),
                                        width: 120,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    reusableTextWidget(
                                      data['results'][index]['original_title'],
                                    ),
                                    reusableTextWidget(
                                      data['results'][index]['release_date'],
                                    ),
                                    reusableTextWidget(
                                        '${data['results'][index]['vote_count']} votes'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )),

                  ///
                  /// 2024
                  //
                  reusableTitle('2024'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 260,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: year2024Movies['results'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  print('goto movie detail screen');

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      movieTitle: year2024Movies['results']
                                          [index]['title'],
                                      movie: year2024Movies['results'][index],
                                      allSimilarMovies: year2024Movies,
                                    ),
                                  ));
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imagePath +
                                            year2024Movies['results'][index]
                                                    ['backdrop_path']
                                                .toString(),
                                        width: 120,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    reusableTextWidget(
                                      year2024Movies['results'][index]
                                          ['original_title'],
                                    ),
                                    reusableTextWidget(
                                      year2024Movies['results'][index]
                                          ['release_date'],
                                    ),
                                    reusableTextWidget(
                                        '${year2024Movies['results'][index]['vote_count']} votes'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )),

                  ///
                  ///
                  /// 2023
                  //
                  reusableTitle('2023'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 260,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: year2023Movies['results'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  print('goto movie detail screen');

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      movieTitle: year2023Movies['results']
                                          [index]['title'],
                                      movie: year2023Movies['results'][index],
                                      allSimilarMovies: year2023Movies,
                                    ),
                                  ));
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imagePath +
                                            year2023Movies['results'][index]
                                                    ['backdrop_path']
                                                .toString(),
                                        width: 120,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    reusableTextWidget(
                                      year2023Movies['results'][index]
                                          ['original_title'],
                                    ),
                                    reusableTextWidget(
                                      year2023Movies['results'][index]
                                          ['release_date'],
                                    ),
                                    reusableTextWidget(
                                        '${year2023Movies['results'][index]['vote_count']} votes'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )),

                  ///
                  ///
                  /// ACTION
                  //
                  reusableTitle('Action'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 260,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: actionMovies['results'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  print('goto movie detail screen');

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      movieTitle: actionMovies['results'][index]
                                          ['title'],
                                      allSimilarMovies: actionMovies,
                                      movie: actionMovies['results'][index],
                                    ),
                                  ));
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imagePath +
                                            actionMovies['results'][index]
                                                    ['backdrop_path']
                                                .toString(),
                                        width: 120,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    reusableTextWidget(
                                      actionMovies['results'][index]
                                          ['original_title'],
                                    ),
                                    reusableTextWidget(
                                      actionMovies['results'][index]
                                          ['release_date'],
                                    ),
                                    reusableTextWidget(
                                        '${actionMovies['results'][index]['vote_count']} votes'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )),

                  ///
                  ///
                  /// ADVENTURE
                  //
                  reusableTitle('Adventure'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 260,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: adventureMovies['results'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  print('goto movie detail screen');

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      movieTitle: adventureMovies['results']
                                          [index]['title'],
                                      allSimilarMovies: adventureMovies,
                                      movie: adventureMovies['results'][index],
                                    ),
                                  ));
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imagePath +
                                            adventureMovies['results'][index]
                                                    ['backdrop_path']
                                                .toString(),
                                        width: 120,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    reusableTextWidget(
                                      adventureMovies['results'][index]
                                          ['original_title'],
                                    ),
                                    reusableTextWidget(
                                      adventureMovies['results'][index]
                                          ['release_date'],
                                    ),
                                    reusableTextWidget(
                                        '${adventureMovies['results'][index]['vote_count']} votes'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )),

                  ///
                  ///
                  /// genre 18 animation
                  //
                  reusableTitle('Animation'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 260,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: animationMovies['results'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  print('goto movie detail screen');

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      movieTitle: animationMovies['results']
                                          [index]['title'],
                                      movie: animationMovies['results'][index],
                                      allSimilarMovies: animationMovies,
                                    ),
                                  ));
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imagePath +
                                            animationMovies['results'][index]
                                                    ['backdrop_path']
                                                .toString(),
                                        width: 120,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    reusableTextWidget(
                                      animationMovies['results'][index]
                                          ['original_title'],
                                    ),
                                    reusableTextWidget(
                                      animationMovies['results'][index]
                                          ['release_date'],
                                    ),
                                    reusableTextWidget(
                                        '${animationMovies['results'][index]['vote_count']} votes'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )),
                ],
              );
            },
            future: _incrementCounter(),
          ),
        ));
  }
}

Widget reusableTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8.0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(50), bottomRight: Radius.circular(50))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
      ),
    ),
  );
}

Widget reusableTextWidget(String text) {
  return SizedBox(
    width: 120,
    child: Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Text(
        text,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    ),
  );
}
