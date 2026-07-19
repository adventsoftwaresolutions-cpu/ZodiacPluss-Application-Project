import 'package:flutter_riverpod/flutter_riverpod.dart';

const String defaultExpertDisplayName = 'Aditya';

/// Initial identity used only when creating a new demo API session.
/// Once created, the server session is the source of truth for the name.
final Provider<String> initialExpertDisplayNameProvider = Provider<String>(
  (Ref ref) => defaultExpertDisplayName,
);
