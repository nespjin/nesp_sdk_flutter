import 'package:flutter/material.dart';
import 'package:nesp_sdk_flutter_ui/nesp_sdk_flutter_ui.dart';
import 'package:nesp_sdk_flutter_updater/src/l10n/strings.dart';

class UpdaterDialogController extends ChangeNotifier {
  UpdaterDialogController(int progress) : _progress = progress;
  int _progress;
  int get progress => _progress;
  set progress(int progress) {
    _progress = progress;
    notifyListeners();
  }
}

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({
    super.key,
    required this.title,
    required this.message,
    required this.controller,
    required this.isCancelable,
    this.onCancelTap,
    this.onConfirmTap,
    this.onDisposed,
  });

  final String title;
  final String message;
  final bool isCancelable;
  final UpdaterDialogController controller;
  final GestureTapCallback? onCancelTap;
  final GestureTapCallback? onConfirmTap;
  final VoidCallback? onDisposed;

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  @override
  void initState() {
    widget.controller.addListener(_onChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int progress = widget.controller.progress;
    return Container(
      constraints: const BoxConstraints(
        minHeight: 180,
      ),
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        children: [
          _buildTitle(widget.title),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            constraints: BoxConstraints(
              minHeight: 90,
              maxHeight: progress < 0 ? 300 : 90,
            ),
            child: progress < 0
                ? _buildMessage(widget.message)
                : _buildProgress(progress),
          ),
          _buildBottomActionContainer(context),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    widget.onDisposed?.call();
    super.dispose();
  }

  void _onChanged() {
    setState(() {
      // Refresh the UI
    });
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        color: Color(0xFF333333),
      ),
      maxLines: 1,
    );
  }

  Widget _buildMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: SingleChildScrollView(
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF333333),
          ),
        ),
      ),
    );
  }

  Widget _buildProgress(int progress) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.hardEdge,
            height: 5,
            child: LinearProgressIndicator(value: progress / 100),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$progress%',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionContainer(BuildContext context) {
    var children = <Widget>[];
    if (widget.isCancelable) {
      children.add(
        _buildAction(
          text: widget.controller.progress < 0
              ? '以后再说'
              : Strings.of(context).cancel,
          isPositive: false,
          onTap: () {
            widget.onCancelTap?.call();
          },
        ),
      );
    }

    if (widget.controller.progress < 0) {
      children.add(
        _buildAction(
          text: '立即更新',
          isPositive: true,
          onTap: () {
            widget.onConfirmTap?.call();
          },
        ),
      );
    }

    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }

  Widget _buildAction({
    required String text,
    required bool isPositive,
    GestureTapCallback? onTap,
  }) {
    return RoundCornerButton(
      text: text,
      width: 115,
      height: 45,
      backgroundColor:
          isPositive ? const Color(0xFF509EF0) : const Color(0xFFEFEFEF),
      style: TextStyle(
        fontSize: 16,
        color: isPositive ? Colors.white : const Color(0xFF333333),
      ),
      onTap: onTap,
    );
  }
}
