import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;

  const Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection Timeout with Api server');

      case DioExceptionType.sendTimeout:
        return ServerFailure('Send Timeout with Api server');

      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receiver Timeout with Api server');

      case DioExceptionType.badCertificate:
        return ServerFailure('Bad Certificate');

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioError.response!.statusCode!,
          dioError.response!.data,
        );

      case DioExceptionType.cancel:
        return ServerFailure('Canceled Request To Api Server');

      case DioExceptionType.connectionError:
        return ServerFailure('Connection Error To Api Server');

      case DioExceptionType.unknown:
        if (dioError.message!.contains('SocketException')) {
          return ServerFailure('No Internet Connection To Api Server');
        }
        return ServerFailure('UnExpected Error');
      default:
        return ServerFailure("Opps ");
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(
        "${response.toString()} + $statusCode",
        // response['email'].toString(), //! Register endpoint When Email Already Exits
      ); //! Wants To Change According To API
    } else if (statusCode == 404) {
      return ServerFailure('Not Found');
    } else if (statusCode == 500) {
      return ServerFailure('Internal Server Error');
    } else {
      return ServerFailure("Opps ");
    }
  }
}
