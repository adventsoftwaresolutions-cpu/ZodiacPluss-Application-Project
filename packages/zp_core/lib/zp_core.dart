/// zp_core — Shared core package for ZodiacPluss.
///
/// This is the single entry point for consuming apps. Nothing inside
/// `lib/src/` should be imported directly.
library zp_core;

// ── Call Room Feature ──────────────────────────────────────────────────────────

// Models
export 'src/features/call_room/data/models/call_room_model.dart';

// Repository (abstract interface only)
export 'src/features/call_room/data/repository/call_room_repository.dart';

// Providers
export 'src/features/call_room/data/provider/call_room_provider.dart';
export 'src/features/call_room/data/provider/call_media_controller.dart';

// Presentation — content-only view
export 'src/features/call_room/presentation/call_room_view.dart';

// Presentation — widgets
export 'src/features/call_room/presentation/widgets/audio_call_room_view.dart';
export 'src/features/call_room/presentation/widgets/video_call_room_view.dart';
export 'src/features/call_room/presentation/widgets/call_controls.dart';
export 'src/features/call_room/presentation/widgets/call_action_panel.dart';
export 'src/features/call_room/presentation/widgets/call_participant_avatar.dart';
export 'src/features/call_room/presentation/widgets/call_status_text.dart';
export 'src/features/call_room/presentation/widgets/call_invitation_effects.dart';
export 'src/features/call_room/presentation/widgets/call_room_join_card.dart';
