import 'dart:async';
import 'dart:io';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareIntakeService {
  ShareIntakeService._();
  static final instance = ShareIntakeService._();

  StreamSubscription? _sub;

  bool get _isSupportedPlatform => Platform.isAndroid || Platform.isIOS;

  void listen(void Function(String url) onUrl) {
    if (!_isSupportedPlatform) return;

    _sub?.cancel();
    _sub = ReceiveSharingIntent.instance.getMediaStream().listen(
      (items) {
        for (final item in items) {
          final text = item.path;
          if (text.startsWith('http://') || text.startsWith('https://')) {
            onUrl(text);
          }
        }
      },
      onError: (_) {},
    );

    ReceiveSharingIntent.instance.getInitialMedia().then((items) {
      for (final item in items) {
        final text = item.path;
        if (text.startsWith('http://') || text.startsWith('https://')) {
          onUrl(text);
        }
      }
    }).catchError((_) {});
  }

  void dispose() {
    _sub?.cancel();
  }
}
