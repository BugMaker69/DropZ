import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';

class CubitHandler {
  static Future<void> run<T>({
    required Cubit cubit,
    required Future<Either<Failure, T>> Function() call,
    required Function(T) onSuccess,
    Function(String msg)? onError,
    required Function() loadingState,
    required Function(String msg) failureState,
  }) async {
    loadingState();

    final result = await call();

    result.fold(
      (failure) => onError != null
          ? onError(failure.errMessage)
          : failureState(failure.errMessage),
      (data) => onSuccess(data),
    );
  }
}
