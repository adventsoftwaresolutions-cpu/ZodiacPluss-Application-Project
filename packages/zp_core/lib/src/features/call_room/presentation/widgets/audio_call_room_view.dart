import 'package:flutter/material.dart';

import '../../data/models/call_room_model.dart';
import 'call_action_panel.dart';
import 'call_controls.dart';
import 'call_participant_avatar.dart';
import 'call_status_text.dart';

/// Full-screen audio call room UI with gradient background and waveform.
///
/// This is a content-only widget — it does not own a [Scaffold] or route.
/// The consuming app wraps it in its own [Scaffold] and routing setup.
class AudioCallRoomView extends StatelessWidget {
  const AudioCallRoomView({
    required this.session,
    required this.onToggleMute,
    required this.onToggleSpeaker,
    required this.onMessage,
    required this.onEndCall,
    required this.onLeave,
    super.key,
  });

  final CallSessionState session;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleSpeaker;
  final VoidCallback onMessage;
  final VoidCallback onEndCall;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colors.primary,
            Color.lerp(colors.primary, colors.secondary, .42)!,
            Color.lerp(colors.primary, Colors.black, .7)!,
          ],
          stops: const <double>[0, .44, 1],
        ),
      ),
      child: Stack(
        children: <Widget>[
          const Positioned(
            left: -90,
            top: 130,
            child: _AmbientGlow(diameter: 250),
          ),
          const Positioned(
            right: -120,
            bottom: 90,
            child: _AmbientGlow(diameter: 300),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.paddingOf(context).top + 20,
              20,
              MediaQuery.paddingOf(context).bottom + 24,
            ),
            child: Column(
              children: <Widget>[
                _CallRoomTopBar(
                  title: 'Audio consultation',
                  session: session,
                ),
                const Spacer(),
                CallParticipantAvatar(
                  name: session.room.clientName,
                  animate: session.phase != CallSessionPhase.ended,
                ),
                const SizedBox(height: 22),
                Text(
                  session.room.clientName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.4,
                      ),
                ),
                const SizedBox(height: 10),
                _AudioWaveform(
                  active: session.phase != CallSessionPhase.ended,
                ),
                const SizedBox(height: 10),
                CallStatusText(session: session),
                const Spacer(),
                CallActionPanel(
                  ended: session.phase == CallSessionPhase.ended,
                  onLeave: onLeave,
                  controls: CallControls(
                    isMuted: session.isMuted,
                    isSpeakerOn: session.isSpeakerOn,
                    onToggleMute: onToggleMute,
                    onToggleSpeaker: onToggleSpeaker,
                    onMessage: onMessage,
                    onEndCall: onEndCall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: .11),
                Colors.transparent,
              ],
            ),
          ),
        ),
      );
}

class _AudioWaveform extends StatefulWidget {
  const _AudioWaveform({required this.active});

  final bool active;

  @override
  State<_AudioWaveform> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<_AudioWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.active) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _AudioWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active == widget.active) return;
    if (widget.active) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) => Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List<Widget>.generate(5, (int index) {
            final double phase = (_controller.value + index * .17) % 1;
            return Container(
              width: 3,
              height: 7 + (phase * 15),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary
                    .withValues(alpha: .75),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      );
}

class _CallRoomTopBar extends StatelessWidget {
  const _CallRoomTopBar({required this.title, required this.session});

  final String title;
  final CallSessionState session;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.scrim.withValues(alpha: .18),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: .14),
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.lock_rounded,
                size: 17, color: Theme.of(context).colorScheme.onPrimary),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (session.room.paidMinutes > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${session.room.paidMinutes} min paid',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      );
}
