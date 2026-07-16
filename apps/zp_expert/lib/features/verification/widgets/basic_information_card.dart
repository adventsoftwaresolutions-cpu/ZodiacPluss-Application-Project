import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/models/verification_form_model.dart';
import '../data/provider/verification_form_provider.dart';
import 'section_card.dart';
import 'specialization_chip.dart';
import 'verification_dropdown.dart';
import 'verification_input.dart';

class BasicInformationCard extends ConsumerWidget {
  const BasicInformationCard({super.key});

  static const List<String> _languageOptions = <String>[
    'Hindi',
    'English',
    'Bengali',
    'Marathi',
    'Tamil',
    'Telugu',
    'Gujarati',
    'Kannada',
    'Malayalam',
    'Punjabi',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final VerificationFormModel form = ref.watch(
      verificationFormProvider.select(
        (VerificationFormState state) => state.form,
      ),
    );
    final VerificationFormController controller =
        ref.read(verificationFormProvider.notifier);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'A little about you',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'This helps clients feel comfortable before their first session.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6B7280),
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool split = constraints.maxWidth >= 620;
              final Widget name = VerificationInput(
                label: 'Full Name',
                hint: 'Enter full name',
                icon: Icons.person_outline_rounded,
                initialValue: form.fullName,
                onChanged: (String value) =>
                    controller.updateBasicInfo(fullName: value),
              );
              final Widget email = VerificationInput(
                label: 'Email Address',
                hint: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
                icon: Icons.mail_outline_rounded,
                initialValue: form.email,
                onChanged: (String value) =>
                    controller.updateBasicInfo(email: value),
              );
              if (!split) {
                return Column(
                  children: <Widget>[
                    name,
                    const SizedBox(height: 16),
                    email,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: name),
                  const SizedBox(width: 16),
                  Expanded(child: email),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget gender = VerificationDropdown<String>(
                label: 'Gender',
                hint: 'Select gender',
                icon: Icons.wc_outlined,
                value: form.gender,
                onChanged: (String? value) =>
                    controller.updateBasicInfo(gender: value),
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                  DropdownMenuItem(
                    value: 'Prefer not to say',
                    child: Text('Prefer not to say'),
                  ),
                ],
              );
              final Widget dateOfBirth = _DateOfBirthField(
                value: form.dateOfBirth,
                onChanged: (DateTime value) =>
                    controller.updateBasicInfo(dateOfBirth: value),
              );
              if (constraints.maxWidth < 620) {
                return Column(
                  children: <Widget>[
                    gender,
                    const SizedBox(height: 16),
                    dateOfBirth,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: gender),
                  const SizedBox(width: 16),
                  Expanded(child: dateOfBirth),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          VerificationInput(
            label: 'Address',
            hint: 'Enter complete address',
            icon: Icons.location_on_outlined,
            maxLines: 2,
            initialValue: form.address,
            onChanged: (String value) =>
                controller.updateBasicInfo(address: value),
          ),
          const SizedBox(height: 20),
          const Text(
            'Languages you can consult in',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 9),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _languageOptions.map((String language) {
                final bool selected = form.languages.contains(language);
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                  child: SpecializationChip(
                    title: language,
                    isSelected: selected,
                    onTap: () => controller.toggleLanguage(language),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateOfBirthField extends StatelessWidget {
  const _DateOfBirthField({required this.value, required this.onChanged});

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Date of Birth',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _pickDate(context),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.cake_outlined,
                      size: 18,
                      color: Color(0xFF17B3A7),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        value == null
                            ? 'Choose your date of birth'
                            : DateFormat('dd MMM yyyy').format(value!),
                        style: TextStyle(
                          fontSize: 12,
                          color: value == null
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF111827),
                        ),
                      ),
                    ),
                    const Icon(Icons.calendar_month_outlined, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  Future<void> _pickDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime(today.year - 25),
      firstDate: DateTime(today.year - 100),
      lastDate: DateTime(today.year - 18, today.month, today.day),
    );
    if (selected != null) onChanged(selected);
  }
}
