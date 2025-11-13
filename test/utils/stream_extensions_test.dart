import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:remote_rift_mobile/utils/stream_extensions.dart';

void main() {
  group('pipeToController', () {
    test('forwards events downstream', () {
      for (var broadcast in [false, true]) {
        final source = StreamController<int>();
        final controller = source.stream.pipeToController(broadcast: broadcast);

        source.add(1);
        source.add(2);
        source.add(3);

        expect(controller.stream, emitsInOrder([1, 2, 3]));
      }
    });

    test('unsubscribes source stream when downstream subscription is canceled', () async {
      for (var broadcast in [false, true]) {
        final source = StreamController<int>();

        final controller = source.stream.pipeToController(broadcast: broadcast);
        final subscription = controller.stream.listen((_) {});
        expect(source.hasListener, isTrue);

        await subscription.cancel();
        expect(source.hasListener, isFalse);
      }
    });

    test('subscribes source stream when downstream listener is added', () {
      for (var broadcast in [false, true]) {
        final source = StreamController<int>();

        final controller = source.stream.pipeToController(broadcast: broadcast);
        expect(source.hasListener, isFalse);

        final _ = controller.stream.listen((_) {});
        expect(source.hasListener, isTrue);
      }
    });

    test('unsubscribes source stream when downstream controller is closed', () async {
      for (var broadcast in [false, true]) {
        final source = StreamController<int>();

        final controller = source.stream.pipeToController(broadcast: broadcast);
        final _ = controller.stream.listen((_) {});
        expect(source.hasListener, isTrue);

        await controller.close();
        expect(source.hasListener, isFalse);
      }
    });
  });
}
