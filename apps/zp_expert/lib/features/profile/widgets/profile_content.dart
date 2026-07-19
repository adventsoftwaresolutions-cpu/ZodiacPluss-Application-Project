import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/app_routes.dart';
import '../../../shared/data/expert_profile.dart';
import '../../home/data/availability_controller.dart';
import '../../home/data/availability_status.dart';
import '../data/provider/profile_change_request_provider.dart';
import '../data/provider/profile_provider.dart';
import 'about_me_card.dart';
import 'achievements_card.dart';
import 'basic_info_sheet.dart';
import 'change_request_dialog.dart';
import 'consultation_settings_card.dart';
import 'education_experience_card.dart';
import 'expert_profile_header.dart';
import 'profile_entrance.dart';
import 'profile_loading_skeleton.dart';
import 'profile_media_cards.dart';
import 'specializations_card.dart';

class ProfileContent extends ConsumerWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ExpertProfile> profileAsync =
        ref.watch(profileDetailsProvider);
    final AvailabilityStatus availability =
        ref.watch(availabilityControllerProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, .04),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: profileAsync.when(
        loading: () => const ProfileLoadingSkeleton(
          key: ValueKey<String>('profile-loading'),
        ),
        error: (Object error, StackTrace stackTrace) => _ProfileError(
          key: const ValueKey<String>('profile-error'),
          onRetry: () => ref.invalidate(profileDetailsProvider),
        ),
        data: (ExpertProfile profile) => _ProfileList(
          key: const ValueKey<String>('profile-data'),
          profile: profile,
          availability: availability,
        ),
      ),
    );
  }
}

class _ProfileList extends ConsumerWidget {
  const _ProfileList({
    required this.profile,
    required this.availability,
    super.key,
  });

  final ExpertProfile profile;
  final AvailabilityStatus availability;

  Future<void> _submitRequest(
    BuildContext context,
    WidgetRef ref, {
    required String section,
    required Map<String, dynamic> payload,
  }) async {
    try {
      await ref
          .read(profileChangeRequestProvider.notifier)
          .submit(section: section, payload: payload);
      if (!context.mounted) return;
      await showChangeRequestDialog(context, section: section);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Unable to raise the request. Try again.')),
      );
    }
  }

  Future<void> _editBasicInfo(BuildContext context, WidgetRef ref) async {
    final Map<String, dynamic>? payload =
        await showBasicInfoSheet(context, profile: profile);
    if (payload == null || !context.mounted) return;
    await _submitRequest(
      context,
      ref,
      section: 'basic information',
      payload: payload,
    );
  }

  Future<void> _requestPhotoChange(BuildContext context, WidgetRef ref) async {
    final String? source = await showPhotoSourceSheet(context);
    if (source == null || !context.mounted) return;
    await _submitRequest(
      context,
      ref,
      section: 'profile photo',
      payload: <String, dynamic>{'source': source},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: <Widget>[
          ProfileEntrance(
            index: 0,
            child: ExpertProfileHeader(
              profile: profile,
              availability: availability,
              onEditBasicInfo: () => _editBasicInfo(context, ref),
              onPhotoTap: () => _requestPhotoChange(context, ref),
            ),
          ),
          const SizedBox(height: 24),
          ProfileEntrance(
            index: 1,
            child: AboutMeCard(
              about: profile.about,
              onSubmit: (String value) => _submitRequest(
                context,
                ref,
                section: 'About Me',
                payload: <String, dynamic>{'about': value},
              ),
            ),
          ),
          const SizedBox(height: 16),
          ProfileEntrance(
            index: 2,
            child: EducationExperienceCard(
              education: profile.education,
              yearsExperience: profile.yearsExperience,
              onSubmit: (
                int years,
                List<EducationEntry> education,
              ) =>
                  _submitRequest(
                context,
                ref,
                section: 'education and experience',
                payload: <String, dynamic>{
                  'yearsExperience': years,
                  'education': education
                      .map((EducationEntry item) => item.toJson())
                      .toList(),
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          ProfileEntrance(
            index: 3,
            child: SpecializationsCard(
              selected: profile.specializations,
              onSubmit: (List<String> values) => _submitRequest(
                context,
                ref,
                section: 'specializations',
                payload: <String, dynamic>{'specializations': values},
              ),
            ),
          ),
          const SizedBox(height: 16),
          ProfileEntrance(
            index: 4,
            child: IntroCard(
              hasIntro: profile.introUploaded,
              onUpload: (String source) => _submitRequest(
                context,
                ref,
                section: 'intro video',
                payload: <String, dynamic>{
                  'action': 'replace',
                  'source': source,
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          ProfileEntrance(
            index: 5,
            child: ProfileMediaCard(
              mediaCount: profile.mediaCount,
              onUpload: (String mediaType) => _submitRequest(
                context,
                ref,
                section: 'profile media',
                payload: <String, dynamic>{
                  'action': 'upload',
                  'mediaType': mediaType,
                },
              ),
              onRemove: (String certificateName) => _submitRequest(
                context,
                ref,
                section: 'profile media',
                payload: <String, dynamic>{
                  'action': 'remove',
                  'certificate': certificateName,
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          const ProfileEntrance(index: 6, child: AchievementsCard()),
          const SizedBox(height: 16),
          ProfileEntrance(
            index: 7,
            child: ConsultationSettingsCard(
              rates: profile.consultationRates,
              onEdit: () => context.push(ExpertRoutes.managePricing),
            ),
          ),
        ],
      );
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.cloud_off_outlined, color: Colors.white, size: 44),
            const SizedBox(height: 10),
            const Text(
              'Unable to load your profile',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
}
