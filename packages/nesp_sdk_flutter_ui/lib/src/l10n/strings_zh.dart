import 'strings.dart';

/// The translations for Chinese (`zh`).
class StringsZh extends Strings {
  StringsZh([String locale = 'zh']) : super(locale);

  @override
  String get status_loading => '加载中';

  @override
  String get status_empty_data => '暂无数据';

  @override
  String get status_net_lose => '请检查网络';

  @override
  String get status_retry => '请点击重试';

  @override
  String get status_failure => '操作失败';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String dialog_updater_title(String versionName) {
    return '新版本: $versionName';
  }

  @override
  String get msg_update_failed => '升级失败';

  @override
  String get download_failed => '下载失败';
}
