import 'package:app_installer/app_installer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nesp_sdk_dart_file_downloader/nesp_sdk_dart_file_downloader.dart';
import 'package:nesp_sdk_flutter_ui/nesp_sdk_flutter_ui.dart';
import 'package:nesp_sdk_flutter_updater/src/l10n/strings.dart';
import 'package:nesp_sdk_flutter_updater/src/package_bundle.dart';
import 'package:nesp_sdk_flutter_updater/src/update_dialog.dart';

const String _globalUpdaterDialogRouteName =
    'flutter_sdk_package/updater/update_dialog';

BuildContext? _updaterDialogContext;

/// TODO: Support Notification
class UpdaterManager {
  UpdaterManager(this.context);

  final BuildContext context;
  late PackageBundle packageBundle;

  var isShowNotifications = false;

  // var isSilenceEnabled = false;
  // var isSilenceOnly = false;

  bool ignoreWhenClickCancel = false;

  GestureTapCallback? onCancelTap;
  GestureTapCallback? onConfirmTap;

  late final OnFileDownloadListener _onFileDownloadListener =
      _OnFileDownloadListenerImpl(this);
  late final FileDownloader _fileDownloader = FileDownloader(
    downloadUrl: packageBundle.downloadUrl,
    destinationFile: packageBundle.destinationFile,
  )..onFileDownloadListener = _onFileDownloadListener;
  UpdaterDialogController? updaterDialogController;

  static final Set<String> _ignoredVersionNames = {};

  void ignore() {
    _ignoredVersionNames.add(packageBundle.version.name);
  }

  bool isIgnored() {
    return _ignoredVersionNames.contains(packageBundle.version.name);
  }

  static void clearAllIgnoredVersionNames() {
    _ignoredVersionNames.clear();
  }

  void showDialog({
    required BuildContext context,
    bool isFromUser = false,
    bool isDismissLast = false,
  }) {
    if (!isFromUser && isIgnored()) {
      return;
    }

    updaterDialogController = UpdaterDialogController(-1);

    bool isCancelable = !packageBundle.forceUpdate;

    showAppDialog(
      context: context,
      routeSettings: const RouteSettings(name: _globalUpdaterDialogRouteName),
      backPressedDismissible: isCancelable,
      barrierDismissible: false,
      builder: (context) {
        final String versionName = packageBundle.version.name;
        _updaterDialogContext = context;
        return UpdateDialog(
          title: Strings.of(context).dialog_updater_title(versionName),
          message: packageBundle.notes,
          controller: updaterDialogController!,
          isCancelable: isCancelable,
          onCancelTap: () {
            isCancelable = true;
            _onCancelTap();
          },
          onConfirmTap: () {
            isCancelable = true;
            _onConfirmTap();
          },
          onDisposed: () {
            if (_fileDownloader.isDownloading()) {
              _fileDownloader.cancel();
            }
            updaterDialogController?.dispose();
            updaterDialogController = null;
            _updaterDialogContext = null;
          },
        );
      },
    );
  }

  static void dismissDialog() {
    if (_updaterDialogContext == null) {
      return;
    }
    Navigator.maybePop(_updaterDialogContext!);
    _updaterDialogContext = null;
  }

  void _onCancelTap() {
    onCancelTap?.call();
    _fileDownloader.cancel();
    if (ignoreWhenClickCancel) {
      ignore();
    }
  }

  void _onConfirmTap() {
    onConfirmTap?.call();
    _fileDownloader.download();
  }
}

class _OnFileDownloadListenerImpl implements OnFileDownloadListener {
  _OnFileDownloadListenerImpl(this.manager);

  final UpdaterManager manager;

  @override
  void onCancelled() {
    UpdaterManager.dismissDialog();
  }

  @override
  void onFailed(Exception? exception) {
    showToast(Strings.of(manager.context).download_failed);
    UpdaterManager.dismissDialog();
  }

  @override
  void onProgress(int length, int downloadLength, double progress) {
    var controller = manager.updaterDialogController;
    controller?.progress = (progress * 100).toInt();
  }

  @override
  void onSuccess() {
    UpdaterManager.dismissDialog();
    var path = manager.packageBundle.destinationFile.path;
    AppInstaller.installApk(path);
  }
}
