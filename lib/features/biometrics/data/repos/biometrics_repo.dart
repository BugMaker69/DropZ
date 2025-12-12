import 'package:drop_z_ecommerce_app/features/biometrics/data/model/biometrics_status.dart';

abstract class BiometricsRepo {
  Future<BiometricsStatus> checkBiometricsSupport();
  Future<bool> authenticateUser();
}
