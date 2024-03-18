import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

extension ImageProviderExtensions on ImageProvider {
  Future<ui.Image> toUiImage(
      {ImageConfiguration config = ImageConfiguration.empty}) async {
    Completer<ui.Image> completer = Completer<ui.Image>();
    late ImageStreamListener listener;
    ImageStream stream = resolve(config);
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(listener);
    });
    stream.addListener(listener);
    return completer.future;
  }
}
