enum KundaliChartSection {
  lagna('Lagna', 'lagna'),
  navamsa('Navamsa', 'navamsa'),
  transit('Transit', 'transit'),
  divisional('Divisional', 'dasamsa');

  const KundaliChartSection(this.label, this.calculationKey);

  final String label;
  final String calculationKey;
}

enum KundaliChartStyle {
  northIndian('North Indian', 'north-indian'),
  southIndian('South Indian', 'south-indian'),
  eastIndian('East Indian', 'east-indian');

  const KundaliChartStyle(this.label, this.calculationKey);

  final String label;
  final String calculationKey;
}

enum KundaliDivision {
  saptamsa('D7', 'Saptamsa', 'saptamsa'),
  dasamsa('D10', 'Dashamsa', 'dasamsa'),
  dwadasamsa('D12', 'Dwadashamsa', 'dwadasamsa');

  const KundaliDivision(this.shortLabel, this.label, this.calculationKey);

  final String shortLabel;
  final String label;
  final String calculationKey;
}

class KundaliChartRequest {
  const KundaliChartRequest({
    required this.section,
    required this.style,
    this.division = KundaliDivision.dasamsa,
  });

  final KundaliChartSection section;
  final KundaliChartStyle style;
  final KundaliDivision division;

  String get chartType => section == KundaliChartSection.divisional
      ? division.calculationKey
      : section.calculationKey;

  Map<String, dynamic> toJson() => {
        'chart_type': chartType,
        'chart_style': style.calculationKey,
        'format': 'svg',
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KundaliChartRequest &&
          section == other.section &&
          style == other.style &&
          division == other.division;

  @override
  int get hashCode => Object.hash(section, style, division);
}

class KundaliChartData {
  const KundaliChartData({
    required this.svg,
    required this.title,
    required this.subtitle,
    required this.planetShortForms,
    required this.commonShortForms,
    required this.readingTips,
  });

  factory KundaliChartData.fromJson(Map<String, dynamic> json) {
    return KundaliChartData(
      svg: json['svg'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      planetShortForms: (json['planet_short_forms'] as List<dynamic>)
          .map(
              (item) => KundaliShortForm.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      commonShortForms: (json['common_short_forms'] as List<dynamic>)
          .map(
              (item) => KundaliShortForm.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      readingTips: (json['reading_tips'] as List<dynamic>)
          .map((item) => item as String)
          .toList(growable: false),
    );
  }

  final String svg;
  final String title;
  final String subtitle;
  final List<KundaliShortForm> planetShortForms;
  final List<KundaliShortForm> commonShortForms;
  final List<String> readingTips;

  Map<String, dynamic> toJson() => {
        'svg': svg,
        'title': title,
        'subtitle': subtitle,
        'planet_short_forms':
            planetShortForms.map((item) => item.toJson()).toList(),
        'common_short_forms':
            commonShortForms.map((item) => item.toJson()).toList(),
        'reading_tips': readingTips,
      };
}

class KundaliShortForm {
  const KundaliShortForm({
    required this.shortForm,
    required this.label,
    this.asset,
  });

  factory KundaliShortForm.fromJson(Map<String, dynamic> json) {
    return KundaliShortForm(
      shortForm: json['short_form'] as String,
      label: json['label'] as String,
      asset: json['asset'] as String?,
    );
  }

  final String shortForm;
  final String label;
  final String? asset;

  Map<String, dynamic> toJson() => {
        'short_form': shortForm,
        'label': label,
        'asset': asset,
      };
}
