import 'dart:convert';

import 'package:MoviePKR/models/Movie.dart';
import 'package:MoviePKR/models/movieList.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MovieLists with ChangeNotifier {
  SharedPreferences prefs;

  List<MovieList> _myLists = [];
  List<Movie> _trendingMovies = [];

  List<MovieList> get movieLists => [..._myLists];
  List<Movie> get trendingList => [..._trendingMovies];
  //List<Movie> get searchedList => [..._searchedMovies];

  void addNewList(MovieList newList) {
    _myLists.add(newList);
    saveToSF();
    //todo handle error/exception.
    notifyListeners();
  }

  void removeList(MovieList movieList) {
    _myLists.remove(movieList);
    saveToSF();
    notifyListeners();
  }

  MovieList getListAtIndex(int index) {
    return _myLists[index];
  }

  static Future<List<Movie>> fetchMovies(String keyword) async {
    final response = await http.get(
        'https://api.themoviedb.org/3/search/movie?api_key=837ac1cc736282b8a8c9d58d52cd5a7c&language=en-US&query=' +
            keyword +
            '&page=1&include_adult=false');
    List<Movie> searchedMovies = [];
    var data = json.decode(response.body)['results'];
    for (var item in data) {
      searchedMovies.add(Movie.fromJsonNoRuntime(item));
    }
    return searchedMovies;
  }

  Future<void> fetchTrendingList() async {
    try {
      final response = await http.get(
          'https://api.themoviedb.org/3/trending/movie/day?api_key=837ac1cc736282b8a8c9d58d52cd5a7c');

      var data = json.decode(response.body)['results'];
      for (var item in data) {
        _trendingMovies.add(Movie.fromJson(item));
      }
    } catch (error) {
      throw error;
    }
  }

  static Future<Movie> fetchMovieByID(int id) async {
    final response = await http.get("https://api.themoviedb.org/3/movie/" +
        id.toString() +
        "?api_key=837ac1cc736282b8a8c9d58d52cd5a7c&language-en-US");
    return Movie.fromJson(json.decode(response.body));
  }

  Future<void> saveToSF() async {
    var decoded = MovieList.encode(_myLists);
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('key', decoded);
  }

  _getList() async {
    prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('key');
    return data;
  }

  fetchSavedListsFromSF() async {
    String list = await _getList();
    if (list != null && list.isNotEmpty) {
      try {
        _myLists = MovieList.decode(list);
      } catch (error) {
        throw (error);
      }
    }
  }
}
