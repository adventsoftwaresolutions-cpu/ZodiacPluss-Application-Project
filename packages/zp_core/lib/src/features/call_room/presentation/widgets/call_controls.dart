import 'package:flutter/material.dart';

/// Row of call-control buttons (mute, speaker, video, message, end-call).
class CallControls extends StatelessWidget {
  const CallControls({
    required this.isMuted,
    required this.isSpeakerOn,
    required this.onToggleMute,
    required this.onToggleSpeaker,
    required this.onMessage,
    required this.onEndCall,
    this.isVideoOn,
    this.onToggleVideo,
    super.key,
  });

  final bool isMuted;
  final bool isSpeakerOn;
  final bool? isVideoOn;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleSpeaker;
  final VoidCallback? onToggleVideo;
  final VoidCallback onMessage;
  final VoidCallback onEndCall;

  @override
  Widget build(BuildContext context) => Wrap(
        alignment: WrapAlignment.center,
        spacing: 14,
        runSpacing: 12,
        children: <Widget>[
          if (onToggleVideo != null)
            _CallControlButton(
              key: const ValueKey<String>('toggle-video-button'),
              icon: isVideoOn ?? true
                  ? Icons.videocam_rounded
                  : Icons.videocam_off_rounded,
              label: isVideoOn ?? true ? 'Video' : 'Video off',
              selected: !(isVideoOn ?? true),
              onTap: onToggleVideo!,
            ),
          _CallControlButton(
            key: const ValueKey<String>('toggle-speaker-button'),
            icon: isSpeakerOn
                ? Icons.volume_up_rounded
                : Icons.volume_off_rounded,
            label: isSpeakerOn ? 'Speaker' : 'Earpiece',
            selected: isSpeakerOn,
            onTap: onToggleSpeaker,
          ),
          _CallControlButton(
            key: const ValueKey<String>('toggle-mute-button'),
            icon: isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            label: isMuted ? 'Muted' : 'Mute',
            selected: isMuted,
            onTap: onToggleMute,
          ),
          _CallControlButton(
            key: const ValueKey<String>('call-message-button'),
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Message',
            onTap: onMessage,
          ),
          _CallControlButton(
            key: const ValueKey<String>('drop-call-button'),
            icon: Icons.call_end_rounded,
            label: 'Drop',
            destructive: true,
            onTap: onEndCall,
          ),
        ],
      );
}

class _CallControlButton extends StatelessWidget {
  const _CallControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.destructive = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color background = destructive
        ? colors.error
        : selected
            ? colors.primary
            : colors.surface.withValues(alpha: .18);
    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: SizedBox(
          width: 58,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedScale(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                scale: selected || destructive ? 1 : .96,
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkResponse(
                    onTap: onTap,
                    radius: 32,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: background,
                        shape: BoxShape.circle,
                        border: destructive || selected
                            ? null
                            : Border.all(
                                color: colors.onPrimary.withValues(alpha: .24),
                              ),
                        boxShadow: destructive
                            ? <BoxShadow>[
                                BoxShadow(
                                  color: colors.error.withValues(alpha: .42),
                                  blurRadius: 16,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Icon(
                          icon,
                          key: ValueKey<IconData>(icon),
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  color: colors.onPrimary.withValues(
                    alpha: selected || destructive ? 1 : .78,
                  ),
                  fontSize: 10,
                  fontWeight: selected || destructive
                      ? FontWeight.w700
                      : FontWeight.w600,
                ),
                child: Text(label, maxLines: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
