import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieProvider with ChangeNotifier {
  // final String _imagePath = 'https://image.tmdb.org/t/p/w500';
  // String get imagePath => _imagePath;
  // static const String _base_url = "https://api.themoviedb.org/3";
  //
  // static const endpoint = "/trending/movie/week";
  // static const endpoint2 = "/discover/movie";
  // dynamic _trendingMovies;
  // dynamic get trendingMovies => _trendingMovies;
  //
  // dynamic _year2024Movies;
  // dynamic get year2024Movies => _year2024Movies;
  // dynamic _year2023Movies;
  // dynamic get year2023Movies => _year2023Movies;
  // dynamic _actionMovies;
  // dynamic get actionMovies => _actionMovies;
  // dynamic _adventureMovies;
  // dynamic get adventureMovies => _adventureMovies;
  // dynamic _animationMovies;
  // dynamic get animationMovies => _adventureMovies;
  //
  // Future<void> getTrendingMovies() async {
  //   final response = await http.get(
  //     Uri.parse(
  //         '$_base_url$endpoint?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&page=2'),
  //     // '$base_url$endpoint?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&page=2&primary_release_year=2024'),
  //   );
  //   _trendingMovies = jsonDecode(response.body);
  //   notifyListeners();
  // }
  //
  // Future<void> get2024Movies() async {
  //   final year2024response = await http.get(
  //     Uri.parse(
  //         '$_base_url$endpoint2?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&primary_release_year=2024'),
  //   );
  //   if (year2024response.statusCode == 200) {
  //     final year2024DecodedData = jsonDecode(year2024response.body);
  //     // print('💋💋💋💋$year2024DecodedData');
  //     _year2024Movies = year2024DecodedData;
  //   }
  //
  //   notifyListeners();
  // }
  //
  // Future<void> get2023Movies() async {
  //   final year2023response = await http.get(
  //     Uri.parse(
  //         '$_base_url$endpoint2?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&primary_release_year=2023'),
  //   );
  //   if (year2023response.statusCode == 200) {
  //     final year2023DecodedData = jsonDecode(year2023response.body);
  //     _year2023Movies = year2023DecodedData;
  //   }
  //   notifyListeners();
  // }
  //
  // Future<void> getActionMovies() async {
  //   final actionMoviesResponse = await http.get(
  //     Uri.parse(
  //         '$_base_url$endpoint2?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&with_genres=28'),
  //   );
  //   if (actionMoviesResponse.statusCode == 200) {
  //     final genreMoviesDecodedData = jsonDecode(actionMoviesResponse.body);
  //     _actionMovies = genreMoviesDecodedData;
  //   }
  //   notifyListeners();
  // }
  //
  // Future<void> getAdventureMovies() async {
  //   final genreMovie = await http.get(
  //     Uri.parse(
  //         '$_base_url$endpoint2?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&with_genres=12'),
  //   );
  //   if (genreMovie.statusCode == 200) {
  //     final genreMoviesDecodedData = jsonDecode(genreMovie.body);
  //     _adventureMovies = genreMoviesDecodedData;
  //   }
  //   notifyListeners();
  // }
  //
  // Future<void> getAnimatedMovies() async {
  //   final allMovieGenre = await http.get(
  //     Uri.parse(
  //         '$_base_url$endpoint2?api_key=828de4c89f0f46b09932b0a5bbb6dfd1&language=en_US&with_genres=16,18'),
  //   );
  //   if (allMovieGenre.statusCode == 200) {
  //     final genreMoviesDecodedData = jsonDecode(allMovieGenre.body);
  //     _animationMovies = genreMoviesDecodedData;
  //     // print(animationMovies);
  //   }
  //   notifyListeners();
  // }
}
