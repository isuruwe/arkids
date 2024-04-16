import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5365644610829153/4406252169';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5365644610829153/4406252169';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5365644610829153/1163628267';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5365644610829153/1163628267';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }


}