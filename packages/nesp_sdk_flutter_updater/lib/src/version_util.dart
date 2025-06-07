import 'dart:math';

class VersionUtil {
  const VersionUtil._();

  static int compareVersionName(String versionName, String otherVersionName) {
    final versionNameFragments = versionName.split('.');
    final otherVersionNameFragments = otherVersionName.split('.');
    final shortLength =
        min(versionNameFragments.length, otherVersionNameFragments.length);
    var ret = 0;
    int code, otherCode;
    for (var i = 0; i < shortLength; i++) {
      code = int.tryParse(versionNameFragments[i]) ?? 0;
      otherCode = int.tryParse(otherVersionNameFragments[i]) ?? 0;
      if (code != otherCode) {
        ret = code.compareTo(otherCode);
        break;
      }
    }

    if (ret != 0) {
      return ret;
    }

    if (versionNameFragments.length > otherVersionNameFragments.length) {
      final additionalVersionFragments = versionNameFragments.sublist(
          shortLength, versionNameFragments.length);
      int sumOfAdditionalVersion = 0;
      for (var fragment in additionalVersionFragments) {
        sumOfAdditionalVersion += (int.tryParse(fragment) ?? 0);
      }
      return sumOfAdditionalVersion != 0 ? 1 : 0;
    }

    if (versionNameFragments.length < otherVersionNameFragments.length) {
      final additionalVersionFragments = otherVersionNameFragments.sublist(
          shortLength, otherVersionNameFragments.length);
      int sumOfAdditionalVersion = 0;
      for (var fragment in additionalVersionFragments) {
        sumOfAdditionalVersion += (int.tryParse(fragment) ?? 0);
      }
      return sumOfAdditionalVersion != 0 ? -1 : 0;
    }

    return 0;
  }
}
