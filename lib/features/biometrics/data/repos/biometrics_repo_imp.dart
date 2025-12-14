import 'package:drop_z_ecommerce_app/features/biometrics/data/model/biometrics_status.dart';
import 'package:drop_z_ecommerce_app/features/biometrics/data/repos/biometrics_repo.dart';
import 'package:local_auth/local_auth.dart';
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
        localizedReason: "Confirm your identity",
        biometricOnly: true, // البصمة فقط
        sensitiveTransaction: true, // تأكيد العملية الحساسة
        persistAcrossBackgrounding:
            false, // عدم استمرار المصادقة إذا خرج التطبيق للخلفية
      );
    } catch (e) {
      print("Biometrics Error: $e");
      return false;
    }
  }
}
