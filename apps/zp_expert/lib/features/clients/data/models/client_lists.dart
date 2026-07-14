import 'client_model.dart';

class ClientLists {
  const ClientLists({
    required this.previous,
    required this.future,
  });

  final List<ClientModel> previous;
  final List<ClientModel> future;
}
