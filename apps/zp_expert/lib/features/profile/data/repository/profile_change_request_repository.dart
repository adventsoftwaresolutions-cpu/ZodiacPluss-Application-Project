import '../models/profile_change_request.dart';

abstract class ProfileChangeRequestRepository {
  Future<ProfileChangeRequest> submitChangeRequest({
    required String section,
    required Map<String, dynamic> payload,
  });
}

class StubProfileChangeRequestRepository
    implements ProfileChangeRequestRepository {
  static final List<ProfileChangeRequest> _requests = <ProfileChangeRequest>[];

  @override
  Future<ProfileChangeRequest> submitChangeRequest({
    required String section,
    required Map<String, dynamic> payload,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final ProfileChangeRequest request = ProfileChangeRequest(
      id: 'request-${_requests.length + 1}',
      section: section,
      payload: payload,
      submittedAt: DateTime.now(),
    );
    _requests.add(request);
    return request;
  }
}
