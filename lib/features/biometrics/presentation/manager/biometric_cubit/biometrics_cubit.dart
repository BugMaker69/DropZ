import 'package:drop_z_ecommerce_app/features/biometrics/data/repos/biometrics_repo.dart';
import 'package:drop_z_ecommerce_app/features/biometrics/presentation/manager/biometric_cubit/biometrics_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BiometricsCubit extends Cubit<BiometricsState> {
  final BiometricsRepo biometricsRepo;

  BiometricsCubit(this.biometricsRepo) : super(BiometricsInitial());

  Future<void> checkBiometrics() async {
    emit(BiometricsLoading());

    final status = await biometricsRepo.checkBiometricsSupport();
    emit(BiometricsSupportStatus(status));
  }

  Future<void> authenticate() async {
    emit(BiometricsLoading());

    final ok = await biometricsRepo.authenticateUser();

    if (ok) {
      emit(BiometricsSuccess());
    } else {
      emit(BiometricsFailed("Authentication failed"));
    }
  }
}
