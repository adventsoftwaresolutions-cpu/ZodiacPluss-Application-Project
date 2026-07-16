import '../data/expert_profile.dart';

class ExpertSpecializations {
  const ExpertSpecializations._();

  static const List<String> psychologist = <String>[
    'Stress Management',
    'Depression',
    'Self Esteem',
    'Anxiety',
    'Relationships',
    'Trauma Recovery',
    'Grief Support',
    'Sleep Issues',
    'Mindfulness',
    'Career Guidance',
    'Family Therapy',
    'Workplace Wellness',
  ];

  static const List<String> astrologer = <String>[
    'Vedic Astrology',
    'Birth Chart Reading',
    'Marriage & Compatibility',
    'Career Astrology',
    'Financial Astrology',
    'Numerology',
    'Palmistry',
    'Vastu Shastra',
    'Tarot Reading',
    'Prashna Kundali',
    'Gemstone Guidance',
    'Muhurat Selection',
  ];

  static const List<String> all = psychologist;

  static List<String> forRole(ExpertRole role) => switch (role) {
        ExpertRole.psychologist => psychologist,
        ExpertRole.astrologer => astrologer,
      };
}
