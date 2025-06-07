import 'dart:io';

import 'package:nesp_sdk_flutter_updater/src/version.dart';

class PackageBundle {
  const PackageBundle({
    required this.forceUpdate,
    required this.version,
    required this.downloadUrl,
    required this.destinationFile,
    required this.notes,
  });

  final bool forceUpdate;
  final Version version;
  final String downloadUrl;
  final File destinationFile;
  final String notes;

  static PackageBundle empty = PackageBundle(
    forceUpdate: false,
    version: const Version(code: -1, name: ''),
    downloadUrl: '',
    destinationFile: File(''),
    notes: '',
  );

  PackageBundle copyWith({
    bool? forceUpdate,
    Version? version,
    String? downloadUrl,
    File? destinationFile,
    String? notes,
  }) {
    return PackageBundle(
      forceUpdate: forceUpdate ?? this.forceUpdate,
      version: version ?? this.version,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      destinationFile: destinationFile ?? this.destinationFile,
      notes: notes ?? this.notes,
    );
  }
}
