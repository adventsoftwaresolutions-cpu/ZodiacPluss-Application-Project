import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/faq_provider.dart';
import 'faq_item.dart';

class FaqList extends ConsumerWidget {
  const FaqList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqs = ref.watch(faqProvider);

    return faqs.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Center(
        child: Text(error.toString()),
      ),
      data: (items) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final faq = items[index];

            return FaqItem(
              faq: faq,
              onTap: () {
                ref.read(faqProvider.notifier).toggle(faq.id);
              },
            );
          },
        );
      },
    );
  }
}