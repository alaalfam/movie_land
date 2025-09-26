class GenresModel {
  final int id;
  final String name;

  GenresModel({required this.id, required this.name});

  factory GenresModel.fromJson(Map<String, dynamic> json) {
    return GenresModel(id: json['id'] as int, name: json['name'] as String);
  }
}
