class MovieDb {
  static final MovieDb _instance = MovieDb._internal();

  factory MovieDb() {
    return _instance;
  }

  MovieDb._internal();
}