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

// ── Kundali Feature ───────────────────────────────────────────────────────────

// Models
export 'src/features/kundali/data/models/kundali_birth_data.dart';
export 'src/features/kundali/data/models/kundali_chart_model.dart';
export 'src/features/kundali/data/models/kundali_dosha_model.dart';
export 'src/features/kundali/data/models/kundali_page_section.dart';
export 'src/features/kundali/data/models/kundali_planet_model.dart';
export 'src/features/kundali/data/models/kundali_timing_model.dart';

// Engine-neutral repository and deterministic local implementation
export 'src/features/kundali/data/repository/kundali_repository.dart';
export 'src/features/kundali/data/repository/kundali_chart_repository.dart';
export 'src/features/kundali/data/repository/kundali_doshas_repository.dart';
export 'src/features/kundali/data/repository/kundali_planet_strength_calculator.dart';
export 'src/features/kundali/data/repository/kundali_planets_repository.dart';
export 'src/features/kundali/data/repository/kundali_timing_repository.dart';

// Providers
export 'src/features/kundali/data/provider/kundali_repository_provider.dart';
export 'src/features/kundali/data/provider/kundali_chart_provider.dart';
export 'src/features/kundali/data/provider/kundali_doshas_provider.dart';
export 'src/features/kundali/data/provider/kundali_page_provider.dart';
export 'src/features/kundali/data/provider/kundali_planets_provider.dart';
export 'src/features/kundali/data/provider/kundali_timing_provider.dart';

// Presentation
export 'src/features/kundali/presentation/kundali_theme.dart';
export 'src/features/kundali/presentation/kundali_view.dart';
export 'src/features/kundali/presentation/widgets/kundali_chart_panel.dart';
export 'src/features/kundali/presentation/widgets/kundali_chart_reveal.dart';
export 'src/features/kundali/presentation/widgets/kundali_content.dart';
export 'src/features/kundali/presentation/widgets/kundali_current_dasha_card.dart';
export 'src/features/kundali/presentation/widgets/kundali_dasha_timeline.dart';
export 'src/features/kundali/presentation/widgets/kundali_dosha_result_card.dart';
export 'src/features/kundali/presentation/widgets/kundali_doshas_body.dart';
export 'src/features/kundali/presentation/widgets/kundali_doshas_loading.dart';
export 'src/features/kundali/presentation/widgets/kundali_doshas_overview.dart';
export 'src/features/kundali/presentation/widgets/kundali_info_card.dart';
export 'src/features/kundali/presentation/widgets/kundali_loading_skeleton.dart';
export 'src/features/kundali/presentation/widgets/kundali_papa_samyam_card.dart';
export 'src/features/kundali/presentation/widgets/kundali_planet_strengths.dart';
export 'src/features/kundali/presentation/widgets/kundali_planets_body.dart';
export 'src/features/kundali/presentation/widgets/kundali_planets_loading.dart';
export 'src/features/kundali/presentation/widgets/kundali_planets_table.dart';
export 'src/features/kundali/presentation/widgets/kundali_primary_navigation.dart';
export 'src/features/kundali/presentation/widgets/kundali_reference_cards.dart';
export 'src/features/kundali/presentation/widgets/kundali_sade_sati_card.dart';
export 'src/features/kundali/presentation/widgets/kundali_shimmer_box.dart';
export 'src/features/kundali/presentation/widgets/kundali_timing_body.dart';
export 'src/features/kundali/presentation/widgets/kundali_timing_loading.dart';
export 'src/shared/constants/kundali_assets.dart';
