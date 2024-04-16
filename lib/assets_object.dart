import 'dart:io';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'AdHelper.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) =>  AssetsObject()),
    );
  }



  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: false,
      autoScrollDuration: null,
      infiniteAutoScroll: false,
      // globalHeader: Align(
      //   alignment: Alignment.topRight,
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.only(top: 16, right: 16),
      //       child: _buildImage('logo.png', 100),
      //     ),
      //   ),
      // ),
      // globalFooter: SizedBox(
      //   width: double.infinity,
      //   height: 60,
      //   child: ElevatedButton(
      //     child: const Text(
      //       'Let\'s go right away!',
      //       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      //     ),
      //     onPressed: () => _onIntroEnd(context),
      //   ),
      // ),
      pages: [
        PageViewModel(
          title: "Parental Supervision",
          body:
          "Parents and guardians, please note that while using Augmented Reality, "
              "there is a tendency for kids to be unaware of their surroundings. Therefore,"
              " proper parental supervision is advised",
          image: _buildImage('parent.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Be aware of physical hazards",
          body:
          "Be aware of physical hazards in the real world when using the app",
          image: _buildImage('safty.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Don't use with other Devices",
          body:
          "Please ensure that app does not use with devices that are not recommended for children",
          image: _buildImage('surr.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Wait until floor is detected",
          body:
          "Please ensure that floor is detected before click on screen, if floor not detected 3d model will not place.First turn camera towards floor and look around and you will see white dots,the you can click on the area and place models.",
          image: _buildImage('ins1.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
     skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}








class AssetsObject extends StatefulWidget {
  @override
  _AssetsObjectState createState() => _AssetsObjectState();
}

class _AssetsObjectState extends State<AssetsObject> {
  ArCoreController? arCoreController;

  String? objectSelected;

  bool _isBannerAdReady = false;
  late BannerAd _bannerAd;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  num get maxFailedLoadAttempts => 100;
  int cnt1=0;
  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? AdHelper.interstitialAdUnitId
            : AdHelper.interstitialAdUnitId,
        request:  AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);


          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
  @override
  void initState() {

    super.initState();



    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
    _createInterstitialAd();

  }



  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0.0,
      child: new Padding(
        padding: const EdgeInsets.all(1.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isBannerAdReady)
            //  Align(
            //   alignment: Alignment.bottomCenter,
            // child:
              Container(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),



          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AR Kids 3D Models'),
        ),
        body: Stack(
          children: <Widget>[
            ArCoreView(
              onArCoreViewCreated: _onArCoreViewCreated,
              enableTapRecognizer: true,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ListObjectSelection(
                onTap: (value) {
                  objectSelected = value;
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:  _buildBottomBar(),
            ),

          ],
        ),

      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController?.onNodeTap = (name) => onTapHandler(name);
    arCoreController?.onPlaneTap = _handleOnPlaneTap;
  }

  void _addToucano(ArCoreHitTestResult plane) {
    if (objectSelected != null) {
      //"https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF/Duck.gltf"
      final toucanoNode = ArCoreReferenceNode(
          name: objectSelected,
          object3DFileName: objectSelected,
          position: plane.pose.translation,
          rotation: plane.pose.rotation);

      arCoreController?.addArCoreNodeWithAnchor(toucanoNode);
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(content: Text('Select an object!')),
      );
    }
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    if (cnt1 == 5) {
      _showInterstitialAd();
      cnt1 = 0;
    }
    else {
      cnt1++;
    }

    _addToucano(hit);
  }

  void onTapHandler(String name) {
    print("Flutter: onNodeTap");
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Row(
          children: <Widget>[
            Text('Remove $name?'),
            IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  arCoreController?.removeNode(nodeName: name);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }
}

class ListObjectSelection extends StatefulWidget {
  final Function? onTap;

  ListObjectSelection({this.onTap});

  @override
  _ListObjectSelectionState createState() => _ListObjectSelectionState();
}

class _ListObjectSelectionState extends State<ListObjectSelection> {
  List<String> gifs = [

    'assets/fish.jpg',
    'assets/dog.jpg',
    'assets/pen.jpg',
    'assets/kan.jpg',
    'assets/lioness.jpg',
    'assets/parot.jpg',
    'assets/horse.jpg',
    'assets/sea.jpg',
    'assets/snake.jpg',
    'assets/swan.jpg',
    'assets/wolf.jpg',
    'assets/ant.jpg',
    'assets/bear.jpg',
    'assets/cat.jpg',
    'assets/deer.png',
   // 'assets/car.jpg',
    'assets/TocoToucan.gif',
    'assets/chair.jpg',
    'assets/girl.jpg',
    'assets/ironman.jpg',
    'assets/mario.jpg',
    'assets/Sonic.jpg',
    'assets/plane.jpg',
    'assets/robodog.jpg',
    'assets/orange.jpg',
    'assets/melon.jpg',
    'assets/apple.png',
    'assets/air.jpg',
    'assets/heli.png',
  ];

  List<String> objectsFileName = [

    'fish.sfb',
    'dog.sfb',
    'pen.sfb',
    'kan.sfb',
    'lioness.sfb',
    'parot.sfb',
    'horse.sfb',
    'sea.sfb',
    'snake.sfb',
    'swan.sfb',
    'wolf.sfb',
    'ant.sfb',
    'bear.sfb',
    'cat.sfb',
    'deer.sfb',
    //'car.sfb',
    'toucan.sfb',
    'chairss.sfb',
    'girl3.sfb',
    'IronMan.sfb',
    'Mario.sfb',
    'Sonic.sfb',
    'air.sfb',
    'UselessDog.sfb',
    'orange.sfb',
    'melon.sfb',
    'apple.sfb',
    'air2.sfb',
    'heli.sfb',
  ];

  String? selected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      child: ListView.builder(
        itemCount: gifs.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = gifs[index];
                widget.onTap?.call(objectsFileName[index]);
              });
            },
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Container(
                color:
                    selected == gifs[index] ? Colors.red : Colors.transparent,
                padding: selected == gifs[index] ? EdgeInsets.all(8.0) : null,
                child: Image.asset(gifs[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
