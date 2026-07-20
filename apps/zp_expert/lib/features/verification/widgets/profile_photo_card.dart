import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/utils/expert_avatar_image.dart';
import '../data/provider/verification_form_provider.dart';
import 'section_card.dart';

class ProfilePhotoCard extends ConsumerWidget {
  const ProfilePhotoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? source = ref.watch(
      verificationFormProvider.select(
        (VerificationFormState state) => state.form.profilePhotoSource,
      ),
    );
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Start with a friendly photo',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          const Text(
            'A clear, professional photo makes your profile feel welcoming.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xff6B7280),
            ),
          ),
          const SizedBox(height: 28),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xffF3F7FA),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xffE4E8EE),
                    ),
                  ),
                  child: ClipOval(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 240),
                      child: source == null
                          ? const Icon(
                              Icons.person,
                              key: ValueKey<bool>(false),
                              size: 58,
                              color: Color(0xFFB8C0CC),
                            )
                          : Image(
                              key: ValueKey<String>(source),
                              image: expertAvatarImage(source),
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.broken_image_outlined,
                                size: 48,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => _selectPhoto(context, ref),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xff17B3A7),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: Text(
                source == null ? 'JPG, PNG up to 5MB' : _fileName(source),
                key: ValueKey<String?>(source),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ),
          if (source != null)
            Center(
              child: TextButton(
                onPressed: ref
                    .read(verificationFormProvider.notifier)
                    .removeProfilePhoto,
                child: const Text('Remove photo'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _selectPhoto(BuildContext context, WidgetRef ref) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(title: Text('Select profile photo')),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !context.mounted) return;
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 88,
      );
      if (image != null) {
        ref.read(verificationFormProvider.notifier).setProfilePhoto(image.path);
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to select this photo.')),
      );
    }
  }

  String _fileName(String path) => path.split(RegExp(r'[/\\]')).last;
}
