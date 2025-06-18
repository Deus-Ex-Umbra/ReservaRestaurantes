class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = 'Unauthorized'])
    : super(message, statusCode: 401);
}

class NotFoundException extends ApiException {
  NotFoundException([String message = 'Not Found'])
    : super(message, statusCode: 404);
}

class ServerErrorException extends ApiException {
  ServerErrorException([String message = 'Server Error'])
    : super(message, statusCode: 500);
}

class BadRequestException extends ApiException {
  BadRequestException([String message = 'Bad Request'])
    : super(message, statusCode: 400);
}
