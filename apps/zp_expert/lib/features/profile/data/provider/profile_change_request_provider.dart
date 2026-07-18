import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile_change_request.dart';
import '../repository/profile_change_request_repository.dart';

final Provider<ProfileChangeRequestRepository>
    profileChangeRequestRepositoryProvider =
    Provider<ProfileChangeRequestRepository>(
  (Ref ref) => StubProfileChangeRequestRepository(),
);

final AsyncNotifierProvider<ProfileChangeRequestNotifier, ProfileChangeRequest?>
    profileChangeRequestProvider =
    AsyncNotifierProvider<ProfileChangeRequestNotifier, ProfileChangeRequest?>(
  ProfileChangeRequestNotifier.new,
);

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
        .read(profileChangeRequestRepositoryProvider)
        .submitChangeRequest(section: section, payload: payload);
    state = AsyncData<ProfileChangeRequest?>(request);
    return request;
  }
}
