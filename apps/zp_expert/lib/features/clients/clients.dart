import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_routes.dart';
import '../../shared/widgets/gradient_page.dart';
import '../../shared/widgets/top_scroll_fade.dart';
import 'data/models/client_lists.dart';
import 'data/models/client_model.dart';
import 'data/provider/clients_provider.dart';
import 'widgets/client_search_field.dart';
import 'widgets/client_section.dart';
import 'widgets/clients_header.dart';

class ClientsPage extends ConsumerStatefulWidget {
  const ClientsPage({super.key});

  @override
  ConsumerState<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends ConsumerState<ClientsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _isPreviousExpanded = false;
  bool _isFutureExpanded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsProvider);

    return GradientPage(
      child: SafeArea(
        top: true,
        bottom: false,
        child: TopScrollFade(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    ClientsHeader(
                      onBackTap: () => Navigator.of(context).maybePop(),
                      onNotificationTap: () {},
                      onChatTap: () => context.push(ExpertRoutes.chats),
                    ),
                    const SizedBox(height: 28),
                    ClientSearchField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                    const SizedBox(height: 16),
                    clientsAsync.when(
                      data: _buildClientContent,
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, stackTrace) => _LoadError(
                        onRetry: () => ref.invalidate(clientsProvider),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClientContent(ClientLists clients) {
    final previous = _filter(clients.previous);
    final future = _filter(clients.future);

    return Column(
      children: <Widget>[
        ClientSection(
          title: 'Previous Clients',
          subtitle: 'Patients you have already consulted',
          clients: previous,
          isExpanded: _isPreviousExpanded,
          onViewAllTap: () => setState(
            () => _isPreviousExpanded = !_isPreviousExpanded,
          ),
          onClientTap: _showClientSelection,
        ),
        const SizedBox(height: 24),
        ClientSection(
          title: 'Future Clients',
          subtitle: 'Patients who have upcoming sessions',
          clients: future,
          isExpanded: _isFutureExpanded,
          onViewAllTap: () => setState(
            () => _isFutureExpanded = !_isFutureExpanded,
          ),
          onClientTap: _showClientSelection,
        ),
      ],
    );
  }

  List<ClientModel> _filter(List<ClientModel> clients) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return clients;
    return clients
        .where(
          (client) =>
              client.name.toLowerCase().contains(query) ||
              client.phoneNumber
                  .replaceAll(' ', '')
                  .contains(query.replaceAll(' ', '')),
        )
        .toList();
  }

  void _showClientSelection(ClientModel client) {
    context.push(ExpertRoutes.clientHistoryFor(client.id));
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: TextButton(
            onPressed: onRetry, child: const Text('Retry loading clients')),
      ),
    );
  }
}
