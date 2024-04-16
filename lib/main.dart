import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app.dart';
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart'
    show ArCoreController;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final requestConfiguration = RequestConfiguration(
    tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
    maxAdContentRating: MaxAdContentRating.g,
  );

  // Set the request configuration
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);


  print('ARCORE IS AVAILABLE?');
  print(await ArCoreController.checkArCoreAvailability());
  print('\nAR SERVICES INSTALLED?');
  print(await ArCoreController.checkIsArCoreInstalled());
  runApp(App());
}
