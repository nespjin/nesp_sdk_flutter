import 'package:flutter/foundation.dart';

@immutable
abstract class UiState {
  const UiState();
}

enum UiStatus {
  normal,
  loading,
  success,
  error;
}
