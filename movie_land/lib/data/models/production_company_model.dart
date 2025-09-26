class ProductionCompanyModel {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  ProductionCompanyModel({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory ProductionCompanyModel.fromJson(Map<String, dynamic> json) {
    return ProductionCompanyModel(
      id: json['id'] ?? 0,
      logoPath: json['logo_path'] as String?,
      name: json['name'] ?? '',
      originCountry: json['origin_country'] ?? '',
    );
  }
  
}