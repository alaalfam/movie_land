import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_land/data/models/movie_model.dart';

class MyHive {
  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    // Register adapters and open boxes here
    _registerAdapters();
  }

  static void _registerAdapters() {
    // Register other adapters if you have more models
    Hive.registerAdapter(MovieModelAdapter());
  }
}
