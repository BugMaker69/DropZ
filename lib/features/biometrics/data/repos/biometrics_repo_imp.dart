import 'package:drop_z_ecommerce_app/features/biometrics/data/model/biometrics_status.dart';
import 'package:drop_z_ecommerce_app/features/biometrics/data/repos/biometrics_repo.dart';
import 'package:local_auth/local_auth.dart';

class BiometricsRepoImp implements BiometricsRepo {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Future<BiometricsStatus> checkBiometricsSupport() async {
    final isSupported = await _localAuth.isDeviceSupported();
    final canCheck = await _localAuth.canCheckBiometrics;
    final types = await _localAuth.getAvailableBiometrics();

    return BiometricsStatus(
      isDeviceSupported: isSupported,
      isBiometricAvailable: canCheck,
      hasFingerprint: types.contains(BiometricType.fingerprint),
      hasFaceId: types.contains(BiometricType.face),
    );
  }

  @override
  Future<bool> authenticateUser() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: "Please authenticate to proceed",
        biometricOnly: true,
        sensitiveTransaction: true,
        persistAcrossBackgrounding: false,
      );
    } catch (e) {
      print("Biometrics Error: $e");
      return false;
    }
  }
}
