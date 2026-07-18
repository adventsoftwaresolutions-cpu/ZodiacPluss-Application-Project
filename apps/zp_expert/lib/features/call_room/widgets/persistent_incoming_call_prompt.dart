import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/app_routes.dart';
import '../data/models/call_room_model.dart';
import '../data/provider/call_room_provider.dart';

class PersistentIncomingCallPrompt extends ConsumerWidget {
  const PersistentIncomingCallPrompt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<CallRoomModel>> rooms =
        ref.watch(incomingCallRoomsProvider);
    final List<CallRoomModel> ready =
        rooms.valueOrNull ?? const <CallRoomModel>[];
    if (ready.isEmpty) return const SizedBox.shrink();
    final CallRoomModel room = ready.first;
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Material(
        key: const ValueKey<String>('persistent-call-room-prompt'),
        color: Theme.of(context).colorScheme.surface,
        elevation: 10,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
          child: Row(
            children: <Widget>[
              _PulsingCallIcon(type: room.type),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      room.isLive
                          ? '${room.clientName} call is active'
                          : '${room.clientName} is ready',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '${room.type.label}'
                      '${room.paidMinutes > 0 ? ' · ${room.paidMinutes} min funded' : ''}'
                      '${ready.length > 1 ? ' · +${ready.length - 1} waiting' : ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (!room.isLive)
                IconButton(
                  tooltip: 'Decline consultation',
                  onPressed: () async {
                    try {
                      await ref
                          .read(incomingCallRoomsProvider.notifier)
                          .declineRoom(room.id);
                    } catch (_) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Unable to decline this consultation.'),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.call_end_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              FilledButton(
                key: const ValueKey<String>('persistent-join-room-button'),
                onPressed: () => context.push(
                  ExpertRoutes.callRoomFor(room.id),
                ),
                child: Text(room.isLive ? 'Rejoin room' : 'Join room'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulsingCallIcon extends StatefulWidget {
  const _PulsingCallIcon({required this.type});

  final CallRoomType type;

  @override
  State<_PulsingCallIcon> createState() => _PulsingCallIconState();
}

class _PulsingCallIconState extends State<_PulsingCallIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: .92,
      upperBound: 1.08,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: _controller,
        child: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: .14),
          foregroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            widget.type == CallRoomType.video
                ? Icons.videocam_rounded
                : Icons.call_rounded,
          ),
        ),
      );
}
