// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
