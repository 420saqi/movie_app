import 'package:flutter/cupertino.dart';

class MovieProvider with ChangeNotifier {
  final List _favouriteMoviesList = [];
  List get favouriteMoviesList => _favouriteMoviesList;
  bool _isFavourite = false;
  bool get isFavourite => _isFavourite;

  void toggleFavourite(favourite) {
    _isFavourite = favourite;
  }

  void getFavouriteMovie(movie) {
    if (_favouriteMoviesList.contains(movie)) {
      _favouriteMoviesList.remove(movie);
      notifyListeners();
      return;
    }
    _favouriteMoviesList.add(movie);
    notifyListeners();
  }
}
