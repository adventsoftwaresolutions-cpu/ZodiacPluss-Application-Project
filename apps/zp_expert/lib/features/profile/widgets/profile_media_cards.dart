import 'package:flutter/material.dart';

import '../../../shared/constants/app_assets.dart';
import 'profile_section_card.dart';

class IntroCard extends StatelessWidget {
  const IntroCard({
    required this.hasIntro,
    required this.onUpload,
    super.key,
  });

  final bool hasIntro;
  final Future<void> Function(String source) onUpload;

  Future<void> _chooseUpload(BuildContext context) async {
    final String? source = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Upload a new intro',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your replacement intro will be sent to the admin for review.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.videocam_outlined),
                title: const Text('Record a video'),
                onTap: () => Navigator.of(context).pop('camera'),
              ),
              ListTile(
                leading: const Icon(Icons.video_library_outlined),
                title: const Text('Choose from video library'),
                onTap: () => Navigator.of(context).pop('video_library'),
              ),
            ],
          ),
        ),
      ),
    );
    if (source != null) await onUpload(source);
  }

  @override
  Widget build(BuildContext context) => ProfileSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const ProfileSectionTitle(
              icon: Icons.videocam_outlined,
              title: 'Intro',
            ),
            const Padding(
              padding: EdgeInsets.only(left: 33),
              child: Text(
                'Upload a short introduction for first-time viewers',
                style: TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: AspectRatio(
                    aspectRatio: 1.55,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.asset(
                            AppAssets.clientAvatarOne,
                            fit: BoxFit.cover,
                          ),
                          Container(color: Colors.black.withValues(alpha: .08)),
                          Center(
                            child: IconButton.filled(
                              onPressed: () {},
                              icon: const Icon(Icons.play_arrow_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    onPressed: () => _chooseUpload(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(78),
                      side: const BorderSide(color: Colors.black26),
                    ),
                    icon: const Icon(Icons.upload_rounded),
                    label: Text(hasIntro ? 'Replace' : 'Upload'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class ProfileMediaCard extends StatefulWidget {
  const ProfileMediaCard({
    required this.mediaCount,
    required this.onUpload,
    required this.onRemove,
    super.key,
  });

  final int mediaCount;
  final Future<void> Function(String mediaType) onUpload;
  final Future<void> Function(String certificateName) onRemove;

  @override
  State<ProfileMediaCard> createState() => _ProfileMediaCardState();
}

class _ProfileMediaCardState extends State<ProfileMediaCard> {
  static const List<_Certificate> _certificates = <_Certificate>[
    _Certificate(name: 'Certificate 1', assetPath: AppAssets.certificate1),
    _Certificate(name: 'Certificate 2', assetPath: AppAssets.certificate2),
    _Certificate(name: 'Certificate 3', assetPath: AppAssets.certificate3),
  ];

  bool _isManaging = false;

  Future<void> _chooseMediaUpload(BuildContext context) async {
    final String? mediaType = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Upload profile media',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 6),
              const Text(
                'New media is submitted as a change request and appears after admin approval.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.workspace_premium_outlined),
                title: const Text('Certificate or qualification'),
                onTap: () => Navigator.of(context).pop('certificate'),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Photo or document'),
                onTap: () => Navigator.of(context).pop('image_or_document'),
              ),
            ],
          ),
        ),
      ),
    );
    if (mediaType != null) await widget.onUpload(mediaType);
  }

  @override
  Widget build(BuildContext context) => ProfileSectionCard(
        child: Column(
          children: <Widget>[
            ProfileSectionTitle(
              icon: Icons.photo_library_outlined,
              title: 'Profile Media',
              action: TextButton(
                onPressed: () => setState(() => _isManaging = !_isManaging),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Text(
                    _isManaging ? 'Done' : 'Manage All (${widget.mediaCount})',
                    key: ValueKey<bool>(_isManaging),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 128,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _certificates.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 10),
                itemBuilder: (BuildContext context, int index) {
                  final _Certificate certificate = _certificates[index];
                  return _CertificatePreview(
                    certificate: certificate,
                    isManaging: _isManaging,
                    onRemove: () => widget.onRemove(certificate.name),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: () => _chooseMediaUpload(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Upload Media'),
              ),
            ),
          ],
        ),
      );
}

class _CertificatePreview extends StatelessWidget {
  const _CertificatePreview({
    required this.certificate,
    required this.isManaging,
    required this.onRemove,
  });

  final _Certificate certificate;
  final bool isManaging;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 128,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          Image.asset(certificate.assetPath, fit: BoxFit.cover),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutBack,
                    top: isManaging ? -9 : 5,
                    left: isManaging ? -9 : 5,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 180),
                      scale: isManaging ? 1 : 0,
                      child: IconButton.filled(
                        onPressed: onRemove,
                        constraints: const BoxConstraints.tightFor(
                          width: 28,
                          height: 28,
                        ),
                        padding: EdgeInsets.zero,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                        ),
                        icon: const Icon(Icons.close_rounded, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              certificate.name,
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
}

class _Certificate {
  const _Certificate({required this.name, required this.assetPath});

  final String name;
  final String assetPath;
}
