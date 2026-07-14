import 'package:flutter/foundation.dart';

/// Artificial delay for stub repositories so loading states (shimmer)
/// are visible during development. Automatically becomes a no-op in
/// release builds — never ships as user-facing lag.
Future<void> simulateNetworkLatency({
  Duration duration = const Duration(milliseconds: 1100),
}) {
  if (kReleaseMode) {
    return Future<void>.value();
  }
  return Future<void>.delayed(duration);
}