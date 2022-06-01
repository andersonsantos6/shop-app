class HttpException implements Exception {
  late final String msg;
  late final int statusCode;

  HttpException({required this.msg, required this.statusCode});

  @override
  String toString() {
    return msg;
  }
}
