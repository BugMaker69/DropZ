import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';

class RepoRequest {
  static Future<Either<Failure, T>> call<T>({
    required Future<dynamic> Function() request,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final data = await request();
      return Right(parser(data));
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
