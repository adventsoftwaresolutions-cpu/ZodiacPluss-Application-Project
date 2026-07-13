import 'faq_model.dart';

class FaqRepository {
  Future<List<FaqModel>> getFaqs() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 300),
    );

    return const <FaqModel>[
      FaqModel(
        id: '1',
        question: 'What is Zodiac Plus?',
        answer:
            'Zodiac Plus is an online astrology platform where you can connect with verified astrologers through chat, audio, and video consultations.',
      ),
      FaqModel(
        id: '2',
        question: 'How do I book a consultation?',
        answer:
            'Select an astrologer, choose your preferred consultation type, and proceed with payment to begin your session.',
      ),
      FaqModel(
        id: '3',
        question: 'Can I get a refund?',
        answer:
            'Refund eligibility depends on the cancellation and refund policy. Please contact support for assistance.',
      ),
      FaqModel(
        id: '4',
        question: 'How do I recharge my wallet?',
        answer:
            'Navigate to the Wallet section, choose an amount, and complete payment using your preferred payment method.',
      ),
      FaqModel(
        id: '5',
        question: 'Is my personal information secure?',
        answer:
            'Yes. We prioritize user privacy and secure all sensitive information using industry-standard practices.',
      ),
    ];
  }
}