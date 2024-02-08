import 'package:flutter/cupertino.dart';

class MovieProvider with ChangeNotifier {
  final List _favouriteMoviesList = [];
  List get favouriteMoviesList => _favouriteMoviesList;
  bool _isFavourite = false;
  bool get isFavourite => _isFavourite;
  final List<String> _searchHistory = [];
  List<String> get searchHistory => _searchHistory;
  bool _showHistory = false;
  bool get showHistory => _showHistory;

  void showHistoryFunction(show) {
    _showHistory = show;
    notifyListeners();
  }

  void getSearchedItem(String movieTitle) {
    if (_searchHistory.contains(movieTitle)) {
      return;
    }
    _searchHistory.add(movieTitle);
    notifyListeners();
  }

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
