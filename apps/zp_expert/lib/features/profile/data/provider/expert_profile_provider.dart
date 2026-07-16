import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/expert_profile_model.dart';
import '../repository/expert_profile_repository.dart';

final expertProfilePageRepositoryProvider =
    Provider<ExpertProfilePageRepository>(
  (Ref ref) => StubExpertProfilePageRepository(),
);

final expertProfilePageProvider = FutureProvider<ExpertProfileModel>((Ref ref) {
  return ref.read(expertProfilePageRepositoryProvider).fetchProfile();
});

final profileChangeRequestProvider =
    AsyncNotifierProvider<ProfileChangeRequestNotifier, ProfileChangeRequest?>(
        ProfileChangeRequestNotifier.new);

class ProfileChangeRequestNotifier
    extends AsyncNotifier<ProfileChangeRequest?> {
  @override
  Future<ProfileChangeRequest?> build() async => null;

  Future<ProfileChangeRequest> submit({
    required String section,
    required Map<String, dynamic> payload,
  }) async {
    state = const AsyncLoading<ProfileChangeRequest?>();
    final ProfileChangeRequest request = await ref
        .read(expertProfilePageRepositoryProvider)
        .submitChangeRequest(section: section, payload: payload);
    state = AsyncData<ProfileChangeRequest?>(request);
    return request;
  }
}
