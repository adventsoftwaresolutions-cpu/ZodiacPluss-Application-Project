import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contact_model.dart';
import 'contact_repository.dart';

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return ContactRepository();
});

final contactActionsProvider =
    FutureProvider<List<ContactAction>>((ref) async {
  return ref.read(contactRepositoryProvider).getActions();
});

final contactInfoProvider =
    FutureProvider<List<ContactInfo>>((ref) async {
  return ref.read(contactRepositoryProvider).getContactInfo();
});

final workingHoursProvider =
    FutureProvider<String>((ref) async {
  return ref.read(contactRepositoryProvider).getWorkingHours();
});