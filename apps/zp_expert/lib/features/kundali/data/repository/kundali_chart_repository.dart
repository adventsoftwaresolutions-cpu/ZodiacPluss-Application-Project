import '../../../../shared/constants/app_assets.dart';
import '../models/kundali_chart_model.dart';

abstract interface class KundaliChartRepository {
  Future<KundaliChartData> getChart(KundaliChartRequest request);
}

class StubKundaliChartRepository implements KundaliChartRepository {
  const StubKundaliChartRepository();

  @override
  Future<KundaliChartData> getChart(KundaliChartRequest request) async {
    return KundaliChartData(
      svg: _chartSvg(request),
      title: _title(request),
      subtitle: _subtitle(request),
      planetShortForms: _planetShortForms,
      commonShortForms: _commonShortForms,
      readingTips: _readingTips,
    );
  }

  String _title(KundaliChartRequest request) {
    if (request.section == KundaliChartSection.divisional) {
      return '${request.division.shortLabel} ${request.division.label}';
    }
    return request.section.label;
  }

  String _subtitle(KundaliChartRequest request) {
    return switch (request.section) {
      KundaliChartSection.lagna => 'Birth chart · D1',
      KundaliChartSection.navamsa => 'Marriage and inner strength · D9',
      KundaliChartSection.transit => 'Current planetary movement · Gochar',
      KundaliChartSection.divisional => 'Focused divisional analysis',
    };
  }

  String _chartSvg(KundaliChartRequest request) {
    final labels = switch (request.section) {
      KundaliChartSection.lagna => _lagnaLabels,
      KundaliChartSection.navamsa => _navamsaLabels,
      KundaliChartSection.transit => _transitLabels,
      KundaliChartSection.divisional => switch (request.division) {
          KundaliDivision.saptamsa => _saptamsaLabels,
          KundaliDivision.dasamsa => _dasamsaLabels,
          KundaliDivision.dwadasamsa => _dwadasamsaLabels,
        },
    };

    return switch (request.style) {
      KundaliChartStyle.northIndian => _northIndianSvg(labels),
      KundaliChartStyle.southIndian => _southIndianSvg(labels),
      KundaliChartStyle.eastIndian => _eastIndianSvg(labels),
    };
  }

  static const _planetShortForms = [
    KundaliShortForm(
        shortForm: 'Su', label: 'Sun', asset: AppAssets.kundaliSun),
    KundaliShortForm(
        shortForm: 'Mo', label: 'Moon', asset: AppAssets.kundaliMoon),
    KundaliShortForm(
        shortForm: 'Ma', label: 'Mars', asset: AppAssets.kundaliMars),
    KundaliShortForm(
      shortForm: 'Me',
      label: 'Mercury',
      asset: AppAssets.kundaliMercury,
    ),
    KundaliShortForm(
      shortForm: 'Ju',
      label: 'Jupiter',
      asset: AppAssets.kundaliJupiter,
    ),
    KundaliShortForm(
        shortForm: 'Ve', label: 'Venus', asset: AppAssets.kundaliVenus),
    KundaliShortForm(
      shortForm: 'Sa',
      label: 'Saturn',
      asset: AppAssets.kundaliSaturn,
    ),
    KundaliShortForm(
        shortForm: 'Ra', label: 'Rahu', asset: AppAssets.kundaliRahu),
    KundaliShortForm(
        shortForm: 'Ke', label: 'Ketu', asset: AppAssets.kundaliKetu),
    KundaliShortForm(
      shortForm: 'Ur',
      label: 'Uranus',
      asset: AppAssets.kundaliUranus,
    ),
    KundaliShortForm(
      shortForm: 'Ne',
      label: 'Neptune',
      asset: AppAssets.kundaliNeptune,
    ),
    KundaliShortForm(
        shortForm: 'Pu', label: 'Pluto', asset: AppAssets.kundaliPluto),
  ];

  static const _commonShortForms = [
    KundaliShortForm(shortForm: 'Asc', label: 'Ascendant (Lagna)'),
    KundaliShortForm(shortForm: 'Ar', label: 'Aries'),
    KundaliShortForm(shortForm: 'Ta', label: 'Taurus'),
    KundaliShortForm(shortForm: 'Ge', label: 'Gemini'),
    KundaliShortForm(shortForm: 'Cn', label: 'Cancer'),
    KundaliShortForm(shortForm: 'Le', label: 'Leo'),
    KundaliShortForm(shortForm: 'Vi', label: 'Virgo'),
    KundaliShortForm(shortForm: 'Li', label: 'Libra'),
    KundaliShortForm(shortForm: 'Sc', label: 'Scorpio'),
    KundaliShortForm(shortForm: 'Sg', label: 'Sagittarius'),
    KundaliShortForm(shortForm: 'Cp', label: 'Capricorn'),
    KundaliShortForm(shortForm: 'Aq', label: 'Aquarius'),
    KundaliShortForm(shortForm: 'Pi', label: 'Pisces'),
  ];

  static const _readingTips = [
    'Ascendant (Asc) is the starting point of your birth chart.',
    'Numbers 1–12 identify the zodiac signs shown in each house.',
    'Planet abbreviations show which planets influence each house.',
    'Planet combinations may form yogas that an astrologer interprets.',
  ];

