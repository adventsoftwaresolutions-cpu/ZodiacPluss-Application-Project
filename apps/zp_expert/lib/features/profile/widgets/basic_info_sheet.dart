import 'package:flutter/material.dart';

import '../../../shared/data/expert_profile.dart';

Future<Map<String, dynamic>?> showBasicInfoSheet(
  BuildContext context, {
  required ExpertProfile profile,
}) {
  String name = profile.name;
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) => Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Edit basic information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  )),
          const SizedBox(height: 6),
          const Text(
            'Changes are sent to the admin for approval.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 18),
          TextFormField(
            initialValue: profile.name,
            onChanged: (String value) => name = value,
            decoration: const InputDecoration(
              labelText: 'Display name',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(<String, dynamic>{
                'name': name.trim(),
              }),
              child: const Text('Raise change request'),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<String?> showPhotoSourceSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    useRootNavigator: true,
    builder: (BuildContext context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Request a profile photo change',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 6),
            const Text(
              'Choose a source. The new photo will be reviewed before it appears publicly.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 14),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.of(context).pop('camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Photo library'),
              onTap: () => Navigator.of(context).pop('gallery'),
            ),
          ],
        ),
      ),
    ),
  );
}
