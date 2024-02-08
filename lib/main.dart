import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:movie_pp/favourite_movies_screen.dart';

import 'package:movie_pp/movie_detail_screen.dart';
import 'package:movie_pp/provider/movie_provider.dart';
import 'package:movie_pp/search_movie_screen.dart';
import 'package:movie_pp/widgets/reusableTextWidget.dart';
import 'package:movie_pp/widgets/reusableTitleWidget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MovieProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.deepPurple,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 23))),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
  dynamic trendingMovies;

  final String imagePath = 'https://image.tmdb.org/t/p/w500';
  dynamic year2024Movies;
  dynamic year2023Movies;
  dynamic actionMovies;
  dynamic adventureMovies;
  dynamic animationMovies;
  Future<Object?>? getMoviesFromApi() async {
    const String base_url = "https://api.themoviedb.org/3";

    const endpoint = "/trending/movie/week";
    const endpoint2 = "/discover/movie";

    final response = await http.get(
      Uri.parse(
          '$base_url$endpoint?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&page=2'),
      // '$base_url$endpoint?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&page=2&primary_release_year=2024'),
    );
    trendingMovies = jsonDecode(response.body);

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
    return trendingMovies;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          centerTitle: true,
          leading: const Icon(Icons.movie),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FavouriteMoviesScreen(),
                  ));
                },
                icon: const Icon(Icons.favorite_outline_rounded)),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  onPressed: () {
                    List allMovies = [
                      ...trendingMovies['results'],
                      ...year2023Movies['results'],
                      ...year2024Movies['results'],
                      ...actionMovies['results'],
                      ...adventureMovies['results'],
                      ...animationMovies['results'],
                    ];
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SearchMovieScreen(getAllMovies: allMovies),
                    ));
                  },
                  icon: const Icon(Icons.search)),
            ),
          ],
          title: const Text('SR Movies Co'),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: getMoviesFromApi(),
            builder: (context, snapshot) {
              if (snapshot.data.toString() == 'null') {
                return Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white38,
                    child: Column(
                      children: [
                        const ReusableTitleWidget(title: 'Trending Movies'),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Icon(
                                            Icons.movie,
                                            color: Colors.grey.shade700,
                                            size: 80,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )),
                        const ReusableTitleWidget(title: 'Trending Movies'),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Icon(
                                            Icons.movie,
                                            color: Colors.grey.shade700,
                                            size: 80,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )),
                        const ReusableTitleWidget(title: 'Trending Movies'),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Icon(
                                            Icons.movie,
                                            color: Colors.grey.shade700,
                                            size: 80,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )),
                        const ReusableTitleWidget(title: 'Trending Movies'),
                      ],
                    ));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // trending movies
                  const ReusableTitleWidget(title: 'Trending Movies'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 230,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: trendingMovies['results'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  print('goto movie detail screen');

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      movieTitle: trendingMovies['results']
                                          [index]['title'],
                                      movie: trendingMovies['results'][index],
                                      allSimilarMovies: trendingMovies,
                                    ),
                                  ));
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: trendingMovies['results'][index]
                                                  ['backdrop_path'] !=
                                              null
                                          ? Image.network(
                                              imagePath +
                                                  trendingMovies['results']
                                                              [index]
                                                          ['backdrop_path']
                                                      .toString(),
                                              width: 100,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.movie,
                                              size: 100,
                                              color: Colors.grey.shade800,
                                            ),
                                    ),
                                    const SizedBox(height: 7),
                                    ReusableTextWidget(
                                      fontSize: 11,
                                      title: trendingMovies['results'][index]
                                          ['original_title'],
                                    ),
                                    ReusableTextWidget(
                                      fontSize: 11,
                                      title: trendingMovies['results'][index]
                                          ['release_date'],
                                    ),
                                    ReusableTextWidget(
                                        fontSize: 11,
                                        title:
                                            '${trendingMovies['results'][index]['vote_count']} votes'),
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
                  const ReusableTitleWidget(title: '2024'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 230,
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
                                        width: 100,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    ReusableTextWidget(
                                      title: year2024Movies['results'][index]
                                          ['original_title'],
                                    ),
                                    ReusableTextWidget(
                                      title: year2024Movies['results'][index]
                                          ['release_date'],
                                    ),
                                    ReusableTextWidget(
                                        title:
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
                  const ReusableTitleWidget(title: '2023'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 230,
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
                                        width: 100,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    ReusableTextWidget(
                                      title: year2023Movies['results'][index]
                                          ['original_title'],
                                    ),
                                    ReusableTextWidget(
                                      title: year2023Movies['results'][index]
                                          ['release_date'],
                                    ),
                                    ReusableTextWidget(
                                        title:
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
                  const ReusableTitleWidget(title: 'Action'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 230,
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
                                        width: 100,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    ReusableTextWidget(
                                      title: actionMovies['results'][index]
                                          ['original_title'],
                                    ),
                                    ReusableTextWidget(
                                      title: actionMovies['results'][index]
                                          ['release_date'],
                                    ),
                                    ReusableTextWidget(
                                        title:
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
                  const ReusableTitleWidget(title: 'Adventure'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 230,
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
                                        width: 100,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    ReusableTextWidget(
                                      title: adventureMovies['results'][index]
                                          ['original_title'],
                                    ),
                                    ReusableTextWidget(
                                      title: adventureMovies['results'][index]
                                          ['release_date'],
                                    ),
                                    ReusableTextWidget(
                                        title:
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
                  const ReusableTitleWidget(title: 'Animation'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 230,
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
                                        width: 100,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    ReusableTextWidget(
                                      title: animationMovies['results'][index]
                                          ['original_title'],
                                    ),
                                    ReusableTextWidget(
                                      title: animationMovies['results'][index]
                                          ['release_date'],
                                    ),
                                    ReusableTextWidget(
                                        title:
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
          ),
        ));
  }
}

// 589
