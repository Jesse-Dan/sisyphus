class AppAssets {
  static const String _pngPath = 'assets/pngs';
  static const String _svgPath = 'assets/svgs';
  static const String _logoPath = 'assets/logos';

  static String _path(String assetPath) => assetPath.endsWith('.svg')
      ? '$_svgPath/$assetPath'
      : '$_pngPath/$assetPath';

  /// Logos
  static String blackLogo = '$_logoPath/CLogoBlack.png';
  static String whiteLogo = '$_logoPath/CLogoWhite.png';

  /// Others Icons
  static String person = _path('person.png');
  static String web = _path('web.svg');
  static String menu = _path('Account+Tools.svg');
  static String dollar = _path('Crypto_Icons.svg');
  static String bitcoin = _path('Crypto_Icons_bitcoin.svg');
  static String time = _path('Time.svg');
  static String high = _path('Up.svg');
  static String low = _path('Down.svg');
  static String expand = _path('Expand.svg');
  static String chartIcon = _path('CandleChart.svg');
  static String priceViewRBG = _path('RBG.svg');
  static String priceViewBBG = _path('BBG.svg');
  static String priceViewRBB = _path('RBB.svg');
  static String indicatorIcon = _path('u_info-circle.svg');
  static String search = _path('Icon-Search.svg');
  static String dropdown = _path('dd.svg');
  static String clock = _path('Clock.svg');
  static String simpleDropdown = _path('simpleDropdown.svg');

  static Map<String, String> assetMaps = {
    "App Logo - Black": AppAssets.blackLogo,
    "App Logo - White": AppAssets.whiteLogo,
    "Person": AppAssets.person,
    "Web": AppAssets.web,
    "Menu": AppAssets.menu,
    "Dollar": AppAssets.dollar,
    "Bitcoin": AppAssets.bitcoin,
    "Time": AppAssets.time,
    "High": AppAssets.high,
    "Low": AppAssets.low,
    "Expand": AppAssets.expand,
    "Chart Icon": AppAssets.chartIcon,
    "Price View  - (RBG)": AppAssets.priceViewRBG,
    "Price View  - (BBG)": AppAssets.priceViewBBG,
    "Price View  - (RBB)": AppAssets.priceViewRBB,
    "Indicator Icon": AppAssets.indicatorIcon,
    "Search": AppAssets.search,
    "DropDown Icon": AppAssets.dropdown,
    "Clock Icon": AppAssets.clock,
    "Simple DropDown Icon": AppAssets.simpleDropdown,
  };
}
