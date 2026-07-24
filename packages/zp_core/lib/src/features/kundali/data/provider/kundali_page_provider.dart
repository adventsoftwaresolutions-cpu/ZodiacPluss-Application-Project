import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/kundali_page_section.dart';

final kundaliPageSectionProvider =
    StateProvider.autoDispose<KundaliPageSection>(
  (ref) => KundaliPageSection.charts,
);
