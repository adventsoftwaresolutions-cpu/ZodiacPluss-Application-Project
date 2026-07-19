import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/app_routes.dart';
import '../data/models/call_room_model.dart';
import '../data/provider/call_room_provider.dart';
import 'call_invitation_effects.dart';

class PersistentIncomingCallPrompt extends ConsumerStatefulWidget {
  const PersistentIncomingCallPrompt({super.key});

  @override
  ConsumerState<PersistentIncomingCallPrompt> createState() =>
      _PersistentIncomingCallPromptState();
}

class _PersistentIncomingCallPromptState
    extends ConsumerState<PersistentIncomingCallPrompt>
    with WidgetsBindingObserver {
  final FlutterRingtonePlayer _ringtonePlayer = FlutterRingtonePlayer();
  AppLifecycleState _lifecycleState = AppLifecycleState.resumed;
  String? _desiredRingingRoomId;
  String? _scheduledRingingRoomId;
  Timer? _iosRepeatTimer;
  int _soundRevision = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycleState = state;
    if (state == AppLifecycleState.resumed) {
      unawaited(_applyRingtone());
    } else {
      unawaited(_stopPlayback());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _soundRevision += 1;
    _desiredRingingRoomId = null;
    _iosRepeatTimer?.cancel();
    unawaited(_stopPlayerSafely());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<CallRoomModel>> rooms =
        ref.watch(incomingCallRoomsProvider);
    final List<CallRoomModel> ready =
        (rooms.valueOrNull ?? const <CallRoomModel>[])
            .where(_isRoomAvailable)
            .toList();
    final String? activeRoomId = ref.watch(activeCallRoomIdProvider);
    if (ready.isEmpty) {
      _scheduleRingtone(null);
      return const SizedBox.shrink();
    }
    final CallRoomModel room = ready.first;
    _scheduleRingtone(
      activeRoomId == null && !room.isLive ? room.id : null,
    );
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: RevolvingCallBorder(
        child: Material(
          key: const ValueKey<String>('persistent-call-room-prompt'),
          color: Theme.of(context).colorScheme.surface,
          elevation: 6,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
            child: Row(children: <Widget>[
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
                    _scheduleRingtone(null);
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
                      _scheduleRingtone(room.id);
                    }
                  },
                  icon: Icon(
                    Icons.call_end_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              AttentionJoinButton(
                key: const ValueKey<String>('persistent-join-room-button'),
                onPressed: () {
                  _scheduleRingtone(null);
                  context.push(ExpertRoutes.callRoomFor(room.id));
                },
                label: room.isLive ? 'Rejoin' : 'Join room',
              ),
            ]),
          ),
        ),
      ),
    );
  }

  bool _isRoomAvailable(CallRoomModel room) {
    final DateTime? expiresAt = room.requestExpiresAt;
    return room.isLive ||
        expiresAt == null ||
        expiresAt.isAfter(DateTime.now());
  }

  void _scheduleRingtone(String? roomId) {
    if (_scheduledRingingRoomId == roomId) return;
    _scheduledRingingRoomId = roomId;
    final String? scheduledRoomId = roomId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          _scheduledRingingRoomId != scheduledRoomId ||
          _desiredRingingRoomId == scheduledRoomId) {
        return;
      }
      _desiredRingingRoomId = scheduledRoomId;
      unawaited(_applyRingtone());
    });
  }

  Future<void> _applyRingtone() async {
    final int revision = ++_soundRevision;
    await _stopPlayerSafely();
    if (revision != _soundRevision ||
        _desiredRingingRoomId == null ||
        _lifecycleState != AppLifecycleState.resumed ||
        kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return;
    }
    await _playRingtoneSafely();
    if (revision != _soundRevision ||
        defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }
    _iosRepeatTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => unawaited(_playRingtoneSafely()),
    );
  }

  Future<void> _stopPlayback() async {
    _soundRevision += 1;
    await _stopPlayerSafely();
  }

  Future<void> _playRingtoneSafely() async {
    try {
      await _ringtonePlayer.playRingtone(
        volume: .72,
        looping: defaultTargetPlatform == TargetPlatform.android,
      );
    } catch (error) {
      debugPrint('Unable to play the incoming consultation ringtone: $error');
    }
  }

  Future<void> _stopPlayerSafely() async {
    _iosRepeatTimer?.cancel();
    _iosRepeatTimer = null;
    try {
      await _ringtonePlayer.stop();
    } catch (error) {
      debugPrint('Unable to stop the incoming consultation ringtone: $error');
    }
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
