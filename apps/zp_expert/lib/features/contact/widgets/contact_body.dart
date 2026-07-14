import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/contact_provider.dart';
import 'contact_action_grid.dart';
import 'contact_header.dart';
import 'contact_info_section.dart';
import 'contact_support_banner.dart';
import 'contact_working_hours.dart';
import 'feedback_banner.dart';

class ContactBody extends ConsumerWidget {
  const ContactBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(contactActionsProvider);
    final contactInfo = ref.watch(contactInfoProvider);
    final workingHours = ref.watch(workingHoursProvider);

    return actions.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: Text(e.toString()),
      ),
      data: (actionList) {
        return contactInfo.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (e, _) => Center(
            child: Text(e.toString()),
          ),
          data: (infoList) {
            return workingHours.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Center(
                child: Text(e.toString()),
              ),
              data: (hours) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ContactHeader(),

                      const SizedBox(height: 28),

                      ContactActionGrid(
                        actions: actionList,
                      ),

                      const SizedBox(height: 28),

                      const ContactSupportBanner(),

                      const SizedBox(height: 20),

                      ContactWorkingHours(
                        workingHours: hours,
                      ),

                      const SizedBox(height: 28),

                      ContactInfoSection(
                        contactInfo: infoList,
                      ),

                      const SizedBox(height: 24),

                      const FeedbackBanner(),

                      const SizedBox(height: 30),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}