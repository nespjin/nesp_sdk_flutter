import 'package:flutter/cupertino.dart';
import 'package:nesp_sdk_flutter_ui/src/l10n/strings.dart';
import 'package:nesp_sdk_flutter_ui/src/text.dart';

enum StatusViewStatus {
  loading,
  empty,

  /// Errors must be defined below of [StatusViewStatus.networkError]
  networkError,
  otherError;

  bool get isError => index >= StatusViewStatus.networkError.index;
}

class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.status,
    this.isShowMessage = false,
    this.message = '',
    this.messageStyle,
    this.onRetryTap,
    this.loading,
    this.empty,
    this.networkError,
    this.otherError,
  });

  final StatusViewStatus status;
  final bool isShowMessage;
  final String? message;
  final TextStyle? messageStyle;
  final GestureTapCallback? onRetryTap;

  final Widget? loading;
  final Widget? empty;
  final Widget? networkError;
  final Widget? otherError;

  @override
  Widget build(BuildContext context) {
    final loading = this.loading ??
        const CupertinoActivityIndicator(
          radius: 15,
        );
    final empty = this.empty ??
        Image.asset(
          'packages/flutter_sdk_package/assets/images/image_empty.png',
          height: 100,
        );
    final networkError = this.networkError ??
        Image.asset(
          'packages/flutter_sdk_package/assets/images/image_network_error.png',
          height: 100,
        );
    final otherError = this.otherError ??
        Image.asset(
          'packages/flutter_sdk_package/assets/images/image_empty.png',
          height: 100,
        );
    // Default status is loading.
    Widget statusWidget = loading;
    if (status == StatusViewStatus.empty) {
      statusWidget = empty;
    } else if (status == StatusViewStatus.networkError) {
      statusWidget = networkError;
    } else if (status == StatusViewStatus.otherError) {
      statusWidget = otherError;
    }

    var message = this.message ?? '';
    if (message.isEmpty) {
      if (status == StatusViewStatus.loading) {
        message = '${Strings.of(context).status_loading}...';
      } else if (status == StatusViewStatus.empty) {
        message = Strings.of(context).status_empty_data;
      } else if (status == StatusViewStatus.networkError) {
        message = Strings.of(context).status_net_lose;
        if (onRetryTap != null) {
          message += ', ${Strings.of(context).status_retry}';
        }
      } else if (status == StatusViewStatus.otherError) {
        message = Strings.of(context).status_failure;
        if (onRetryTap != null) {
          message += ', ${Strings.of(context).status_retry}';
        }
      }
    }

    var messageStyle = const TextStyle(
      color: Color(0xFF666666),
      fontSize: 16,
      fontWeight: FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    );
    if (this.messageStyle != null) {
      messageStyle = this.messageStyle!.merge(messageStyle);
    }
    return Center(
      child: GestureDetector(
        onTap: () {
          if (status.isError) {
            onRetryTap?.call();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            statusWidget,
            if (isShowMessage && message.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text2(
                  message,
                  maxLines: 1,
                  style: messageStyle,
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
