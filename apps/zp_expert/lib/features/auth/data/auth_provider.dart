import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_model.dart';
import 'auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authProvider =
    NotifierProvider<AuthNotifier, AuthModel>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthModel> {
  @override
  AuthModel build() {
    return const AuthModel();
  }

  Future<void> sendOtp(String phone) async {
    state = state.copyWith(
      isLoading: true,
    );

    await ref.read(authRepositoryProvider).sendOtp(phone);

    state = state.copyWith(
      phone: phone,
      isLoading: false,
      step: AuthStep.otp,
    );
  }

  Future<void> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true);

    final success =
        await ref.read(authRepositoryProvider).verifyOtp(
              phone: state.phone,
              otp: otp,
            );

    state = state.copyWith(
      otp: otp,
      isLoading: false,
    );

    if (success) {
      // Navigate later
    }
  }

  void backToPhone() {
    state = state.copyWith(
      step: AuthStep.phone,
    );
  }
}