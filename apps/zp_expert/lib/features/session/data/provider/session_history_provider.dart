import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/session_history_model.dart';
import '../repository/session_history_repository.dart';

final sessionHistoryRepositoryProvider = Provider<SessionHistoryRepository>(
  (ref) => StubSessionHistoryRepository(),
);

final sessionHistoryProvider = FutureProvider<List<SessionHistoryModel>>(
  (ref) => ref.read(sessionHistoryRepositoryProvider).getSessionHistory(),
);
