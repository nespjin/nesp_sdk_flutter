import 'dart:async';

import 'package:flutter/material.dart';

Future<NavigatorState> showLoadingDialog(
  BuildContext context, {
  Duration liveTime = Duration.zero,
  String? message,
  RouteSettings? routeSettings,
}) {
  var result = Completer<NavigatorState>();
  showDialog(
    context: context,
    routeSettings: routeSettings,
    builder: (context) {
      Timer? liveTimer;
      if (liveTime > Duration.zero) {
        liveTimer = Timer(liveTime, () => Navigator.maybePop(context));
      }
      if (!result.isCompleted) {
        result.complete(Navigator.of(context));
      }
      return UnconstrainedBox(
        child: LoadingDialog(
          message: message,
          onDisposed: () => liveTimer?.cancel(),
        ),
      );
    },
  );
  return result.future.timeout(const Duration(milliseconds: 100));
}

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({
    super.key,
    this.message,
    this.onDisposed,
  });

  final String? message;
  final VoidCallback? onDisposed;

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(
        minHeight: 120,
        minWidth: 120,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (widget.message?.isNotEmpty ?? false) ...[
            const SizedBox(height: 20),
            Text(
              widget.message!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            )
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.onDisposed?.call();
    super.dispose();
  }
}
