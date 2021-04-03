import 'package:mafya/core/init/transformer_page_view/another_transformer_page_view.dart';

class SliderCarouselController extends IndexController {
  // Autoplay is started
  static const int START_AUTOPLAY = 2;

  // Autoplay is stopped.
  static const int STOP_AUTOPLAY = 3;

  // Indicate that the user is swiping
  static const int SWIPE = 4;

  // Indicate that the `SliderCarousel` has changed it's index and is building it's ui ,so that the
  // `SliderCarouselPluginConfig` is available.
  static const int BUILD = 5;

  // available when `event` == SliderCarouselController.SWIPE
  // this value is PageViewController.pos
  late double pos;

  int? index;
  late bool animation;
  bool? autoplay;

  SliderCarouselController();

  void startAutoplay() {
    event = SliderCarouselController.START_AUTOPLAY;
    this.autoplay = true;
    notifyListeners();
  }

  void stopAutoplay() {
    event = SliderCarouselController.STOP_AUTOPLAY;
    this.autoplay = false;
    notifyListeners();
  }
}
