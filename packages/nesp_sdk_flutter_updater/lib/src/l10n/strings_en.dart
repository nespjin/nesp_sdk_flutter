import 'strings.dart';

/// The translations for English (`en`).
class StringsEn extends Strings {
  StringsEn([String locale = 'en']) : super(locale);

  @override
  String get status_loading => 'Loading';

  @override
  String get status_empty_data => 'no data';

  @override
  String get status_net_lose => 'Please check the network';

  @override
  String get status_retry => 'Please click to try again';

  @override
  String get status_failure => 'Operation failed';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String dialog_updater_title(String versionName) {
    return 'New Version: $versionName';
  }

  @override
  String get msg_update_failed => 'Update Failed';

  @override
  String get download_failed => 'Download Failed';
}
