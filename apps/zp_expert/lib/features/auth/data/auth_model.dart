enum AuthStep {
  phone,
  otp,
}

class AuthModel {
  const AuthModel({
    this.phone = '',
    this.otp = '',
    this.step = AuthStep.phone,
    this.isLoading = false,
  });

  final String phone;
  final String otp;
  final AuthStep step;
  final bool isLoading;

  AuthModel copyWith({
    String? phone,
    String? otp,
    AuthStep? step,
    bool? isLoading,
  }) {
    return AuthModel(
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}