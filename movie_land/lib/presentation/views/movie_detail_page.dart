import 'package:flutter/material.dart';
import 'package:movie_land/presentation/viewmodels/movie_detail_view_model.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatelessWidget {
  final String id;
  const MovieDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailViewModel(),
      child: _MovieDetailPage(),
    );
  }
}

class _MovieDetailPage extends StatelessWidget {
  const _MovieDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),
      body: Center(child: Text('Movie Details Content Here')),
    );
  }
}
