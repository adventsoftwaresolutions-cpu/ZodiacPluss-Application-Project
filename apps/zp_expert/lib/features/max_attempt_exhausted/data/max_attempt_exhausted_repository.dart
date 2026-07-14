import 'max_attempt_exhausted_model.dart';

class MaxAttemptExhaustedRepository {
  Future<MaxAttemptExhaustedModel> getData() async {
    return const MaxAttemptExhaustedModel(
      title: 'Maximum Attempts Reached',
      description:
          'You have used all 3 verification attempts. Please contact our support team before trying again.',
    );
  }
}