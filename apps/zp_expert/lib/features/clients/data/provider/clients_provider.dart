import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/client_lists.dart';
import '../repository/client_repository.dart';

final clientRepositoryProvider = Provider<ClientRepository>(
  (ref) => LocalClientRepository(),
);

final clientsProvider = FutureProvider<ClientLists>((ref) async {
  return ref.watch(clientRepositoryProvider).fetchClients();
});
