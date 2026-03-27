import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareIntakeService {
  ShareIntakeService._();
  static final instance = ShareIntakeService._();

  StreamSubscription? _sub;

  void listen(void Function(String url) onUrl) {
    _sub?.cancel();
    _sub = ReceiveSharingIntent.instance.getMediaStream().listen((items) {
      for (final item in items) {
        final text = item.path;
        if (text.startsWith('http://') || text.startsWith('https://')) {
          onUrl(text);
        }
      }
    });

    ReceiveSharingIntent.instance.getInitialMedia().then((items) {
      for (final item in items) {
        final text = item.path;
        if (text.startsWith('http://') || text.startsWith('https://')) {
          onUrl(text);
        }
      }
    });
  }

  void dispose() {
    _sub?.cancel();
  }
}
