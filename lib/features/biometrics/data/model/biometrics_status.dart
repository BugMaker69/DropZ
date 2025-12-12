class BiometricsStatus {
  final bool isDeviceSupported;
  final bool isBiometricAvailable;
  final bool hasFingerprint;
  final bool hasFaceId;

  const BiometricsStatus({
    required this.isDeviceSupported,
    required this.isBiometricAvailable,
    required this.hasFingerprint,
    required this.hasFaceId,
  });

  BiometricsStatus copyWith({
    bool? isDeviceSupported,
    bool? isBiometricAvailable,
    bool? hasFingerprint,
    bool? hasFaceId,
  }) {
    return BiometricsStatus(
      isDeviceSupported: isDeviceSupported ?? this.isDeviceSupported,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      hasFingerprint: hasFingerprint ?? this.hasFingerprint,
      hasFaceId: hasFaceId ?? this.hasFaceId,
    );
  }
}
