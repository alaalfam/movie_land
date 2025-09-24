class SuccessResponseModel<T> {
  bool? success;
  String? message;
  T? data;
  SuccessResponseModel({this.success, this.message, this.data});

  factory SuccessResponseModel.fromJson(Map<String, dynamic> json) {
    return SuccessResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] as T,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data};
  }
}
