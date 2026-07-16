import 'package:flutter/material.dart';

import 'profile_section_card.dart';

class AboutMeCard extends StatefulWidget {
  const AboutMeCard({required this.about, required this.onSubmit, super.key});

  final String about;
  final Future<void> Function(String value) onSubmit;

  @override
  State<AboutMeCard> createState() => _AboutMeCardState();
}

class _AboutMeCardState extends State<AboutMeCard> {
  late final TextEditingController _controller;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.about);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleAction() async {
    if (!_isEditing) {
      setState(() => _isEditing = true);
      return;
    }
    if (_controller.text.trim().isEmpty) return;
    setState(() => _isSaving = true);
    await widget.onSubmit(_controller.text.trim());
    if (!mounted) return;
    _controller.text = widget.about;
    setState(() {
      _isSaving = false;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) => ProfileSectionCard(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProfileSectionTitle(
                icon: Icons.person_outline_rounded,
                title: 'About Me',
                action: ProfileEditButton(
                  isEditing: _isEditing,
                  onPressed: _isSaving ? null : _handleAction,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 33),
                child: _isEditing
                    ? TextField(
                        controller: _controller,
                        autofocus: true,
                        minLines: 3,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.35,
                            ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Tell clients about yourself…',
                        ),
                      )
                    : Text(
                        widget.about,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.35,
                            ),
                      ),
              ),
            ],
          ),
        ),
      );
}
