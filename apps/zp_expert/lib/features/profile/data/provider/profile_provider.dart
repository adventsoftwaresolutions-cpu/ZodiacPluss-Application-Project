import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/expert_profile.dart';
import '../../../../shared/data/expert_profile_repository.dart';
import '../../../../shared/data/expert_session.dart';
import '../../../../shared/data/expert_session_repository.dart';

final FutureProvider<ExpertProfile> profileDetailsProvider =
    FutureProvider<ExpertProfile>((Ref ref) async {
  final ExpertProfile profile =
      await ref.read(expertProfileRepositoryProvider).fetchProfile();
  final ExpertSession session = await ref.watch(expertSessionProvider.future);
  return profile.copyWith(name: session.displayName);
});
