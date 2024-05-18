import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveAnimationControllerHelper {
  // Singleton class for managing Rive animation controllers.
  // This class ensures that only one instance is created throughout
  // the application's lifecycle, allowing easy access to animation
  // controllers across different parts of the app without the need
  // to recreate them. The Singleton pattern is used to maintain
  // consistency and avoid unnecessary resource consumption.

  static final RiveAnimationControllerHelper _instance =
      RiveAnimationControllerHelper._internal();

  factory RiveAnimationControllerHelper() {
    return _instance;
  }

  RiveAnimationControllerHelper._internal();

  Artboard? _riveArtboard;
  
  late RiveAnimationController _controllerIdle;
  late RiveAnimationController _controllerHandsUp;
  late RiveAnimationController _controllerHandsDown;
  late RiveAnimationController _controllerSuccess;
  late RiveAnimationController _controllerFail;
  late RiveAnimationController _controllerLookDownRight;
  late RiveAnimationController _controllerLookDownLeft;

  bool isLookingRight = false;
  bool isLookingLeft = false;

  Artboard? get riveArtboard => _riveArtboard;

  void addController(RiveAnimationController controller) {
    removeAllControllers();
    _riveArtboard?.addController(controller);
  }

  void addDownLeftController() {
    addController(_controllerLookDownLeft);
    isLookingLeft = true;
  }

  void addDownRightController() {
    addController(_controllerLookDownRight);
    isLookingRight = true;
  }

  void addFailController() => addController(_controllerFail);

  void addHandsDownController() => addController(_controllerHandsDown);

  void addHandsUpController() => addController(_controllerHandsUp);

  void addSuccessController() => addController(_controllerSuccess);

  Future<void> loadRiveFile(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final file = RiveFile.import(data);
    _riveArtboard = file.mainArtboard;

    _controllerIdle = SimpleAnimation('idle');
    _controllerHandsUp = SimpleAnimation('Hands_up');
    _controllerHandsDown = SimpleAnimation('hands_down');
    _controllerSuccess = SimpleAnimation('success');
    _controllerFail = SimpleAnimation('fail');
    _controllerLookDownRight = SimpleAnimation('Look_down_right');
    _controllerLookDownLeft = SimpleAnimation('Look_down_left');

    _riveArtboard?.addController(_controllerIdle);
  }

  void removeAllControllers() {
    final listOfControllers = [
      _controllerIdle,
      _controllerHandsUp,
      _controllerHandsDown,
      _controllerSuccess,
      _controllerFail,
      _controllerLookDownRight,
      _controllerLookDownLeft,
    ];
    for (var controller in listOfControllers) {
      _riveArtboard?.removeController(controller);
    }
    isLookingLeft = false;
    isLookingRight = false;
  }

  void dispose() {
    removeAllControllers();
    _controllerIdle.dispose();
    _controllerHandsUp.dispose();
    _controllerHandsDown.dispose();
    _controllerSuccess.dispose();
    _controllerFail.dispose();
    _controllerLookDownRight.dispose();
    _controllerLookDownLeft.dispose();
  }
}
