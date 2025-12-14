import 'package:drop_z_ecommerce_app/features/biometrics/data/model/biometrics_status.dart';

abstract class BiometricsState {}

class BiometricsInitial extends BiometricsState {}

class BiometricsLoading extends BiometricsState {}

class BiometricsSuccess extends BiometricsState {}

class BiometricsSkipped extends BiometricsState {} // تم تخطي البصمة

class BiometricsFailed extends BiometricsState {
  final String message;
  BiometricsFailed(this.message);
}