  static const _lagnaLabels = [
    'Asc',
    'Ke',
    'Su Ve',
    'Me Ju',
    'Mo',
    'Sa',
    'Ra',
    'Ma Ur',
    'Ne'
  ];
  static const _navamsaLabels = [
    'Asc Ju',
    'Sa',
    'Ra',
    'Mo',
    'Ve',
    'Ke',
    'Su',
    'Ma',
    'Me'
  ];
  static const _transitLabels = [
    'Asc',
    'Ju',
    'Ra',
    'Sa',
    'Mo',
    'Ke',
    'Ve',
    'Su Me',
    'Ma'
  ];
  static const _saptamsaLabels = [
    'Asc',
    'Mo',
    'Ju',
    'Sa',
    'Ra',
    'Ve',
    'Ke',
    'Ma',
    'Su Me'
  ];
  static const _dasamsaLabels = [
    'Asc Me',
    'Su',
    'Mo',
    'Ma',
    'Ju',
    'Ve',
    'Sa',
    'Ra',
    'Ke'
  ];
  static const _dwadasamsaLabels = [
    'Asc',
    'Ve',
    'Sa',
    'Ra',
    'Ke',
    'Mo',
    'Ma',
    'Ju',
    'Su Me'
  ];

  String _northIndianSvg(List<String> labels) => '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 500">
  <rect x="2" y="2" width="496" height="496" rx="24" fill="none" stroke="#78B63D" stroke-width="3"/>
  <path d="M2 2L498 498M498 2L2 498M2 250L250 2L498 250L250 498Z" fill="none" stroke="#78B63D" stroke-width="2"/>
  <g font-family="sans-serif" text-anchor="middle" font-size="20" fill="#202420">
    <text x="250" y="108">${labels[0]}</text><text x="365" y="64">${labels[1]}</text>
    <text x="424" y="124">${labels[2]}</text><text x="382" y="256">${labels[3]}</text>
    <text x="423" y="382">${labels[4]}</text><text x="330" y="445">${labels[5]}</text>
    <text x="150" y="445">${labels[6]}</text><text x="108" y="256">${labels[7]}</text>
    <text x="54" y="124">${labels[8]}</text>
  </g>
  <g font-family="sans-serif" text-anchor="middle" font-size="17" font-weight="600" fill="#202420">
    <text x="250" y="226">8</text><text x="218" y="256">11</text><text x="282" y="256">5</text><text x="250" y="288">2</text>
    <text x="126" y="112">9</text><text x="98" y="140">10</text><text x="374" y="112">7</text><text x="402" y="140">6</text>
    <text x="98" y="382">12</text><text x="126" y="410">1</text><text x="402" y="382">4</text><text x="374" y="410">3</text>
  </g>
</svg>''';

  String _southIndianSvg(List<String> labels) => '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 500">
  <rect x="2" y="2" width="496" height="496" rx="24" fill="none" stroke="#78B63D" stroke-width="3"/>
  <path d="M126 2V498M250 2V126M374 2V498M2 126H498M2 250H126M374 250H498M2 374H498M250 374V498" fill="none" stroke="#78B63D" stroke-width="2"/>
  <rect x="126" y="126" width="248" height="248" fill="none"/>
  <g font-family="sans-serif" text-anchor="middle" font-size="18" fill="#202420">
    <text x="64" y="70">${labels[0]}</text><text x="188" y="70">${labels[1]}</text><text x="312" y="70">${labels[2]}</text>
    <text x="436" y="70">${labels[3]}</text><text x="436" y="194">${labels[4]}</text><text x="436" y="318">${labels[5]}</text>
    <text x="436" y="442">${labels[6]}</text><text x="312" y="442">${labels[7]}</text><text x="188" y="442">${labels[8]}</text>
  </g>
  <text x="250" y="246" font-family="sans-serif" text-anchor="middle" font-size="24" font-weight="600" fill="#4B7F16">South Indian</text>
  <text x="250" y="278" font-family="sans-serif" text-anchor="middle" font-size="18" fill="#70766E">Fixed-sign layout</text>
</svg>''';

  String _eastIndianSvg(List<String> labels) => '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 500">
  <rect x="2" y="2" width="496" height="496" rx="24" fill="none" stroke="#78B63D" stroke-width="3"/>
  <path d="M250 2L498 250L250 498L2 250Z M250 2L250 498M2 250H498 M126 126L374 374M374 126L126 374" fill="none" stroke="#78B63D" stroke-width="2"/>
  <g font-family="sans-serif" text-anchor="middle" font-size="18" fill="#202420">
    <text x="250" y="72">${labels[0]}</text><text x="376" y="126">${labels[1]}</text><text x="430" y="256">${labels[2]}</text>
    <text x="376" y="386">${labels[3]}</text><text x="250" y="442">${labels[4]}</text><text x="126" y="386">${labels[5]}</text>
    <text x="70" y="256">${labels[6]}</text><text x="126" y="126">${labels[7]}</text><text x="250" y="256">${labels[8]}</text>
  </g>
</svg>''';
}
