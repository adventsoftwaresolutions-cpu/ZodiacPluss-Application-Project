abstract final class KundaliAssets {
  static const String _root = 'packages/zp_core/assets/icons/kundali';

  static const String sun = '$_root/sun.svg';
  static const String moon = '$_root/moon.svg';
  static const String mars = '$_root/mars.svg';
  static const String mercury = '$_root/mercury.svg';
  static const String jupiter = '$_root/jupiter.svg';
  static const String venus = '$_root/venus.svg';
  static const String saturn = '$_root/saturn.svg';
  static const String rahu = '$_root/rahu.svg';
  static const String ketu = '$_root/ketu.svg';
  static const String uranus = '$_root/uranus.svg';
  static const String neptune = '$_root/neptune.svg';
  static const String pluto = '$_root/pluto.svg';

  static String forPlanetName(String name) => switch (name) {
        'sun' => sun,
        'moon' => moon,
        'mars' => mars,
        'mercury' => mercury,
        'jupiter' => jupiter,
        'venus' => venus,
        'saturn' => saturn,
        'rahu' => rahu,
        'ketu' => ketu,
        'uranus' => uranus,
        'neptune' => neptune,
        'pluto' => pluto,
        _ => '',
      };
}
