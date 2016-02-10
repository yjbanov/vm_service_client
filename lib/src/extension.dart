// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'scope.dart';

VMServiceExtension newVMServiceExtension(String method) {
  assert(method != null);
  return new VMServiceExtension._(method);
}

/// Represents a VM service extension registered in an isolate.
///
/// Extensions are registered using `registerExtension` from the
/// `dart:developer` package.
class VMServiceExtension {
  /// RPC method name under which the extension is registered.
  final String method;

  VMServiceExtension._(this.method);
}
