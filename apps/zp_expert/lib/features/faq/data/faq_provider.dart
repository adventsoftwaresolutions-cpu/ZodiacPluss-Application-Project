import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'faq_model.dart';
import 'faq_repository.dart';

final faqRepositoryProvider = Provider<FaqRepository>(
  (ref) => FaqRepository(),
);

final faqProvider =
    AsyncNotifierProvider<FaqNotifier, List<FaqModel>>(
  FaqNotifier.new,
);

class FaqNotifier extends AsyncNotifier<List<FaqModel>> {
  @override
  Future<List<FaqModel>> build() async {
    return ref.read(faqRepositoryProvider).getFaqs();
  }

  void toggle(String id) {
    state.whenData((faqs) {
      state = AsyncData(
        faqs.map((faq) {
          if (faq.id == id) {
            return faq.copyWith(
              isExpanded: !faq.isExpanded,
            );
          }
          return faq;
        }).toList(),
      );
    });
  }
}