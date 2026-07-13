import 'dart:async';

class AuthRepository {
  Future<void> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 1200));
  }

  Future<bool> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return otp == '1234';
  }
}