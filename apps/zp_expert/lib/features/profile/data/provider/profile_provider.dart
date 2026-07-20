import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/expert_profile.dart';
import '../../../../shared/data/expert_profile_repository.dart';

final FutureProvider<ExpertProfile> profileDetailsProvider =
    FutureProvider<ExpertProfile>(
  (Ref ref) => ref.watch(expertProfileProvider.future),
);
