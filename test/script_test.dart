// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:vm_service_client/vm_service_client.dart';

import 'utils.dart';

VMServiceClient client;
VMRunnableIsolate isolate;
VMScriptRef scriptRef;

void main() {
  setUp(() async {
    client = await runAndConnect(topLevel: r"""
      final foo = 1; // line 3
    """, flags: ["--pause-isolates-on-start"]);
    isolate = await (await client.getVM()).isolates.first.load();
    scriptRef = (await isolate.rootLibrary.load()).scripts.single;
  });

  tearDown(() {
    if (client != null) client.close();
  });

  test("includes the script's metadata", () async {
    expect(scriptRef.uri.scheme, equals("data"));

    var script = await scriptRef.load();
    expect(script.library.uri, equals(script.uri));
    expect(script.source, contains("final foo = 1;"));
    expect(script.sourceFile.length, equals(script.source.length));
  });

  test("sourceLocation looks up a source location", () async {
    var script = await scriptRef.load();
    var library = await isolate.rootLibrary.load();
    var field = await library.fields["foo"].load();
    var location = script.sourceLocation(field.location.token);

    expect(location.file, same(script.sourceFile));
    expect(location.sourceUrl, equals(script.uri));
    expect(location.line, equals(3));
    expect(location.column, equals(13));
  });
}
